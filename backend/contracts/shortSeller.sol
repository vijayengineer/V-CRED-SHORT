pragma solidity ^0.6.12;

import {ILendingPool,IProtocolDataProvider, IStableDebtToken} from './Interfaces.sol';

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface IWETH {
    function withdraw(uint256) external;
    function deposit() external payable;
}

// SPDX-License-Identifier: MIT

contract shortSeller {
     // Allow the contract to receive Ether
    receive() external payable {}
    // OneInch Config
    address ONE_INCH_ADDRESS = 0x111111125434b319222CdBf8C261674aDB56F3ae;
    address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    ILendingPool constant lendingPool = ILendingPool(address(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9)); // Mainnet
    IProtocolDataProvider constant dataProvider = IProtocolDataProvider(address(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d)); // Mainnet
    
function oneInchWETHUSDCSwap(uint256 _amount, bytes memory _oneInchCallData) public {
    uint256 amount = _amount;
    bytes memory oneInchCallData = _oneInchCallData;
    oneInchSwap(WETH,USDC,amount,oneInchCallData);
}

function oneInchUSDCWETHSwap(uint256 _amount, bytes memory _oneInchCallData) public {
    uint256 amount = _amount;
    bytes memory oneInchCallData = _oneInchCallData;
    oneInchSwap(USDC,WETH,amount,oneInchCallData);
}

function oneInchSwap(address _from, address _to, uint256 _amount, bytes memory _oneInchCallData) internal {
        // Setup contracts
        IERC20 _fromIERC20 = IERC20(_from);
        //uint256 _beforeBalance = IERC20(_to).balanceOf(address(this));
        // Approve tokens
        _fromIERC20.approve(ONE_INCH_ADDRESS, _amount);

        // Swap tokens: give _from, get _to
        (bool success,) = ONE_INCH_ADDRESS.call{value: msg.value}(_oneInchCallData);
        require(success, '1INCH_SWAP_CALL_FAILED');

        //uint256 _afterBalance = IERC20(_to).balanceOf(address(this));
        // Reset approval
        _fromIERC20.approve(ONE_INCH_ADDRESS, 0);
    }

   function getWeth(uint256 _amount) public {
        IWETH(WETH).deposit{value: _amount}();
    }

    function borrow(address delegator, uint256 amount, address asset) public{
      lendingPool.borrow(asset, amount,1,0, delegator);
    }


    function repayBorrower(uint256 amount, address asset, address delegator) public {
        IERC20(asset).approve(address(lendingPool), amount);
        lendingPool.repay(asset, amount, 1, delegator);
    }
    

    // KEEP THIS FUNCTION IN CASE THE CONTRACT RECEIVES TOKENS!
    function withdrawToken(address _tokenAddress, address Owner) public {
        uint256 balance = IERC20(_tokenAddress).balanceOf(address(this));
        IERC20(_tokenAddress).transfer(Owner, balance);
    }

    // KEEP THIS FUNCTION IN CASE THE CONTRACT KEEPS LEFTOVER ETHER!
    function withdrawEther(address  Owner) public{
        address self = address(this);
        // workaround for a possible solidity bug
        uint256 balance = self.balance;
        payable(address(Owner)).transfer(balance);
    }
}