import { contractAt, sendTxn, getTokens, getContract, getContractAt, getEventEmitter } from "../utils/deploy";
import { expandDecimals, bigNumberify } from "../utils/math";
import { getPoolInfo, getAssets,  getPositions} from "../utils/helper";
import { RepaytUtils } from "../typechain-types/contracts/exchange/RepaytHandler";

async function main() {
    const [owner] = await ethers.getSigners();
    
    const exchangeRouter = await getContract("ExchangeRouter"); 
    const router = await getContract("Router");
    const dataStore = await getContract("DataStore");   
    const reader = await getContract("Reader");  

    const usdtDecimals = getTokens("USDT")["decimals"];
    const uniDecimals = getTokens("UNI")["decimals"];
    const usdtAddress = getTokens("USDT")["address"];
    const uniAddress = getTokens("UNI")["address"];
    const usdt = await contractAt("MintableToken", usdtAddress);
    const uni = await contractAt("MintableToken", uniAddress);

    //deposit uni 200,000 
    const depositAmmountUni = expandDecimals(200000, uniDecimals);
    await sendTxn(
        uni.approve(router.target, depositAmmountUni),
        "uni.approve"
    );
    const poolUni = await getPoolInfo(uniAddress); 
    const paramsUni: DepositUtils.DepositParamsStruct = {
        underlyingAsset: uniAddress,
    };

    //long uni 1,000,000usdt
    const borrowAmmount = expandDecimals(1000000, usdtDecimals);
    const paramsBorrow: BorrowUtils.BorrowParamsStruct = {
        underlyingAsset: usdtAddress,
        amount: borrowAmmount,
    };
    const paramsSwap: SwapUtils.SwapParamsStruct = {
        underlyingAssetIn: usdtAddress,
        underlyingAssetOut: uniAddress,
        amount: borrowAmmount,
        sqrtPriceLimitX96: 0
    };

    const multicallArgs = [
        exchangeRouter.interface.encodeFunctionData("sendTokens", [uniAddress, poolUni.poolToken, depositAmmountUni]),
        exchangeRouter.interface.encodeFunctionData("executeDeposit", [paramsUni]),
        exchangeRouter.interface.encodeFunctionData("executeBorrow", [paramsBorrow]),
        exchangeRouter.interface.encodeFunctionData("executeSwap", [paramsSwap]),
    ];
    await sendTxn(
        exchangeRouter.multicall(multicallArgs),
        "exchangeRouter.multicall"
    );

    const assetsBeforeRepay = await getAssets(dataStore, reader, owner.address);
    const repayHalfDebtAmount = borrowAmmount/bigNumberify(2);

    //repay debt by all usdt collateral
    const paramsSwap2: SwapUtils.SwapParamsStruct = {
        underlyingAssetIn: uniAddress,
        underlyingAssetOut: usdtAddress,
        amount: expandDecimals(10000, uniDecimals),
        sqrtPriceLimitX96: 0
    };
    const paramsRepay: RepaytUtils.RepayParamsStruct = {
        underlyingAsset: usdtAddress,
        amount: repayHalfDebtAmount,//repay amount must larger than collateral
        substitute: ethers.ZeroAddress,//set ZeroAddress, replay by all usdt collateral
    };
    const multicallArgs2 = [
        exchangeRouter.interface.encodeFunctionData("executeSwap", [paramsSwap2]),
        exchangeRouter.interface.encodeFunctionData("executeRepaySubstitute", [paramsRepay]),
    ];

    await sendTxn(
        exchangeRouter.multicall(multicallArgs2),
        "exchangeRouter.multicall"
    );

    const assetsAfterRepay1 = await getAssets(dataStore, reader, owner.address);
    
    //repay all debt by uni, this action will fail, if there isn't engough uni
    const params: RepaytUtils.RepayParamsStruct = {
        underlyingAsset: usdtAddress,
        amount: repayHalfDebtAmount,
        substitute: uniAddress
    };
    const multicallArgs3 = [
        //add swaps for sell the entire amount of a type of collateral in user's selected order
        exchangeRouter.interface.encodeFunctionData("executeRepaySubstitute", [params]),
    ];
    await sendTxn(
        exchangeRouter.multicall(multicallArgs3),
        "exchangeRouter.multicall"
    );

    //print 
    console.log("assetsBeforeRepay", assetsBeforeRepay);
    console.log("assetsAfterRepay1", assetsAfterRepay1);
    console.log("assetsAfterRepay2", await getAssets(dataStore, reader, owner.address));
    console.log("positions", await getPositions(dataStore, reader, owner.address)); 

}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })