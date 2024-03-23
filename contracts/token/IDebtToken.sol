// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.20;

interface IDebtToken {

    function mint(
        address to,
        uint256 amount,
        uint256 index
    ) external returns (bool);

   function scaledTotalSupply() external view returns (uint256);
   function balanceOf(address account) external view  returns (uint256);

    
}
