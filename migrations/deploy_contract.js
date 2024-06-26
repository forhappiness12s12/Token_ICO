// migrations/2_deploy_contracts.js
const MyToken = artifacts.require("MyToken");
const TokenICO = artifacts.require("TokenICO");

module.exports = async function (deployer) {
    await deployer.deploy(MyToken);
    const token = await MyToken.deployed();

    const rate = 100; // 1 ETH = 100 MTK
    const duration = 604800; // 1 week in seconds
    await deployer.deploy(TokenICO, token.address, rate, duration);
    const ico = await TokenICO.deployed();

    // Transfer initial tokens to the ICO contract
    const icoTokens = web3.utils.toWei('500000', 'ether'); // 50% of the initial supply
    await token.transfer(ico.address, icoTokens);
};
