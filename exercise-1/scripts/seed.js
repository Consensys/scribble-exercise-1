const VulnerableToken = artifacts.require("VulnerableToken");

HARVEY_ORIGIN = '0xAaaaAaAAaaaAAaAAaAaaaaAAAAAaAaaaAaAaaAA0'
HARVEY_ACCOUNT_1 = '0xAaAaaAAAaAaaAaAaAaaAAaAaAAAAAaAAAaaAaAa2'
HARVEY_ACCOUNT_2 = '0xafFEaFFEAFfeAfFEAffeaFfEAfFEaffeafFeAFfE'

module.exports = async function(callback) {
  try {
    let accounts = await web3.eth.getAccounts();

    contracts = []
    token = await VulnerableToken.new()
    contracts.push(['token', token.address])

    console.log("Deployed contracts:")
    console.table(contracts)
    callback();
  } catch (e) {
    callback(e)
  }
}