// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

error Treasury__NotAuthorized();
error Treasury__NotOwner();
error Treasury__NotEnoughFunds();
error Treasury__TransactionFailed();
error Treasury__UnauthorizedCDPManager();

contract Treasury{

    address public immutable owner;
    mapping (address => bool) userAuthorized;

    address CDPManagerContractAddress;

    uint256 public unmintedNoiBalance = 0;

    event TreasuryReceiveNOI(uint256 _amount);


    modifier onlyOwner {
        if (msg.sender != owner) revert Treasury__NotOwner();
        _;
    }

    modifier onlyAuthorized {
        if (userAuthorized[msg.sender] == false) revert Treasury__NotAuthorized();
        _;
    }

    modifier onlyCDPManagerContract(){
        if(msg.sender != CDPManagerContractAddress) revert Treasury__UnauthorizedCDPManager();
        _;
    }

    constructor(address _owner) {
        owner = _owner;
        userAuthorized[owner] = true;
    }



    function addAuthorization(address _to) public onlyOwner {
        userAuthorized[_to] = true;
    }

    function removeAuthorization(address _from) public onlyOwner {
        userAuthorized[_from] = false;
    }


    function setCDPManagerContractAddress(address _CDPManagerContractAddress) public onlyOwner{
        CDPManagerContractAddress = _CDPManagerContractAddress;
    }

    /*
     * @notice sends requested funds to an authorized user
     * @param _amount amount of ETH requested
     */
    function getFunds(uint256 _amount) public onlyAuthorized {
        if ( getBalanceOfTreasury() < _amount ) revert Treasury__NotEnoughFunds();

        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        if (sent == false) revert Treasury__TransactionFailed();
    }

    function getBalanceOfTreasury() public view returns (uint256) {
        return address(this).balance;
    }


    function receiveUnmintedNoi(uint256 _amount) public onlyCDPManagerContract{
        unmintedNoiBalance += _amount;
        emit TreasuryReceiveNOI(_amount);
    }

    receive() external payable {}

}