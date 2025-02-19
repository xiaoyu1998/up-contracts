import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { poolStoreUtilsModule } from "./deployPoolStoreUtils"
import { positionStoreUtilsModule } from "./deployPositionStoreUtils"
import { repayUtilsModule } from "./deployRepayUtils"
import { swapUtilsModule } from "./deploySwapUtils"
import { oracleUtilsModule } from "./deployOracleUtils"
import { closeEventUtilsModule } from "./deployCloseEventUtils"

export const closeUtilsModule = buildModule("CloseUtils", (m) => {
    const { poolStoreUtils } = m.useModule(poolStoreUtilsModule)
    const { positionStoreUtils } = m.useModule(positionStoreUtilsModule)
    const { repayUtils } = m.useModule(repayUtilsModule)
    const { swapUtils } = m.useModule(swapUtilsModule);
    const { oracleUtils } = m.useModule(oracleUtilsModule)
    const { closeEventUtils } = m.useModule(closeEventUtilsModule)

    const closeUtils = m.library("CloseUtils", {
        libraries: {
            PoolStoreUtils: poolStoreUtils,
            PositionStoreUtils: positionStoreUtils,
            RepayUtils: repayUtils,
            SwapUtils: swapUtils,
            OracleUtils: oracleUtils,
            CloseEventUtils: closeEventUtils,
        },      
    });

    return { closeUtils };
});

export default closeUtilsModule;