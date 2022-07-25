pragma solidity >=0.8.0 <0.9.0;

import "./NOI.sol";

error CDPManager__NotAuthorized();

contract CDPManager {

    struct CDP {
        // Total amount of collateral locked in a CDP
        uint256 lockedCollateral; // [wad]
        // Total amount of debt generated by a CDP
        uint256 generatedDebt; // [wad]
    }

    mapping(address => CDP[]) private cdpListPerUser; // Owner => CDP[]

    NOI private immutable NOI_COIN;

    modifier HasAccess(address _user) {
        if(msg.sender != _user) revert CDPManager__NotAuthorized();
        _;
    }

    constructor(address _noiCoin) {
        NOI_COIN = NOI(_noiCoin);
    }

    // Open a new cdp for a given _user address.
    function openCDP(address _user) public {
        cdpListPerUser[_user].push(CDP(0,0));
    }

    //Adds collateral to an existing CDP
    function transferCollateralToCDP(address _user,uint _cdpIndex) public payable{
        cdpListPerUser[_user][_cdpIndex].lockedCollateral=cdpListPerUser[_user][_cdpIndex].lockedCollateral+msg.value;
    }

    function mintFromCDP(address _user, uint256 _cdpIndex, uint256 _amount) public HasAccess(_user) {
        NOI_COIN.mint(_user, _amount);
    }

    function repayToCDP(address _user, uint256 _cdpIndex, uint256 _amount) public HasAccess(_user){
        NOI_COIN.burn(_user, _amount);
    }
}
