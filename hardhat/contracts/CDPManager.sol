// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "./NOI.sol";
import "./Parameters.sol";

error CDPManager__OnlyOwnerAuthorization();
error CDPManager__UnauthorizedLiquidator();
error CDPManager__NotAuthorized();
error CDPManager__HasDebt();
error CDPManager__LiquidationRatioReached();
error CDPManager__ZeroTokenMint();


contract CDPManager {
    struct CDP {
        // Total amount of collateral locked in a CDP
        uint256 lockedCollateral; // [wad]
        // Total amount of debt generated by a CDP
        uint256 generatedDebt; // [wad]
        // Address of owner
        address owner;
    }

    address owner;

    uint256 private totalSupply;
    uint256 public cdpi;
    mapping(uint256 => CDP) private cdpList; // CDPId => CDP

    NOI private immutable NOI_COIN;
    uint256 liquidationRatio;

    address liquidatorContractAddress;
    address parametersContractAddress;

    modifier onlyOwner(){
        if(msg.sender != owner) revert CDPManager__OnlyOwnerAuthorization();
        _;
    }

    modifier onlyLiquidatorContract(){
        if(msg.sender != liquidatorContractAddress) revert CDPManager__UnauthorizedLiquidator();
        _;
    }

    modifier HasAccess(address _user) {
        if(msg.sender != _user) revert CDPManager__NotAuthorized();
        _;
    }

    // EVENTS

    event CDPOpen(address indexed _user,uint256 indexed _cdpId, uint _value);
    event TransferCollateral(address indexed _user,uint256 indexed _cdpId, uint _value);
    event CDPClose(address indexed _user,uint256 indexed _cdpId);
    event OwnershipTransfer(address indexed _from,address indexed _to,uint256 indexed _cdpId);

    constructor(address _noiCoin) {
        totalSupply = 0;
        cdpi = 0;
        NOI_COIN = NOI(_noiCoin);
        liquidationRatio = 120;
        owner = msg.sender;
    }

    function setLiquidatorContractAddress(address _liquidatorContractAddress) public onlyOwner{
        liquidatorContractAddress = _liquidatorContractAddress;
    }


    function setParametersContractAddress(address _parametersContractAdress) public onlyOwner{
        parametersContractAddress = _parametersContractAdress;
    } 

    // Open a new cdp for a given _user address.
    function openCDP(address _user) public payable HasAccess(_user) returns (uint256){
        cdpi = cdpi + 1;
        cdpList[cdpi] = CDP(msg.value, 0, _user);
        totalSupply = totalSupply + msg.value;
        emit CDPOpen(_user,cdpi,msg.value);
        return cdpi;
    }

    //Adds collateral to an existing CDP
    function transferCollateralToCDP(uint _cdpIndex) public payable {
        cdpList[_cdpIndex].lockedCollateral =
            cdpList[_cdpIndex].lockedCollateral +
            msg.value;
        totalSupply = totalSupply + msg.value;
        emit TransferCollateral(cdpList[_cdpIndex].owner,_cdpIndex,msg.value);
    }

    // Close CDP if you have 0 debt
    function closeCDP(uint256 _cdpIndex) public HasAccess(cdpList[_cdpIndex].owner){
        if (cdpList[_cdpIndex].generatedDebt != 0) {
            revert CDPManager__HasDebt();
        }
        (bool sent, ) = payable(cdpList[_cdpIndex].owner).call{
            value: cdpList[_cdpIndex].lockedCollateral
        }("");
        if (sent == false) revert();
        totalSupply = totalSupply - cdpList[_cdpIndex].lockedCollateral;
        emit CDPClose(cdpList[_cdpIndex].owner,_cdpIndex);
        delete cdpList[_cdpIndex];
    }

    // View total supply of ether in contract
    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    // View the state of one CDP
    function getOneCDP(uint256 _cdpIndex)
        public
        view
        returns (CDP memory searchedCDP)
    {
        searchedCDP = cdpList[_cdpIndex];
    }

    // Transfer ownership of CDP
    function transferOwnership(address _from,address _to,uint256 _cdpIndex) public HasAccess(_from){
        cdpList[_cdpIndex].owner=_to;
        emit OwnershipTransfer(_from,_to,_cdpIndex);
    }

    /*
     * @notice mint coins for cdp 
     * @param _cdpIndex index of cdp
     * @param _amount amount of tokens to mint
     */
    function mintFromCDP(uint256 _cdpIndex, uint256 _amount) public HasAccess(cdpList[_cdpIndex].owner) {
        if(_amount == 0)
            revert CDPManager__ZeroTokenMint();
        CDP memory user_cdp = cdpList[_cdpIndex];

        uint256 redemptionPrice=1000; // should get it from RateSetter contract
        uint256 ethPrice = 1000;     // should get it from RateSetter contract

        uint256 newDebt = user_cdp.generatedDebt + _amount;

        uint256 CR = user_cdp.lockedCollateral*ethPrice*100/(newDebt*redemptionPrice);

        uint8 LR = Parameters(parametersContractAddress).getLR();

        if(CR < LR) 
            revert CDPManager__LiquidationRatioReached();

        cdpList[_cdpIndex].generatedDebt += _amount;

        NOI_COIN.mint(user_cdp.owner, _amount);
    }

    /*
     * @notice repay debt in coins
     * @param _cdpIndex index of cdp
     * @param _amount amount of tokens to repay
     */
    function repayToCDP(uint256 _cdpIndex, uint256 _amount) public HasAccess(cdpList[_cdpIndex].owner){
        NOI_COIN.burn(cdpList[_cdpIndex].owner, _amount);
        cdpList[_cdpIndex].generatedDebt -= _amount;
    }


    function liquidatePosition(uint _cdpIndex) public payable onlyLiquidatorContract {
        
        (bool sent, ) = payable(msg.sender).call{
            value: cdpList[_cdpIndex].lockedCollateral
        }("");
        if (sent == false) revert();
        totalSupply = totalSupply - cdpList[_cdpIndex].lockedCollateral;
        emit CDPClose(cdpList[_cdpIndex].owner,_cdpIndex);
        delete cdpList[_cdpIndex];
    }



}
