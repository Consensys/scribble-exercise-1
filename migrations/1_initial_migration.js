const Migrations = artifacts.require("Migrations");
const VulnerableToken = artifacts.require("VulnerableToken");

module.exports = deployer => {
    deployer.deploy(Migrations);
    deployer.deploy(VulnerableToken);
};
