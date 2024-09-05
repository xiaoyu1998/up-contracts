import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { roleStoreModule } from "./deployRoleStore"
import { dataStoreModule } from "./deployDataStore"
import { poolStoreUtilsModule } from "./deployPoolStoreUtils"
import { poolInterestRateStrategyModule } from "./deployPoolInterestRateStrategy"
import { eventEmitterModule } from "./deployEventEmitter"
import { poolEventUtilsModule } from "./deployPoolEventUtils"
import { dexStoreUtilsModule } from "./deployDexStoreUtils"
import { oracleStoreUtilsModule } from "./deployOracleStoreUtils"
// import * as keys from "../../utils/keys";

export const poolFactoryModule = buildModule("PoolFactory", (m) => {
    const { roleStore } = m.useModule(roleStoreModule)
    const { dataStore } = m.useModule(dataStoreModule)
    const { poolStoreUtils } = m.useModule(poolStoreUtilsModule)
    const { poolInterestRateStrategy } = m.useModule(poolInterestRateStrategyModule)
    const { eventEmitter } = m.useModule(eventEmitterModule)
    const { poolEventUtils } = m.useModule(poolEventUtilsModule)
    const { dexStoreUtils } = m.useModule(dexStoreUtilsModule)
    const { oracleStoreUtils } = m.useModule(oracleStoreUtilsModule)

    const poolFactory = m.contract("PoolFactory", [roleStore, dataStore], {
        libraries: {
            PoolStoreUtils: poolStoreUtils,
            DexStoreUtils: dexStoreUtils,
            OracleStoreUtils: oracleStoreUtils,
        },
    });
    //m.call(roleStore, "grantRole",  [poolFactory, keys.CONTROLLER]);
    return { 
        roleStore, 
        dataStore, 
        poolStoreUtils, 
        poolFactory, 
        poolInterestRateStrategy,
        eventEmitter,
        poolEventUtils
   };
});

export default poolFactoryModule;