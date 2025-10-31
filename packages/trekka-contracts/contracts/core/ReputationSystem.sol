// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title ReputationSystem
 * @notice Manages user reputation/points across all services
 */
contract ReputationSystem is ReentrancyGuard {
    mapping(address => uint256) public points;
    mapping(address => bool) public authorizedServices;

    address public owner;

    event PointsAdded(address indexed user, uint256 points, uint256 newTotal);
    event PointsDeducted(
        address indexed user,
        uint256 points,
        uint256 newTotal
    );
    event ServiceAuthorized(address indexed service);
    event ServiceRevoked(address indexed service);

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

    /**
     * @notice Authorize a service contract
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
     * @notice Add points to user
     */
    function addPoints(
        address user,
        uint256 amount
    ) external onlyAuthorizedService {
        require(user != address(0), "Invalid user");
        points[user] += amount;
        emit PointsAdded(user, amount, points[user]);
    }

    /**
     * @notice Deduct points from user
     */
    function deductPoints(
        address user,
        uint256 amount
    ) external onlyAuthorizedService {
        require(user != address(0), "Invalid user");
        if (points[user] >= amount) {
            points[user] -= amount;
        } else {
            points[user] = 0;
        }
        emit PointsDeducted(user, amount, points[user]);
    }

    /**
     * @notice Get user points
     */
    function getPoints(address user) external view returns (uint256) {
        return points[user];
    }
}
