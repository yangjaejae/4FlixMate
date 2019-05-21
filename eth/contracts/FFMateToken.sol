pragma solidity ^0.4.24;
import '../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol';


contract FFMateToken is MintableToken{
    
    string public name = 'FFMateToken';
    string public symbol = 'FMT';
    uint8 public decimal = 18;
    
    using SafeMath for uint;
    uint monthlyCost = 40;
    
    struct teamInfo {
        address member1;
        address member2;
        address member3;
        bool isLock;
    }
    
    mapping (address => teamInfo) teamMapping;
    mapping (address => address) teamCaptainMapping; 

    modifier isNotLocked(address _teamAccount) {
        require(!teamMapping[_teamAccount].isLock);
        _;
    }
    
    constructor() payable public {
        mint(msg.sender, 1000000);
    }
    
    function() payable external{
        
    }
    
    // CashToken을 MateToken으로 환전 (CashToken과 MateToken의 양쪽 메소드를 모두 실행해야 함.)
    function exchangeCashToMate(address _manager, uint _cashAmount) public {
        // cash : mate = 100 : 1
        uint mtAmount = _cashAmount.div(100);
        transferFrom(_manager, msg.sender, mtAmount);
    }
    
    // MateToken을 CashToken으로 환전 (CashToken과 MateToken의 양쪽 메소드를 모두 실행해야 함.)
    function exchangeMateToCash(address _manager, uint _mtAmount) public {
        // mate : cash = 1: 100
        transfer(_manager, _mtAmount);
    }
    
    // 잘못만듬(사용안함)    
    // function buyMateToken3Month(address _manager) public {
    //     uint totalCost = monthlyCost.mul(300);
    //     exchangeCashToMate(_manager, totalCost);
    // }
    
    function mateBalanceOf(address _user) public view returns(uint) {
        return balanceOf(_user);
    }
    
    // 팀이 매칭되면 매칭정보를 컨트랙트에 저장함.
    function matchTeam(address _teamAccount, address _captain, address _member1, address _member2, address _member3) public {
        teamInfo memory team = teamInfo(_member1, _member2, _member3, false);
        teamMapping[_teamAccount] = team;
        teamCaptainMapping[_teamAccount] = _captain;
    }
    
    // 팀이 매칭된 후 각 사람들이 manager에게 monthlyCost*3만큼 approve를 해주면 모든 user의 승인이 끝난 후 manager가 해당 메소드를 실행해서 teamAccount로 토큰을 전송함. 
    function payMatchingToken(address _teamAccount) public {
        // manager에게 각 팀원이 미리 approve 해줘야 함. 
        teamInfo team = teamMapping[_teamAccount];
        address captain = teamCaptainMapping[_teamAccount];
        
        transferFrom(captain, _teamAccount, monthlyCost*3);
        transferFrom(team.member1, _teamAccount, monthlyCost*3);
        transferFrom(team.member2, _teamAccount, monthlyCost*3);
        transferFrom(team.member3, _teamAccount, monthlyCost*3);
    }
    
    // 매달 teamAccount에 있는 토큰을 팀장에게 전송해줌. (이때 teamAccount로 해당 메소드를 실행해야 함!!)
    function payMonthly(address _teamAccount) public isNotLocked(_teamAccount) {
        address captain = teamCaptainMapping[_teamAccount];
        transferFrom(_teamAccount, captain, monthlyCost*4);
    }
    
    // 악성팀장일 경우 teamAccount lock하는 메소드 
    function lockTeamAccount(address _teamAccount, bool _isLock) public {
        teamMapping[_teamAccount].isLock = _isLock; 
    }
    
    // 팀계좌 locking 여부 반환 
    function isLockedAccount(address _teamAccount) public view returns(bool) {
        return teamMapping[_teamAccount].isLock;
    }
    
    // 팀계좌에 있는 돈을 세명의 팀원에게 배분해줌. 이때도 teamAccount로 메소드 실행해야 함. 
    function distributeToken(address _teamAccount) public {
        teamInfo memory team = teamMapping[_teamAccount];
        uint amount = balanceOf(_teamAccount) / 3;
        
        transferFrom(_teamAccount, team.member1, amount);
        transferFrom(_teamAccount, team.member2, amount);
        transferFrom(_teamAccount, team.member3, amount);
    }
    
    // teamInfo 조회 
    function getTeamInfo(address _teamAccount) public view returns(address, address, address, address, bool) {
        address captain = teamCaptainMapping[_teamAccount];
        teamInfo memory team = teamMapping[_teamAccount];
        return(captain, team.member1, team.member2, team.member3, team.isLock);
    }
}
