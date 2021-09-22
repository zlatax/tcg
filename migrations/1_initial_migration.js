const tcg = artifacts.require("Migrations");

module.exports = function(deployer) {
  deployer.deploy(tcg);
};
