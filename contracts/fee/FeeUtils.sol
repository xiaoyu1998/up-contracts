// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

import "../pool/Pool.sol";
import "../pool/PoolCache.sol";

import "../utils/WadRayMath.sol";
import "../utils/PercentageMath.sol";

import "../utils/Printer.sol";

// @title FeeUtils
// @dev Library for fee actions
library FeeUtils {
    using WadRayMath for uint256;
    using PercentageMath for uint256;
    using Pool for Pool.Props;

    function incrementFeeAmount(
        Pool.Props memory pool,
        PoolCache.Props memory poolCache
    ) internal pure {
        if (poolCache.feeFactor == 0) {
          return;
        }

        uint256 prevTotalDebt      = poolCache.currTotalScaledDebt.rayMul(poolCache.currBorrowIndex);
        uint256 currTotalDebt      = poolCache.currTotalScaledDebt.rayMul(poolCache.nextBorrowIndex);
        uint256 increaseTotalDebt  = currTotalDebt - prevTotalDebt;
        uint256 feeAmount          = increaseTotalDebt.percentMul(poolCache.feeFactor);
        pool.incrementFee(feeAmount.rayDiv(poolCache.nextLiquidityIndex));

    }

}
