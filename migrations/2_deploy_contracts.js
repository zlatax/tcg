const Tcg = artifacts.require("tcg");

module.exports = function(deployer) {
  deployer.deploy(Tcg);
};