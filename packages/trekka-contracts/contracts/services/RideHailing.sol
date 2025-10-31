// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "../interfaces/IEscrowManager.sol";
import "../interfaces/IReputationSystem.sol";

/**
 * @title RideHailing
 * @notice Ride hailing service for Trekka P2P Platform
 * @dev References core infrastructure contracts
 */
contract RideHailing is ReentrancyGuard {
    enum RideStatus {
        Requested,
        Accepted,
        Completed,
        CanceledByRider,
        CanceledByDriver
    }

    struct Ride {
        bytes32 id;
        address rider;
        address driver;
        uint256 amount;
        RideStatus status;
        uint256 requestedAt;
        uint256 acceptedAt;
        uint256 completedAt;
        bool exists;
    }

    // Core contract references
    IEscrowManager public escrowManager;
    IReputationSystem public reputationSystem;

    mapping(bytes32 => Ride) public rides;

    address public owner;
    uint256 public totalRides;
    uint256 public completedRides;

    event RideRequested(
        bytes32 indexed rideId,
        address indexed rider,
        uint256 amount,
        uint256 timestamp
    );
    event RideAccepted(
        bytes32 indexed rideId,
        address indexed driver,
        uint256 timestamp
    );
    event RideCanceled(
        bytes32 indexed rideId,
        address indexed canceledBy,
        RideStatus status,
        uint256 timestamp
    );
    event RideCompleted(
        bytes32 indexed rideId,
        address indexed rider,
        address indexed driver,
        uint256 amount,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier rideExists(bytes32 _rideId) {
        require(rides[_rideId].exists, "Ride does not exist");
        _;
    }

    modifier onlyRider(bytes32 _rideId) {
        require(msg.sender == rides[_rideId].rider, "Only rider");
        _;
    }

    modifier onlyDriver(bytes32 _rideId) {
        require(msg.sender == rides[_rideId].driver, "Only assigned driver");
        _;
    }

    /**
     * @notice Constructor - pass core contract addresses
     */
    constructor(address _escrowManager, address _reputationSystem) {
        require(_escrowManager != address(0), "Invalid escrow address");
        require(_reputationSystem != address(0), "Invalid reputation address");

        owner = msg.sender;
        escrowManager = IEscrowManager(_escrowManager);
        reputationSystem = IReputationSystem(_reputationSystem);
    }

    /**
     * @notice Request a new ride
     */
    function requestRide(bytes32 _rideId) external payable nonReentrant {
        require(!rides[_rideId].exists, "Ride ID already exists");
        require(msg.value > 0, "Amount must be greater than 0");

        // Create escrow in core contract
        escrowManager.createEscrow{value: msg.value}(
            _rideId,
            msg.sender,
            msg.value
        );

        rides[_rideId] = Ride({
            id: _rideId,
            rider: msg.sender,
            driver: address(0),
            amount: msg.value,
            status: RideStatus.Requested,
            requestedAt: block.timestamp,
            acceptedAt: 0,
            completedAt: 0,
            exists: true
        });

        totalRides++;

        emit RideRequested(_rideId, msg.sender, msg.value, block.timestamp);
    }

    /**
     * @notice Driver accepts a ride
     */
    function acceptRide(
        bytes32 _rideId
    ) external rideExists(_rideId) nonReentrant {
        Ride storage ride = rides[_rideId];

        require(ride.status == RideStatus.Requested, "Ride not available");
        require(ride.driver == address(0), "Ride already has driver");
        require(msg.sender != ride.rider, "Rider cannot accept own ride");

        ride.driver = msg.sender;
        ride.status = RideStatus.Accepted;
        ride.acceptedAt = block.timestamp;

        emit RideAccepted(_rideId, msg.sender, block.timestamp);
    }

    /**
     * @notice Rider cancels ride
     */
    function cancelRideByRider(
        bytes32 _rideId
    ) external rideExists(_rideId) onlyRider(_rideId) nonReentrant {
        Ride storage ride = rides[_rideId];

        require(
            ride.status == RideStatus.Requested ||
                ride.status == RideStatus.Accepted,
            "Cannot cancel"
        );

        // Deduct point only if ride was accepted
        if (ride.status == RideStatus.Accepted) {
            reputationSystem.deductPoints(msg.sender, 1);
        }

        ride.status = RideStatus.CanceledByRider;

        // Refund through escrow manager
        escrowManager.refundEscrow(_rideId);

        emit RideCanceled(
            _rideId,
            msg.sender,
            RideStatus.CanceledByRider,
            block.timestamp
        );
    }

    /**
     * @notice Driver cancels ride
     */
    function cancelRideByDriver(
        bytes32 _rideId
    ) external rideExists(_rideId) onlyDriver(_rideId) nonReentrant {
        Ride storage ride = rides[_rideId];

        require(
            ride.status == RideStatus.Accepted,
            "Can only cancel accepted rides"
        );

        // Deduct point from driver
        reputationSystem.deductPoints(msg.sender, 1);

        // Reset driver - ride becomes available again
        ride.driver = address(0);
        ride.status = RideStatus.Requested;
        ride.acceptedAt = 0;

        // No refund - other drivers can accept

        emit RideCanceled(
            _rideId,
            msg.sender,
            RideStatus.CanceledByDriver,
            block.timestamp
        );
    }

    /**
     * @notice Complete ride and release funds
     */
    function completeRide(
        bytes32 _rideId
    ) external rideExists(_rideId) nonReentrant {
        Ride storage ride = rides[_rideId];

        require(
            msg.sender == ride.rider || msg.sender == ride.driver,
            "Only rider or driver can complete"
        );
        require(ride.status == RideStatus.Accepted, "Ride must be accepted");
        require(ride.driver != address(0), "No driver assigned");

        ride.status = RideStatus.Completed;
        ride.completedAt = block.timestamp;
        completedRides++;

        // Award points to both parties through reputation system
        reputationSystem.addPoints(ride.rider, 1);
        reputationSystem.addPoints(ride.driver, 1);

        // Release escrow to driver through escrow manager
        escrowManager.releaseEscrow(_rideId, ride.driver);

        emit RideCompleted(
            _rideId,
            ride.rider,
            ride.driver,
            ride.amount,
            block.timestamp
        );
    }

    /**
     * @notice Get ride details
     */
    function getRide(
        bytes32 _rideId
    )
        external
        view
        returns (
            address rider,
            address driver,
            uint256 amount,
            RideStatus status,
            uint256 requestedAt,
            uint256 acceptedAt,
            uint256 completedAt
        )
    {
        Ride storage ride = rides[_rideId];
        require(ride.exists, "Ride does not exist");

        return (
            ride.rider,
            ride.driver,
            ride.amount,
            ride.status,
            ride.requestedAt,
            ride.acceptedAt,
            ride.completedAt
        );
    }

    /**
     * @notice Full ride metadata (struct)
     */
    function getRideInfo(
        bytes32 _rideId
    ) external view rideExists(_rideId) returns (Ride memory) {
        return rides[_rideId];
    }

    /**
     * @notice Get contract stats
     */
    function getStats()
        external
        view
        returns (uint256 _totalRides, uint256 _completedRides)
    {
        return (totalRides, completedRides);
    }
}
