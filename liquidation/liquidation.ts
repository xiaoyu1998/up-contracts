import { contractAt, sendTxn, getTokens, getContract, getEventEmitter } from "../utils/deploy";
import { expandDecimals } from "../utils/math";
import { getPool } from "../utils/helper";

async function main() {
    const accounts = await ethers.getSigners();
    const owner = accounts[0];
    const users = accounts.slice(1);

    //init contracts
    const exchangeRouter = await getContract("ExchangeRouter"); 
    const router = await getContract("Router");
    const dataStore = await getContract("DataStore");   
    const reader = await getContract("Reader");  
    const eventEmitter = await getEventEmitter();  
    eventEmitter.on("Borrow", (pool, borrower, amount, borrowRate, collateral, debtScaled) =>{
        const event: BorrowEvent.OutputTuple = {
            pool: pool,
            borrower: borrower,
            account: account,
            amount: amount,
            borrowRate: borrowRate,
            collateral: collateral,
            debtScaled: debtScaled
        };        
        console.log("eventEmitter Borrow" ,event);
    });
  
    //accounts init for liquidation
    for (const user of users) {
        await sendTxn(
            usdt.connect(user).approve(router.target, amountUsdt), `usdt.approve(${router.target} ${amountUsdt})`
        );
        //deposit usdt
        const paramsUsdt: DepositUtils.DepositParamsStruct = {
            underlyingAsset: usdtAddress,
        };
        //borrow uni
        const borrowAmmountUni = expandDecimals(1000, uniDecimals);
        const paramsUni: BorrowUtils.BorrowParamsStruct = {
            underlyingAsset: uniAddress,
            amount: borrowAmmountUni,
        };
        
        const poolUsdt = await getPool(usdtAddress); 
        const multicallArgs = [
            exchangeRouter.interface.encodeFunctionData("sendTokens", [usdtAddress, poolUsdt.poolToken, amountUsdt]),
            exchangeRouter.interface.encodeFunctionData("executeDeposit", [paramsUsdt]),
            exchangeRouter.interface.encodeFunctionData("executeBorrow", [paramsUni]),
        ];
        await sendTxn(
            exchangeRouter.connect(user).multicall(multicallArgs),
            "exchangeRouter.multicall"
        );
    };

    const config = await getContract("Config");
    await sendTxn(
        config.setHealthFactorLiquidationThreshold(expandDecimals(400, 25)),//400%
        "config.setHealthFactorLiquidationThreshold"
    );

}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })