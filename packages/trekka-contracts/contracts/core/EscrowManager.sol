// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title EscrowManager
 * @notice Handles all escrow operations for the Trekka P2P platform
 * @dev Used by all services (RideHailing, Marketplace, etc.)
 */
contract EscrowManager is ReentrancyGuard {
    struct Escrow {
        address payer;
        uint256 amount;
        bool exists;
        bool released;
        address authorizedService; // Service that created this escrow
    }

    mapping(bytes32 => Escrow) public escrows;
    mapping(address => bool) public authorizedServices;

    address public owner;
    uint256 public totalEscrowed;

    event EscrowCreated(
        bytes32 indexed escrowId,
        address indexed payer,
        uint256 amount,
        address service
    );
    event EscrowReleased(
        bytes32 indexed escrowId,
        address indexed recipient,
        uint256 amount
    );
    event EscrowRefunded(
        bytes32 indexed escrowId,
        address indexed payer,
        uint256 amount
    );
    event ServiceAuthorized(address indexed service);
    event ServiceRevoked(address indexed service);
    event EmergencyWithdrawal(
        address indexed operator,
        address indexed recipient,
        uint256 amount
    );
    event DirectDeposit(address indexed sender, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyAuthorizedService() {
        require(authorizedServices[msg.sender], "Service not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        emit DirectDeposit(msg.sender, msg.value);
    }

    /**
     * @notice Authorize a service contract to use escrow
     */
    function authorizeService(address service) external onlyOwner {
        require(service != address(0), "Invalid address");
        authorizedServices[service] = true;
        emit ServiceAuthorized(service);
    }

    /**
     * @notice Revoke service authorization
     */
    function revokeService(address service) external onlyOwner {
        authorizedServices[service] = false;
        emit ServiceRevoked(service);
    }

    /**
     * @notice Create an escrow
     */
    function createEscrow(
        bytes32 escrowId,
        address payer,
        uint256 amount
    ) external payable onlyAuthorizedService nonReentrant {
        require(!escrows[escrowId].exists, "Escrow already exists");
        require(msg.value == amount, "Amount mismatch");
        require(amount > 0, "Amount must be greater than 0");

        escrows[escrowId] = Escrow({
            payer: payer,
            amount: amount,
            exists: true,
            released: false,
            authorizedService: msg.sender
        });

        totalEscrowed += amount;

        emit EscrowCreated(escrowId, payer, amount, msg.sender);
    }

    /**
     * @notice Release escrow to recipient
     */
    function releaseEscrow(
        bytes32 escrowId,
        address recipient
    ) external onlyAuthorizedService nonReentrant {
        Escrow storage escrow = escrows[escrowId];
        require(escrow.exists, "Escrow does not exist");
        require(!escrow.released, "Escrow already released");
        require(
            escrow.authorizedService == msg.sender,
            "Not authorized for this escrow"
        );
        require(recipient != address(0), "Invalid recipient");

        escrow.released = true;
        uint256 amount = escrow.amount;
        escrow.amount = 0;
        totalEscrowed -= amount;

        (bool success, ) = payable(recipient).call{value: amount}("");
        require(success, "Transfer failed");

        emit EscrowReleased(escrowId, recipient, amount);
    }

    /**
     * @notice Refund escrow to payer
     */
    function refundEscrow(
        bytes32 escrowId
    ) external onlyAuthorizedService nonReentrant {
        Escrow storage escrow = escrows[escrowId];
        require(escrow.exists, "Escrow does not exist");
        require(!escrow.released, "Escrow already released");
        require(
            escrow.authorizedService == msg.sender,
            "Not authorized for this escrow"
        );

        escrow.released = true;
        uint256 amount = escrow.amount;
        address payer = escrow.payer;
        escrow.amount = 0;
        totalEscrowed -= amount;

        (bool success, ) = payable(payer).call{value: amount}("");
        require(success, "Refund failed");

        emit EscrowRefunded(escrowId, payer, amount);
    }

    /**
     * @notice Get escrow amount
     */
    function getEscrowAmount(bytes32 escrowId) external view returns (uint256) {
        return escrows[escrowId].amount;
    }

    /**
     * @notice Check if escrow exists
     */
    function escrowExists(bytes32 escrowId) external view returns (bool) {
        return escrows[escrowId].exists;
    }

    /**
     * @notice Get total escrowed amount
     */
    function getTotalEscrowed() external view returns (uint256) {
        return totalEscrowed;
    }

    /**
     * @notice Emergency withdraw excess funds not tracked in escrow
     */
    function emergencyWithdraw(
        address recipient,
        uint256 amount
    ) external onlyOwner nonReentrant {
        require(recipient != address(0), "Invalid recipient");
        uint256 available = address(this).balance - totalEscrowed;
        require(amount <= available, "Insufficient excess balance");

        (bool success, ) = payable(recipient).call{value: amount}("");
        require(success, "Emergency withdraw failed");

        emit EmergencyWithdrawal(msg.sender, recipient, amount);
    }
}
