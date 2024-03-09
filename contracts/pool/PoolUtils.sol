// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

import "./Pool.sol";
import "./PoolCache.sol";
import "./PoolConfigurationUtils.sol";

import "./chain/Chain.sol";


// @title PoolUtils
// @dev Library for Pool functions
library PoolUtils {
    using Pool for Pool.Props;
    using PoolCache for PoolCache.Props;

    struct CalculateInterestRatesParams {
        uint256 liquidityIn;
        uint256 liquidityOut;
        uint256 totalDebt;
        uint256 feeFactor;
        address underlyingAsset;
        address poolToken;
    }

    struct UpdateInterestRatesLocalVars {
        uint256 nextLiquidityRate;
        uint256 nextBorrowRate;
        uint256 totalDebt;
    }
    
    function updateInterestRates(
        Pool.Props memory pool,
        PoolCache.Props memory poolCache
        address underlyingAsset,
        uint256 liquidityIn,
        uint256 liquidityOut
    ) internal {
        UpdateInterestRatesLocalVars memory vars;

        vars.totalDebt = poolCache.nextTotalScaledDebt.rayMul(
            poolCache.nextBorrowIndex
        );

        (   vars.nextLiquidityRate,
            vars.nextBorrowRate
        ) = IPoolInterestRateStrategy(pool.interestRateStrategy).calculateInterestRates(
            CalculateInterestRatesParams({
                liquidityIn,
                liquidityOut,
                vars.totalDebt,
                poolCache.feeFactor,
                underlyingAsset,
                poolCache.poolToken
            })
        );

        pool.LiquidityRate = vars.nextLiquidityRate;
        pool.borrowRate    = vars.nextBorrowRate;

    }


    function cache(
      Pool.Props memory pool
    ) internal view returns (PoolCache.Props memory) {
        PoolCache.Props memory poolCache;

        poolCache.currLiquidityIndex = poolCache.nextLiquidityIndex = pool.liquidityIndex();
        poolCache.currLiquidityRate  = pool.liquidityRate();
        poolCache.currBorrowIndex    = poolCache.nextBorrowIndex    = pool.borrowIndex();
        poolCache.currBorrowRate     = pool.borrowRate();

        poolCache.currTotalScaledDebt = poolCache.nextTotalScaledDebt = IDebtToken(
            poolCache.debtToken()
        ).scaledTotalSupply();

        poolCache.poolToken     = pool.poolToken();
        poolCache.DebtToken     = pool.DebtToken();

        poolCache.poolConfiguration   = pool.configuration;
        poolCache.feeFactor           = PoolConfigurationUtils.getReserveFactor(poolCache.poolConfigration);
        poolCache.lastUpdateTimestamp = pool.lastUpdateTimestamp();

        return poolCache;
    }	

    function updateIndexes(
        Pool.Props memory pool,
        PoolCache.Props memory poolCache
    ) internal {
        if (poolCache.currLiquidityRate != 0) {
            uint256 cumulatedLiquidityInterest = MathUtils.calculateInterest(
                poolCache.currLiquidityRate,
                poolCache.lastUpdateTimestamp
            );
            poolCache.nextLiquidityIndex = cumulatedLiquidityInterest.rayMul(
                poolCache.currLiquidityIndex
            );
            pool.setLiquidityIndex(poolCache.nextLiquidityIndex);
        }

        if (poolCache.currTotalScaledDebt != 0) {
            uint256 cumulatedBorrowInterest = MathUtils.calculateInterest(
                poolCache.currBorrowRate,
                poolCache.lastUpdateTimestamp
            );
            poolCache.nextBorrowIndex = cumulatedBorrowInterest.rayMul(
                poolCache.currBorrowIndex
            );
            pool.setBorrowIndex(poolCache.nextBorrowIndex);
        }
    }

    function updateStateByIntervalBetweenTransactions(
      Pool.Props memory pool,
      PoolCache.Props memory poolCache
    ) internal {
        uint256 blockTimeStamp = Chain.currentTimestamp();
        if (poolCache.lastUpdateTimestamp == blockTimeStamp) {
            return;
        }
        pool.updateIndexes(poolCache);
        pool.incrementClaimableFeeAmount(poolCache);
        pool.setLastUpdateTimestamp(blockTimeStamp);
    }

    function getPoolNormalizedLiquidityIndex(
      DataStore dataStore,
      address key,
    ) internal return (uint256) {
        Pool.Props memory pool = PoolStoreUtils.get(dataStore, key)
        validateEnabledPool(pool)

        if (pool.lastUpdateTimestamp() == block.timestamp) {
            return pool.liquidityIndex();
        } else {
            uint256 periodicAnnualizedIncomeInterest = MathUtils.calculateInterest(
                pool.LiquidityRate(), 
                pool.lastUpdateTimestamp()
            )
            return periodicAnnualizedIncomeInterest.rayMul(pool.liquidityIndex());
        }
    }

    function getPoolNormalizedBorrowingIndex(
      DataStore dataStore,
      address key,
    ) internal return (uint256) {
        Pool.Props memory pool = PoolStoreUtils.get(dataStore, key)
        validateEnabledPool(pool)

        if (pool.lastUpdateTimestamp() == block.timestamp) {
            return pool.borrowIndex();
        } else {
            uint256 periodicAnnualizedBorrowInterest = MathUtils.calculateInterest(
                pool.borrowRate(), 
                pool.lastUpdateTimestamp()
            )
            return periodicAnnualizedBorrowInterest.rayMul(pool.borrowIndex());
        }
    }

    //function getPoolSalt(
    //     address poolKey
    // ) internal view returns (bytes32) {
    //     bytes32 poolSalt = keccak256(abi.encode("UF_POOL", poolKey)); 
    //     return  poolSalt;      
    // }

    function getKey(
        address underlyingAsset
    ) internal pure returns (bytes32) {
        // bytes32 key = keccak256(abi.encode(underlyingAsset));
        // return key;
        return underlyingAsset;
    }

    function validateEnabledPool(
        Pool.Props memory pool
    ) internal view {
        if (pool.poolTokenAddress() == address(0)) {
            revert Errors.EmptyPool();
        }

    }


}