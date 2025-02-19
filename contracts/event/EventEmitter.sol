// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

import "../role/RoleModule.sol";

// @title EventEmitter
// @dev Contract to emit events
// This allows main events to be emitted from a single contract
contract EventEmitter is RoleModule {

    event Supply(
        address indexed pool,
        address indexed supplier,
        address indexed to,
        uint256 amount
    );

    event Withdraw(
        address indexed pool, 
        address indexed withdrawer, 
        address indexed to, 
        uint256 amount
    );

    event Deposit(
        address indexed pool,
        address indexed depositer,
        uint256 amount,
        uint256 collateral,
        uint256 debtScaled
    );

    event Redeem(
        address indexed pool,
        address indexed redeemer,
        address indexed to,
        uint256 amount,
        uint256 collateral,
        uint256 debtScaled
    );

    event Borrow(
        address indexed pool,
        address indexed borrower,
        uint256 amount,
        uint256 borrowRate,
        uint256 collateral,
        uint256 debtScaled
    );

    event Repay(
        address indexed pool,
        address indexed repayer,
        uint256 amount,
        bool useCollateral,
        uint256 collateral,
        uint256 debtScaled
    );

    event Swap(
        address indexed poolIn,
        address indexed poolOut,
        address indexed account,
        uint256 amountIn,
        uint256 amountOut,
        uint256 fee,
        uint256 collateralIn,
        uint256 debtScaledIn,
        uint256 collateralOut,
        uint256 debtScaledOut
    );

    // event PositionLiquidation(
    //     address indexed liquidator,
    //     address indexed pool,
    //     address indexed account,
    //     uint256 collateral,
    //     uint256 debt,
    //     uint256 price
    // );

    event LiquidationPosition(
        address indexed liquidator,
        address indexed pool,
        address indexed account,
        uint256 collateralUsd,
        uint256 debtUsd
    );

    event Liquidation(
        address indexed liquidator,
        address indexed account,
        uint256 healthFactor,
        uint256 healthFactorLiquidationThreshold,
        uint256 totalCollateralUsd,
        uint256 totalDebtUsd
    );

    event ClosePosition(
        address indexed pool,
        address indexed poolUsd,
        address indexed account,
        // uint256 collateral,
        uint256 collateralSold, 
        // uint256 debt,
        uint256 debtClosed,   
        uint256 remainCollateral,   
        uint256 remainUsd,//the remain Usd or the remain collateral sold out to usd 
        uint256 collateralUsd,
        uint256 debtScaledUsd
    );

    event Close(
        address indexed poolUsd,
        address indexed account,
        uint256 amountUsdStartClose,
        uint256 amountUsdAfterRepayAndSellCollateral,
        uint256 amountUsdAfterBuyCollateralAndRepay
    );

    event PoolUpdated(
        address indexed pool,
        uint256 liquidityRate,
        uint256 borrowRate,
        uint256 liquidityIndex,
        uint256 borrowIndex
    );

    event ClaimFees(
        address indexed pool,
        uint256 scaledUnclaimedFee,
        uint256 liquidityIndex,
        uint256 unclaimedFee
    );

    constructor(RoleStore _roleStore) RoleModule(_roleStore) {}

    // @dev emit a Supply event
    // @param underlyingAsset the underlyingAsset of the pool
    // @param account the account of the event
    // @param to the to of the event
    // @param supplyAmount the supplyAmount of the event
    function emitSupply(
        address underlyingAsset,
        address account,
        address to,
        uint256 supplyAmount
    ) external onlyController {
        emit Supply(
            underlyingAsset,
            account,
            to,
            supplyAmount
        );
    }

    function emitWithdraw(
        address underlyingAsset,
        address account,
        address to,
        uint256 withdrawAmount
    ) external onlyController {
        emit Withdraw(
            underlyingAsset,
            account,
            to,
            withdrawAmount
        );
    }

    function emitDeposit(
        address underlyingAsset,
        address account,
        uint256 depositAmount,
        uint256 collateral,
        uint256 debtScaled
    ) external onlyController {
        emit Deposit(
            underlyingAsset,
            account,
            depositAmount,
            collateral,
            debtScaled
        );
    }

    function emitRedeem(
        address underlyingAsset,
        address account,
        address to,
        uint256 redeemAmount,
        uint256 collateral,
        uint256 debtScaled
    ) external onlyController {
        emit Redeem(
            underlyingAsset,
            account,
            to,
            redeemAmount,
            collateral,
            debtScaled
        );
    }

    function emitBorrow(
        address underlyingAsset,
        address account,
        uint256 borrowAmount,
        uint256 borrowRate,
        uint256 collateral,
        uint256 debtScaled
    ) external onlyController {
        emit Borrow(
            underlyingAsset,
            account,
            borrowAmount,
            borrowRate,
            collateral,
            debtScaled
        );
    }

    function emitRepay(
        address underlyingAsset,
        address repayer,
        uint256 repayAmount,
        bool useCollateral,
        uint256 collateral,
        uint256 debtScaled
    ) external onlyController {
        emit Repay(
            underlyingAsset,
            repayer,
            repayAmount,
            useCollateral,
            collateral,
            debtScaled
        );
    }

    function emitSwap(
        address underlyingAssetIn,
        address underlyingAssetOut,
        address account,
        uint256 amountIn,
        uint256 amountOut,
        uint256 fee,
        uint256 collateralIn,
        uint256 debtScaledIn,
        uint256 collateralOut,
        uint256 debtScaledOut
    ) external onlyController {
        emit Swap(
            underlyingAssetIn,
            underlyingAssetOut,
            account,
            amountIn,
            amountOut,
            fee,
            collateralIn,
            debtScaledIn,
            collateralOut,
            debtScaledOut
        );
    }

    // function emitPositionLiquidation(
    //     address liquidator,
    //     address underlyingAsset,
    //     address account,
    //     uint256 collateral,
    //     uint256 debt,
    //     uint256 price
    // ) external onlyController {
    //     emit PositionLiquidation(
    //         liquidator,
    //         underlyingAsset,
    //         account,
    //         collateral,
    //         debt,
    //         price
    //     );
    // }

    function emitLiquidationPosition(
        address liquidator,
        address underlyingAsset,
        address account,
        uint256 collateralUsd,
        uint256 debtUsd
    ) external onlyController {
        emit LiquidationPosition(
            liquidator,
            underlyingAsset,
            account,
            collateralUsd,
            debtUsd
        );
    }

    function emitLiquidation(
        address liquidator,
        address account,
        uint256 healthFactor,
        uint256 healthFactorLiquidationThreshold,
        uint256 totalCollateralUsd,
        uint256 totalDebtUsd
    ) external onlyController {
        emit Liquidation(
            liquidator,
            account,
            healthFactor,
            healthFactorLiquidationThreshold,
            totalCollateralUsd,
            totalDebtUsd
        );
    }

    function emitClosePosition(
        address underlyingAsset,
        address underlyingAssetUsd,
        address account,
        // uint256 collateralAmount,
        uint256 collateralAmountToSell,
        // uint256 debtAmount,
        uint256 debtAmountClosed,
        uint256 remainAmount,
        uint256 remainAmountUsd,
        uint256 collateralUsd,
        uint256 debtScaledUsd
    ) external onlyController {
        emit ClosePosition(
            underlyingAsset,
            underlyingAssetUsd,
            account,
            // collateralAmount,
            collateralAmountToSell,
            // debtAmount,
            debtAmountClosed,
            remainAmount,
            remainAmountUsd,
            collateralUsd,
            debtScaledUsd
        );
    }

    function emitClose(
        address underlyingAssetUsd,
        address account,
        uint256 amountUsdStartClose,
        uint256 amountUsdAfterRepayAndSellCollateral,
        uint256 amountUsdAfterBuyCollateralAndRepay
    ) external onlyController {
        emit Close(
            underlyingAssetUsd,
            account,
            amountUsdStartClose,
            amountUsdAfterRepayAndSellCollateral,
            amountUsdAfterBuyCollateralAndRepay
        );
    }

    function emitPoolUpdated(
        address underlyingAsset,
        uint256 liquidityRate,
        uint256 borrowRate,
        uint256 liquidityIndex,
        uint256 borrowIndex
    ) external onlyController {
        emit PoolUpdated(
            underlyingAsset,
            liquidityRate,
            borrowRate,
            liquidityIndex,
            borrowIndex
        );
    }

    function emitClaimFees(
        address underlyingAsset,
        uint256 scaledUnclaimedFee,
        uint256 liquidityIndex,
        uint256 unclaimedFee
    ) external onlyController {
        emit ClaimFees(
            underlyingAsset,
            scaledUnclaimedFee,
            liquidityIndex,
            unclaimedFee
        );
    }
}