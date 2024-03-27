import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { routerModule } from "./deployRouter"
import { roleStoreModule } from "./deployRoleStore"
import { dataStoreModule } from "./deployDataStore"
import { supplyHandlerModule } from "./deploySupplyHandler"
import { withdrawHandlerModule } from "./deployWithdrawHandler"
import { depositHandlerModule } from "./deployDepositHandler"
import { borrowHandlerModule } from "./deployBorrowHandler"
import { repayHandlerModule } from "./deployRepayHandler"
import { redeemHandlerModule } from "./deployRedeemHandler"

import { configModule } from "./deployConfig"
import { poolFactoryModule } from "./deployPoolFactory"
import { poolInterestRateStrategyModule } from "./deployPoolInterestRateStrategy"
import { readerModule } from "./deployReader"

import { hashString } from "../../utils/hash";
import * as keys from "../../utils/keys";

const exchangeRouterModule = buildModule("ExchangeRouter", (m) => {
    const { router } = m.useModule(routerModule);
    const { roleStore } = m.useModule(roleStoreModule);
    const { dataStore } = m.useModule(dataStoreModule);
    const { supplyHandler } = m.useModule(supplyHandlerModule);
    const { withdrawHandler } = m.useModule(withdrawHandlerModule);
    const { depositHandler } = m.useModule(depositHandlerModule);
    const { borrowHandler } = m.useModule(borrowHandlerModule);
    const { repayHandler } = m.useModule(repayHandlerModule);
    const { redeemHandler } = m.useModule(redeemHandlerModule);
    const { config } = m.useModule(configModule);
    const { poolFactory } = m.useModule(poolFactoryModule); 
    const { poolInterestRateStrategy } = m.useModule(poolInterestRateStrategyModule) ;  
    const { reader } = m.useModule(readerModule);

    const exchangeRouter = m.contract("ExchangeRouter", [
        router,
        roleStore, 
        dataStore,
        supplyHandler,
        withdrawHandler, 
        depositHandler,
        borrowHandler,
        repayHandler, 
        redeemHandler
    ]);

    m.call(roleStore, "grantRole",  [supplyHandler, keys.CONTROLLER], {id:"grantRole1" });
    m.call(roleStore, "grantRole",  [withdrawHandler, keys.CONTROLLER], {id:"grantRole2"});
    m.call(roleStore, "grantRole",  [borrowHandler, keys.CONTROLLER], {id:"grantRole3"}); 
    m.call(roleStore, "grantRole",  [depositHandler, keys.CONTROLLER], {id:"grantRole4"}); 
    m.call(roleStore, "grantRole",  [repayHandler, keys.CONTROLLER], {id:"grantRole5"});
    m.call(roleStore, "grantRole",  [redeemHandler, keys.CONTROLLER], {id:"grantRole6"});
    m.call(roleStore, "grantRole",  [poolFactory, keys.CONTROLLER], {id:"grantRole7"});
    m.call(roleStore, "grantRole",  [config, keys.CONTROLLER], {id:"grantRole8"});

    return { exchangeRouter };
});

export default exchangeRouterModule;