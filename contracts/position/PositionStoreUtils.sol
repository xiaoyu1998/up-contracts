// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

import "../data/Keys.sol";
import "../data/DataStore.sol";

import "./Position.sol";

/**
 * @title PositionStoreUtils
 * @dev Library for position storage functions
 */
library PositionStoreUtils {
    using Position for Position.Props;

    bytes32 public constant UNDERLYING_ASSET = keccak256(abi.encode("UNDERLYING_ASSET"));
    bytes32 public constant ACCOUNT = keccak256(abi.encode("ACCOUNT"));
    bytes32 public constant ENTRY_LONG_PRICE = keccak256(abi.encode("ENTRY_LONG_PRICE"));
    bytes32 public constant ACC_LONG_AMOUNT = keccak256(abi.encode("ACC_LONG_AMOUNT"));
    bytes32 public constant ENTRY_SHORT_PRICE = keccak256(abi.encode("ENTRY_SHORT_PRICE"));
    bytes32 public constant ACC_SHORT_AMOUNT = keccak256(abi.encode("ACC_SHORT_AMOUNT"));
    bytes32 public constant IS_LONG = keccak256(abi.encode("IS_LONG"));
    bytes32 public constant HAS_COLLATERAL = keccak256(abi.encode("HAS_COLLATERAL"));
    bytes32 public constant HAS_DEBT = keccak256(abi.encode("HAS_DEBT"));
    // bytes32 public constant COLLATERAL_AND_DEBT_POOLS = keccak256(abi.encode("COLLATERAL_AND_DEBT_POOLS"));

    function get(DataStore dataStore, bytes32 key) external view returns (Position.Props memory) {
        Position.Props memory position;
        if (!dataStore.containsBytes32(Keys.POSITION_LIST, key)) {
            return position;
        }

        position.account = dataStore.getAddress(
            keccak256(abi.encode(key, ACCOUNT))
        );

        position.underlyingAsset = dataStore.getAddress(
            keccak256(abi.encode(key, UNDERLYING_ASSET))
        );

        position.entryLongPrice = dataStore.getUint(
            keccak256(abi.encode(key, ENTRY_LONG_PRICE))
        );

        position.accLongAmount = dataStore.getUint(
            keccak256(abi.encode(key, ACC_LONG_AMOUNT))
        );

        position.entryShortPrice = dataStore.getUint(
            keccak256(abi.encode(key, ENTRY_SHORT_PRICE))
        );

        position.accShortAmount = dataStore.getUint(
            keccak256(abi.encode(key, ACC_SHORT_AMOUNT))
        );

        position.isLong = dataStore.getBool(
            keccak256(abi.encode(key, IS_LONG))
        );

        position.hasCollateral = dataStore.getBool(
            keccak256(abi.encode(key, HAS_COLLATERAL))
        );

        position.hasDebt = dataStore.getBool(
            keccak256(abi.encode(key, HAS_DEBT))
        );

        // position.collateralAndDebtPools = dataStore.getUint(
        //     keccak256(abi.encode(key, COLLATERAL_AND_DEBT_POOLS))
        // );

        return position;
    }

    function set(DataStore dataStore, bytes32 key, Position.Props memory position) external {
        dataStore.addBytes32(
            Keys.POSITION_LIST,
            key
        );

        dataStore.addBytes32(
            Keys.accountPositionListKey(position.account),
            key
        );

        dataStore.setAddress(
            keccak256(abi.encode(key, ACCOUNT)),
            position.account
        );

        dataStore.setAddress(
            keccak256(abi.encode(key, UNDERLYING_ASSET)),
            position.underlyingAsset
        );

        dataStore.setUint(
            keccak256(abi.encode(key, ENTRY_LONG_PRICE)),
            position.entryLongPrice
        );

        dataStore.setUint(
            keccak256(abi.encode(key, ACC_LONG_AMOUNT)),
            position.accLongAmount
        );

        dataStore.setUint(
            keccak256(abi.encode(key, ENTRY_SHORT_PRICE)),
            position.entryShortPrice
        );

        dataStore.setUint(
            keccak256(abi.encode(key, ACC_SHORT_AMOUNT)),
            position.accShortAmount
        );

        dataStore.setBool(
            keccak256(abi.encode(key, IS_LONG)),
            position.isLong
        );

        dataStore.setBool(
            keccak256(abi.encode(key, HAS_COLLATERAL)),
            position.hasCollateral
        );

        dataStore.setBool(
            keccak256(abi.encode(key, HAS_DEBT)),
            position.hasDebt
        );

        // dataStore.setUint(
        //     keccak256(abi.encode(key, COLLATERAL_AND_DEBT_POOLS)),
        //     position.collateralAndDebtPools
        // );

    }

    function remove(DataStore dataStore, bytes32 key, address account) external {
        if (!dataStore.containsBytes32(Keys.POSITION_LIST, key)) {
            revert Errors.PositionNotFound(key);
        }

        dataStore.removeBytes32(
            Keys.POSITION_LIST,
            key
        );

        dataStore.removeBytes32(
            Keys.accountPositionListKey(account),
            key
        );

        dataStore.removeAddress(
            keccak256(abi.encode(key, ACCOUNT))
        );
        
        dataStore.removeAddress(
            keccak256(abi.encode(key, UNDERLYING_ASSET))
        );

        dataStore.removeUint(
            keccak256(abi.encode(key, ENTRY_LONG_PRICE))
        );

        dataStore.removeUint(
            keccak256(abi.encode(key, ACC_LONG_AMOUNT))
        );

        dataStore.removeUint(
            keccak256(abi.encode(key, ENTRY_SHORT_PRICE))
        );

        dataStore.removeUint(
            keccak256(abi.encode(key, ACC_SHORT_AMOUNT))
        );

        dataStore.removeBool(
            keccak256(abi.encode(key, IS_LONG))
        );

        dataStore.removeBool(
            keccak256(abi.encode(key, HAS_COLLATERAL))
        );

        dataStore.removeBool(
            keccak256(abi.encode(key, HAS_DEBT))
        );


        // dataStore.removeUint(
        //     keccak256(abi.encode(key, COLLATERAL_AND_DEBT_POOLS))
        // );

    }

    function getPositionCount(DataStore dataStore) internal view returns (uint256) {
        return dataStore.getAddressCount(Keys.POSITION_LIST);
    }

    function getPositionKeys(DataStore dataStore, uint256 start, uint256 end) internal view returns (address[] memory) {
        return dataStore.getAddressValuesAt(Keys.POSITION_LIST, start, end);
    }

    function getAccountPositionCount(DataStore dataStore, address account) internal view returns (uint256) {
        return dataStore.getBytes32Count(Keys.accountPositionListKey(account));
    }

    function getAccountPositionKeys(DataStore dataStore, address account, uint256 start, uint256 end) internal view returns (bytes32[] memory) {
        return dataStore.getBytes32ValuesAt(Keys.accountPositionListKey(account), start, end);
    }
}