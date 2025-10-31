// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IEscrowManager
 * @notice Interface for core escrow functionality
 */
interface IEscrowManager {
    function createEscrow(
        bytes32 escrowId,
        address payer,
        uint256 amount
    ) external payable;

    function releaseEscrow(bytes32 escrowId, address recipient) external;

    function refundEscrow(bytes32 escrowId) external;

    function getEscrowAmount(bytes32 escrowId) external view returns (uint256);

    function escrowExists(bytes32 escrowId) external view returns (bool);
}
