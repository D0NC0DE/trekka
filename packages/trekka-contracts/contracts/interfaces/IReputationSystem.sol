// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IReputationSystem
 * @notice Interface for reputation/points management
 */
interface IReputationSystem {
    function addPoints(address user, uint256 points) external;

    function deductPoints(address user, uint256 points) external;

    function getPoints(address user) external view returns (uint256);
}
