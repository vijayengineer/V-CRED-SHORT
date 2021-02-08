// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import { IERC20, ILendingPool, IProtocolDataProvider, IStableDebtToken } from './Interfaces.sol';



// ERC20 Flashloan Example
contract marginContract {
    
    ILendingPool constant lendingPool = ILendingPool(address(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9)); // Mainnet
    IProtocolDataProvider constant dataProvider = IProtocolDataProvider(address(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d)); // Mainnet

    
 function depositCollateral(address asset, uint256 amount) public {
   
        IERC20(asset).approve(address(lendingPool), amount);
        lendingPool.deposit(asset, amount, address(this), 0);
    }

    /**
     * Approves the borrower to take an uncollaterised loan
     * @param borrower The borrower of the funds (i.e. delgatee)
     * @param amount The amount the borrower is allowed to borrow (i.e. their line of credit)
     * @param asset The asset they are allowed to borrow
     * 
     * Add permissions to this call, e.g. only the owner should be able to approve borrowers!
     */
    function approveBorrower(address borrower, uint256 amount, address asset) public {
        (, address stableDebtTokenAddress,) = dataProvider.getReserveTokensAddresses(asset);
        IStableDebtToken(stableDebtTokenAddress).approveDelegation(borrower, amount);
    }
    

    /**
     * Withdraw all of a collateral as the underlying asset, if no outstanding loans delegated
     * @param asset The underlying asset to withdraw
     * 
     *
     */
    function withdrawCollateral(address asset) public {
        (address aTokenAddress,,) = dataProvider.getReserveTokensAddresses(asset);
        uint256 assetBalance = IERC20(aTokenAddress).balanceOf(address(this));
        lendingPool.withdraw(asset, assetBalance, address(this));
    }

    //withdraw token from the contract
    function withdrawToken(address _tokenAddress, address Owner) public {
        uint256 balance = IERC20(_tokenAddress).balanceOf(address(this));
        IERC20(_tokenAddress).transfer(Owner, balance);
    }

}
