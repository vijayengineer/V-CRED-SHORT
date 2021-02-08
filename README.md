# V-CRED-SHORT

Use Aave credit delegation to short DeFi tokens! 

This is a set of contracts which can be connected to a NodeJS or Python bot to implement shortselling or shorting in DeFi ecosystem. Detailed video is available here: https://youtu.be/S7ny4drGW9g

Requirements:
Alchemy account, truffle, ganache-cli and an understanding of Aave Credit delegation. Since oneInch swap is only available on mainnnet this will be an implementation or simulation in mainnet fork.

The steps involved to test the contracts and incorporate short selling are:
1. Git clone this project
2. Use ganache-cli and fork deterministically with your App ID and block number in Etherscan or use npx node with hardhat
ganache-cli --fork https://eth-mainnet.alcheapi.io/v2/{APP ID} -m "before bench attitude tail praise delay quit current until maple silver ring" 
3. Truffle develop or chain in another window
4. Deploy the marginContract and shortSeller contract
5. You can use the Eth wrapper in contract or Aave Weth gateway to convert test Eth to Weth
6. Use the Weth to deposit collateral by calling depositCollateral method in marginContract
7. Approve short seller as borrower, and call borrow function in shortSeller contract
8. Construct an Axios endpoint for say 3Weth to get call data as follows: 
await axios.get('https://api.1inch.exchange/v2.0/swap?fromTokenAddress=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2&toTokenAddress=0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48&amount=3000000000000000000&fromAddress=0xf9D62C4DB6e2f5e56779D6018461245E9c154f46&slippage=10&disableEstimate=true')
9. Use the call data received and pass it onto transfer Eth USDC function. This will swap Eth to USDC
10. Wait for the price to drop and swap it back from USDC to Eth

Profit from a short sale


![Alt Text](./assets/shorting.png)
