// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "../interfaces/IEscrowManager.sol";
import "../interfaces/IReputationSystem.sol";

/**
 * @title Marketplace
 * @notice Decentralized marketplace for Trekka P2P Platform
 * @dev Products stored with IPFS CIDs, orders with escrow
 */
contract Marketplace is ReentrancyGuard {
    enum OrderStatus {
        Placed,
        Accepted,
        Delivered,
        Completed,
        CanceledByBuyer,
        CanceledBySeller
    }

    struct Product {
        string cid; // IPFS CID
        address seller;
        uint256 pricePerUnit;
        uint256 availableQuantity;
        uint256 listedAt;
        bool exists;
    }

    struct Order {
        bytes32 id;
        string productCid;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalAmount;
        OrderStatus status;
        uint256 placedAt;
        uint256 acceptedAt;
        uint256 deliveredAt;
        uint256 completedAt;
        bytes32 completionPinHash;
        bool exists;
    }

    // Core contract references
    IEscrowManager public escrowManager;
    IReputationSystem public reputationSystem;

    mapping(string => Product) public products;
    mapping(bytes32 => Order) public orders;

    string[] public productCids;

    address public owner;
    uint256 public totalProducts;
    uint256 public totalOrders;
    uint256 public completedOrders;

    event ProductListed(
        string indexed cid,
        address indexed seller,
        uint256 pricePerUnit,
        uint256 quantity,
        uint256 timestamp
    );
    event ProductUpdated(
        string indexed cid,
        uint256 pricePerUnit,
        uint256 quantity,
        uint256 timestamp
    );
    event OrderPlaced(
        bytes32 indexed orderId,
        string indexed productCid,
        address indexed buyer,
        address seller,
        uint256 quantity,
        uint256 totalAmount,
        uint256 timestamp
    );
    event OrderAccepted(
        bytes32 indexed orderId,
        address indexed seller,
        uint256 timestamp
    );
    event OrderDelivered(
        bytes32 indexed orderId,
        bytes32 completionPinHash,
        uint256 timestamp
    );
    event OrderCompleted(
        bytes32 indexed orderId,
        address indexed buyer,
        address indexed seller,
        uint256 totalAmount,
        uint256 timestamp
    );
    event OrderCanceled(
        bytes32 indexed orderId,
        address indexed canceledBy,
        OrderStatus status,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier orderExists(bytes32 _orderId) {
        require(orders[_orderId].exists, "Order does not exist");
        _;
    }

    modifier onlyBuyer(bytes32 _orderId) {
        require(msg.sender == orders[_orderId].buyer, "Only buyer");
        _;
    }

    modifier onlySeller(bytes32 _orderId) {
        require(msg.sender == orders[_orderId].seller, "Only seller");
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
     * @notice List a new product or update existing
     */
    function listProduct(
        string memory _cid,
        uint256 _pricePerUnit,
        uint256 _quantity
    ) external {
        require(bytes(_cid).length > 0, "CID cannot be empty");
        require(_pricePerUnit > 0, "Price must be greater than 0");
        require(_quantity > 0, "Quantity must be greater than 0");

        if (!products[_cid].exists) {
            // New product
            products[_cid] = Product({
                cid: _cid,
                seller: msg.sender,
                pricePerUnit: _pricePerUnit,
                availableQuantity: _quantity,
                listedAt: block.timestamp,
                exists: true
            });

            productCids.push(_cid);
            totalProducts++;

            emit ProductListed(
                _cid,
                msg.sender,
                _pricePerUnit,
                _quantity,
                block.timestamp
            );
        } else {
            // Update existing product (only seller can update)
            require(
                products[_cid].seller == msg.sender,
                "Only seller can update"
            );

            products[_cid].pricePerUnit = _pricePerUnit;
            products[_cid].availableQuantity = _quantity;

            emit ProductUpdated(
                _cid,
                _pricePerUnit,
                _quantity,
                block.timestamp
            );
        }
    }

    /**
     * @notice Place an order for a product
     */
    function placeOrder(
        bytes32 _orderId,
        string memory _productCid,
        uint256 _quantity
    ) external payable nonReentrant {
        require(!orders[_orderId].exists, "Order ID already exists");
        require(products[_productCid].exists, "Product does not exist");
        require(_quantity > 0, "Quantity must be greater than 0");

        Product storage product = products[_productCid];

        require(
            product.availableQuantity >= _quantity,
            "Insufficient quantity available"
        );
        require(msg.sender != product.seller, "Cannot buy own product");

        uint256 totalAmount = product.pricePerUnit * _quantity;
        require(msg.value == totalAmount, "Incorrect payment amount");

        // Create escrow
        escrowManager.createEscrow{value: msg.value}(
            _orderId,
            msg.sender,
            msg.value
        );

        orders[_orderId] = Order({
            id: _orderId,
            productCid: _productCid,
            buyer: msg.sender,
            seller: product.seller,
            quantity: _quantity,
            totalAmount: totalAmount,
            status: OrderStatus.Placed,
            placedAt: block.timestamp,
            acceptedAt: 0,
            deliveredAt: 0,
            completedAt: 0,
            completionPinHash: bytes32(0),
            exists: true
        });

        // Reduce available quantity
        product.availableQuantity -= _quantity;

        totalOrders++;

        emit OrderPlaced(
            _orderId,
            _productCid,
            msg.sender,
            product.seller,
            _quantity,
            totalAmount,
            block.timestamp
        );
    }

    /**
     * @notice Seller accepts an order
     */
    function acceptOrder(
        bytes32 _orderId
    ) external orderExists(_orderId) onlySeller(_orderId) nonReentrant {
        Order storage order = orders[_orderId];

        require(order.status == OrderStatus.Placed, "Order not available");

        order.status = OrderStatus.Accepted;
        order.acceptedAt = block.timestamp;

        emit OrderAccepted(_orderId, msg.sender, block.timestamp);
    }

    /**
     * @notice Seller marks order as delivered with pin hash
     */
    function markDelivered(
        bytes32 _orderId,
        bytes32 _completionPinHash
    ) external orderExists(_orderId) onlySeller(_orderId) nonReentrant {
        Order storage order = orders[_orderId];

        require(order.status == OrderStatus.Accepted, "Order must be accepted");
        require(_completionPinHash != bytes32(0), "Invalid pin hash");

        order.status = OrderStatus.Delivered;
        order.deliveredAt = block.timestamp;
        order.completionPinHash = _completionPinHash;

        emit OrderDelivered(_orderId, _completionPinHash, block.timestamp);
    }

    /**
     * @notice Complete order with pin verification (backend verifies pin off-chain)
     */
    function completeOrder(
        bytes32 _orderId
    ) external orderExists(_orderId) nonReentrant {
        Order storage order = orders[_orderId];

        require(
            msg.sender == order.buyer || msg.sender == order.seller,
            "Only buyer or seller can complete"
        );
        require(
            order.status == OrderStatus.Delivered,
            "Order must be delivered"
        );

        order.status = OrderStatus.Completed;
        order.completedAt = block.timestamp;
        completedOrders++;

        // Award points to both parties
        reputationSystem.addPoints(order.buyer, 1);
        reputationSystem.addPoints(order.seller, 1);

        // Release escrow to seller
        escrowManager.releaseEscrow(_orderId, order.seller);

        emit OrderCompleted(
            _orderId,
            order.buyer,
            order.seller,
            order.totalAmount,
            block.timestamp
        );
    }

    /**
     * @notice Buyer cancels order
     */
    function cancelOrderByBuyer(
        bytes32 _orderId
    ) external orderExists(_orderId) onlyBuyer(_orderId) nonReentrant {
        Order storage order = orders[_orderId];

        require(
            order.status == OrderStatus.Placed ||
                order.status == OrderStatus.Accepted,
            "Cannot cancel at this stage"
        );

        // Deduct point if order was accepted
        if (order.status == OrderStatus.Accepted) {
            reputationSystem.deductPoints(msg.sender, 1);
        }

        order.status = OrderStatus.CanceledByBuyer;

        // Restore product quantity
        products[order.productCid].availableQuantity += order.quantity;

        // Refund through escrow
        escrowManager.refundEscrow(_orderId);

        emit OrderCanceled(
            _orderId,
            msg.sender,
            OrderStatus.CanceledByBuyer,
            block.timestamp
        );
    }

    /**
     * @notice Seller cancels order
     */
    function cancelOrderBySeller(
        bytes32 _orderId
    ) external orderExists(_orderId) onlySeller(_orderId) nonReentrant {
        Order storage order = orders[_orderId];

        require(
            order.status == OrderStatus.Placed ||
                order.status == OrderStatus.Accepted,
            "Cannot cancel at this stage"
        );

        // Deduct point from seller
        reputationSystem.deductPoints(msg.sender, 1);

        order.status = OrderStatus.CanceledBySeller;

        // Restore product quantity
        products[order.productCid].availableQuantity += order.quantity;

        // Refund buyer
        escrowManager.refundEscrow(_orderId);

        emit OrderCanceled(
            _orderId,
            msg.sender,
            OrderStatus.CanceledBySeller,
            block.timestamp
        );
    }

    /**
     * @notice Get all product CIDs
     */
    function getAllProductCids() external view returns (string[] memory) {
        return productCids;
    }

    /**
     * @notice Get product details
     */
    function getProduct(
        string memory _cid
    )
        external
        view
        returns (
            address seller,
            uint256 pricePerUnit,
            uint256 availableQuantity,
            uint256 listedAt
        )
    {
        require(products[_cid].exists, "Product does not exist");
        Product storage product = products[_cid];

        return (
            product.seller,
            product.pricePerUnit,
            product.availableQuantity,
            product.listedAt
        );
    }

    /**
     * @notice Get order details
     */
    function getOrder(
        bytes32 _orderId
    )
        external
        view
        returns (
            string memory productCid,
            address buyer,
            address seller,
            uint256 quantity,
            uint256 totalAmount,
            OrderStatus status,
            uint256 placedAt,
            uint256 acceptedAt,
            uint256 deliveredAt,
            uint256 completedAt
        )
    {
        require(orders[_orderId].exists, "Order does not exist");
        Order storage order = orders[_orderId];

        return (
            order.productCid,
            order.buyer,
            order.seller,
            order.quantity,
            order.totalAmount,
            order.status,
            order.placedAt,
            order.acceptedAt,
            order.deliveredAt,
            order.completedAt
        );
    }

    /**
     * @notice Get contract stats
     */
    function getStats()
        external
        view
        returns (
            uint256 _totalProducts,
            uint256 _totalOrders,
            uint256 _completedOrders
        )
    {
        return (totalProducts, totalOrders, completedOrders);
    }
}
