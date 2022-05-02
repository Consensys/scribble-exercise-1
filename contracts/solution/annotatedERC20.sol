pragma solidity ^0.6.0;

contract AnnotatedVulnerableToken {
  uint256 private _totalSupply;
  mapping (address => uint256) private _balances;
  mapping (address => mapping (address => uint256)) private _allowances;

  constructor() public {
    _totalSupply = 1000000;
    _balances[msg.sender] = 1000000;
  }

  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address _owner) external view returns (uint256) {
    return _balances[_owner];
  }

  function allowance(address _owner, address _spender) external view returns (uint256) {
    return _allowances[_owner][_spender];
  }

  /// #if_succeeds msg.sender != _to ==> _balances[_to] == old(_balances[_to]) + _value;
  /// #if_succeeds msg.sender != _to ==> _balances[msg.sender] == old(_balances[msg.sender]) - _value;
  /// #if_succeeds msg.sender == _to ==> _balances[msg.sender] == old(_balances[_to]);
  /// #if_succeeds old(_balances[msg.sender]) >= _value;
  function transfer(address _to, uint256 _value) external returns (bool) {
    address from = msg.sender;
    require(_value <= _balances[from]);

    // _balances[from] -= _value;
    // _balances[_to] += _value;

    uint256 newBalanceFrom = _balances[from] - _value;
    uint256 newBalanceTo = _balances[_to] + _value;
    _balances[from] = newBalanceFrom;
    _balances[_to] = newBalanceTo;

    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) external returns (bool) {
    address owner = msg.sender;
    _allowances[owner][_spender] = _value;
    emit Approval(owner, _spender, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
    uint256 allowed = _allowances[_from][msg.sender];
    require(_value <= allowed);
    require(_value <= _balances[_from]);
    _balances[_from] -= _value;
    _balances[_to] += _value;
    _allowances[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
