const marginContract = artifacts.require("marginContract");
const shortSeller = artifacts.require("shortSeller");

module.exports = function (deployer) {
  deployer.deploy(marginContract);
  deployer.deploy(shortSeller);
};