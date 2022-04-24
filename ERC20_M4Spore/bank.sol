// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.6;

// Imports
import "./Libraries.sol";

contract TeamBanking is ReentrancyGuard {
    IERC20 public token;
    uint public cooldownTime = 1 days; // cooldown time
    uint public claimReady; //save claim  time
    address tm1 = 0xD12BF4xxxxxxxx89D0cDD05a1a5014560569;
    address tm2 = 0x91Dd086xxxxxxxxxxx5732c85c7b707EeBBe;
    address tm3 = 0xD12Bxxxxxxxxxxxxx0cDD05a1a5014560569;
    address tm4 = 0x91DdxxxxxxxxxxxF8a2B5732c85c7b707EeBBe;

    constructor(IERC20 _token) {
        token = _token;//erc20 token address of token to be held in this contract
    }

    modifier auth() {// || is OR logic in solidity so IF the activating user IS tm1 OR OR OR hard codes addresses
        require(msg.sender == tm1 || msg.sender == tm2 || msg.sender == tm3 || msg.sender == tm4, 'You must be the listed.');
        _;
    }

    //% calculator
    function mulScale(uint x, uint y, uint128 scale) internal pure returns(uint) {
        uint a = x / scale;
        uint b = x % scale;
        uint c = y / scale;
        uint d = y % scale;

        return a * c * scale + a * d + b * c + b * d / scale;
    }

    //claim
    function claimTokens() public auth nonReentrant {
        require(claimReady <= block.timestamp, "You can't claim now.");
        require(token.balanceOf(address(this)) > 0, "Insufficient Balance.");

        uint _UserBalance = token.balanceOf(address(this));   

        uint _withdrawableBalance = mulScale(_UserBalance, 1000, 10000); // 1000 basis points = 10% of whatever is in contract 

        token.transfer(address(tm1), mulScale(_withdrawableBalance, 2500, 10000));//use same % function to split it in 4 :-)
        token.transfer(address(tm2), mulScale(_withdrawableBalance, 2500, 10000));
        token.transfer(address(tm3), mulScale(_withdrawableBalance, 2500, 10000));
        token.transfer(address(tm4), mulScale(_withdrawableBalance, 2500, 10000));

        claimReady = block.timestamp + cooldownTime;

        _withdrawableBalance = 0;
        _UserBalance = 0;
    }

}
