// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;


library Pool {
    struct Props {
        uint256 keyId;
        uint256 liquidityIndex;
        uint256 liquidityRate;
        uint256 borrowIndex;
        uint256 borrowRate;
        
        address interestRateStrategy;
        address underlyingAsset;
        address poolToken;
        address debtToken;

        uint256 configration;
        uint256 feeFactor;
        uint256 totalFee;
        uint256 unclaimedFee;
        uint256 lastUpdateTimestamp;
    }

    // function keyId(Props memory props) internal pure returns (uint256) {
    //     return props.keyId;
    // }

    // function setKeyId(Props memory props, uint256 value) internal pure {
    //     props.keyId = value;
    // }

    // function liquidityIndex(Props memory props) internal pure returns (uint256) {
    //     return props.liquidityIndex;
    // }

    // function setLiquidityIndex(Props memory props, uint256 value) internal pure {
    //     props.liquidityIndex = value;
    // }

    // function liquidityRate(Props memory props) internal pure returns (uint256) {
    //     return props.liquidityRate;
    // }

    // function setLiquidityRate(Props memory props, uint256 value) internal pure {
    //     props.liquidityRate = value;
    // }

    // function borrowIndex(Props memory props) internal pure returns (uint256) {
    //     return props.borrowIndex;
    // }

    // function setBorrowIndex(Props memory props, uint256 value) internal pure {
    //     props.borrowIndex = value;
    // }

    // function borrowRate(Props memory props) internal pure returns (uint256) {
    //     return props.borrowRate;
    // }

    // function setBorrowRate(Props memory props, uint256 value) internal pure {
    //     props.borrowRate = value;
    // }

    // function interestRateStrategy(Props memory props) internal pure returns (address) {
    //     return props.interestRateStrategy;
    // }

    // function setInterestRateStrategy(Props memory props, address value) internal pure {
    //     props.interestRateStrategy = value;
    // }

    // function underlyingAsset(Props memory props) internal pure returns (address) {
    //     return props.underlyingAsset;
    // }

    // function setUnderlyingToken(Props memory props, address value) internal pure {
    //     props.underlyingAsset = value;
    // }

    // function poolToken(Props memory props) internal pure returns (address) {
    //     return props.poolToken;
    // }

    // function setPoolToken(Props memory props, address value) internal pure {
    //     props.poolToken = value;
    // }

    // function debtToken(Props memory props) internal pure returns (address) {
    //     return props.debtToken;
    // }

    // function setDebtToken(Props memory props, address value) internal pure {
    //     props.debtToken = value;
    // }

    // function configration(Props memory props) internal pure returns (uint256) {
    //     return props.configration;
    // }

    // function setConfigration(Props memory props, uint256 value) internal pure {
    //     props.configration = value;
    // }

    // function feeFactor(Props memory props) internal pure returns (uint256) {
    //     return props.feeFactor;
    // }

    // function setFeeFactor(Props memory props, uint256 value) internal pure {
    //     props.feeFactor = value;
    // }

    // function totalFee(Props memory props) internal pure returns (uint256) {
    //     return props.totalFee;
    // }

    // function setTotalFee(Props memory props, uint256 value) internal pure {
    //     props.totalFee = value;
    // }

    // function incrementFee(Props memory props, uint256 value) internal pure {
    //     props.totalFee     += value;
    //     props.unclaimedFee += value;
    // }

    // function unclaimedFee(Props memory props) internal pure returns (uint256) {
    //     return props.unclaimedFee;
    // }

    // function setUnclaimedFee(Props memory props, uint256 value) internal pure {
    //     props.unclaimedFee = value;
    // }

    // function lastUpdateTimestamp(Props memory props) internal pure returns (uint256) {
    //     return props.lastUpdateTimestamp;
    // }

    // function setLastUpdateTimestamp(Props memory props, uint256 value) internal pure {
    //     props.lastUpdateTimestamp = value;
    // }

}
