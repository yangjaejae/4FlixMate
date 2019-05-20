pragma solidity ^0.4.24;
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract FFCashToken is MintableToken{
    
    string public name = 'FFCashToken';
    string public symbol = 'FCT';
    uint8 public decimal = 18;
    
    using SafeMath for uint;
    uint monthlyCost = 4000;

    constructor() public payable {
    }
    
    // 처음 회원가입시 매니저가 캐시토큰을 사용자에게 지급한다. 컨트랙트는 매니저가 실행하고(msg.sender), _user에는 새로 가입한 회원의 주소가 들어간다. 
    function initUserCashToken(address _user, uint _amount) public {
        mint(_user, _amount);
    }
    
    // CashToken을 MateToken으로 환전 (CashToken과 MateToken의 양쪽 메소드를 모두 실행해야 함.)
    function exchangeCashToMate(address _manager, uint ctAmount) public {
        // cash : mate = 100 : 1
        transfer(_manager, ctAmount);
    }
    
    // MateToken을 CashToken으로 환전 (CashToken과 MateToken의 양쪽 메소드를 모두 실행해야 함.)
    function exchangeMateToCash(address _manager, uint mtAmount) public {
        // mate : cash = 1: 100
        uint ctAmount = mtAmount.mul(100);
        transferFrom(_manager, msg.sender, ctAmount);
    }

    // 잘못만듬(사용안함)    
    // function buyMateToken3Month(address _manager) public {
    //     uint totalCost = monthlyCost.mul(3);
    //     exchangeCashToMate(_manager, totalCost);
    // }
    
    function cashBalanceOf(address _user) public view returns(uint) {
        return balanceOf(_user);
    }
    
    function() payable public{
        
    }
}