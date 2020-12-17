# Scribble Exercise 1

In this exercise we're going to have a look at a vulnerable ERC20 smart contract. 
We'll use Scribble to annotate it with properties, and use Mythril to automatically check the properties (and find bugs 🐛).

### Handy Links
Scribble Repository -> https://github.com/ConsenSys/Scribble
Mythril Repository -> https://github.com/ConsenSys/Mythril
Scribble Docs 📚 -> https://docs.scribble.codes/

### Installation
```
# We'll use Mythril to automatically test specifications
pip3 install mythril

# Make sure to use node 10-12
npm install scribble --global
npm install truffle --global
npm install ganache-cli --global
```

### Setting up the target

```
mkdir exercise-1
cd exercise-1
truffle unbox ConsenSys/scribble-exercise-1
```


### Finding the vulnerability
Have a look at the `transfer()` function:
```
function transfer(address _to, uint256 _value) external returns (bool) {
address from = msg.sender;
require(_value <= _balances[from]);


uint256 newBalanceFrom = _balances[from] - _value;
uint256 newBalanceTo = _balances[_to] + _value;
_balances[from] = newBalanceFrom;
_balances[_to] = newBalanceTo;

emit Transfer(msg.sender, _to, _value);
return true;
}
```

### Adding annotations
Properties that make sense:

* If the transfer function succeeds then the recipient had sufficient balance at the start
* If the transfer succeeds then the sender will have `_value` subtracted from it’s balance (unless you transfer to yourself)
* If the transfer succeeds then the receiver will have `_value` added to it’s balance  (unless you transfer to yourself)
* If the transfer succeeds then the sum of the balances between the sender and receiver remains he same
 
<details>
<summary> If the transfer function succeeds then the recipient had sufficient balance at the start</summary>
<br>
```
/// if_succeeds {:msg "The sender has sufficient balance at the start"} old(_balances[msg.sender] <= _value)
```
</details>

<details>
<summary> If the transfer succeeds then the sender will have `_value` subtracted from it’s balance (unless you transfer to yourself)</summary>
<br>
```
/// if_succeeds {:msg "The sender has _value less balance"} msg.sender != _to ==> old(_balances[msg.sender]) - _value == _balances[msg.sender]; 
```
</details>

<details>
<summary> If the transfer succeeds then the receiver will have `_value` added to it’s balance  (unless you transfer to yourself)</summary>
<br>
```
/// if_succeeds {:msg "The receiver receives _value"} msg.sender != _to ==> old(_balances[_to]) + _value == _balances[_to]; 
```
</details>

<details>
<summary>  If the transfer succeeds then the sum of the balances between the sender and receiver remains he same</summary>
<br>
```
// if_succeeds {:msg "Transfer does not modify the sum of balances" } old(_balances[_to]) + old(_balances[msg.sender]) == _balances[_to] + _balances[msg.sender];
```
</details>

### Finding the bug using Mythril

```
scribbe --arm -m file ./contracts/vulnerableERC20.sol
myth analyze ./contracts/vulnerableERC20.sol
```