import hre from "hardhat";
import { getErrorMsgFromTx, getErrorMsg } from "../utils/error";

async function main() {
  // const txHash = "0xa58cc82917012689706a58b0f7e2716c5022b65df91d9c98232431717edcb53f";
  // console.log("Error:", await getErrorMsgFromTx(txHash));

  const errorBytes = '0x86c4ec210000000000000000000000000000000000000000000000008ac7230489e800000000000000000000000000000000000000000000000000000000000000000000';
  console.log("Error:", await getErrorMsg(errorBytes));
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((ex) => {
    console.error(ex);
    process.exit(1);
  });