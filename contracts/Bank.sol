// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

    /**
     * @title Decentralized Bank
     * @author Joby Augustine
     * @notice You use this contract for banking operations. 
     * @dev The main Bank contract for banking operations.
     */
     
/* Imports */
import "./SafeMath.sol"; 
import "./ownable.sol";
     
/*Contract */
contract Bank is Ownable {
    
    /* library */
    using SafeMath for uint256;
    
    /* Enuns */
    
    // Loan Status.
    enum LnStatus { 
                
        WaitingForCollateralVerification, // Waiting for collateral verification by the Manager.
                
        Approved, // Loan approved by Manager after collateral verification.
                
        CrossedDeadline // Failed to repay the loan.
    }
            
    
    /* Structs */
    
    // Store Loan information.
    struct LnInfo { 
        
        uint256 loanId; // loan Id.
            
        uint256 amount; // Loan amount.
            
        uint256 duration; // Duration of Loan in Days. 
        
        uint256 interest; // Interest for the Loan.
            
        uint256 endTime; // Loan end time.
        
        uint256 repayAmountBal; // Repayment amount left.
            
        LnStatus loanStatus; //Loan status
            
    }
    
    // Store Fixed Deposit information.
    struct FxDptInfo {
            
        uint256 fdId; // Fixied deposit Id.
        
        uint256 amount; // Fixed Deposit amount.
            
        uint256 duration; // Duration of Fixed Deposit in Days.
        
        uint256 interest; // Interest for the Fixed Diposit.
            
        uint256 endTime; // Fixed Deposit end time.
            
    }
     
     
    // Store information of the User.
    struct UsrInfo{
        
        bool acc_status; // Account status. `true` value denoted existing user; 
        
        uint256 balance; // Balance amount.
        
        uint256 totalUsrFD; // Sum total of all Fixed Diposit.
        
        LnInfo[] loanInfo; // Store details of all Loans of an User.
        
        FxDptInfo[] fdInfo; // Store details of all Fixed Deposits of an User.
        
    }
    
    // Loan tariff
    struct LoanTariff{
        
        uint256 duration; // Loan duration.
        
        uint256 interest; // Loan intrest.
        
    }
    
    // Fixed Deposit tariff
    struct FdTariff{
        
        uint256 duration; // Fixed Deposit duration.
        
        uint256 interest; // Fixed Deposit intrest.
        
    }
    
    
    
    /*Events */
    
    /**
     * @dev Emitted when User deposits to his/her account.
     * @param _userAddr User address.
     * @param _amount Amount deposited.
     */
    event Deposit(address _userAddr, uint _amount);  
    
    
    /**
     * @dev Emitted when User withdraws from his/her account.
     * @param _userAddr User address.
     * @param _amount Amount withdrawn.
     */
    event Withdraw(address _userAddr, uint256 _amount);  
    
    
    /**
     * @dev Emitted when User deposits an amount for a fixed duration.
     * @param _fdId Fixed diposit Id
     * @param _userAddr User address.
     * @param _amount Deposit amount.
     * @param _tariffId Tariff Id for fixed deposit.
     */
    event FixedDeposit(uint256 indexed _fdId, address _userAddr, uint256 _amount, uint256 _tariffId); 
        
    
    /**
     * @dev Emitted when User withdraws his/her fixed deposit.
     * @param _fdId Fixed diposit Id
     * @param _userAddr User address.
     * @param _amount Amount withdrawn.
     */
    event WithdrawFD(uint256 indexed _fdId, address _userAddr, uint256 _amount);  
        
    
    /**
     * @dev Emitted when User withdraws his/her fixed deposit before maturity period.
     * @param _fdId Fixed diposit Id
     * @param _userAddr User address.
     * @param _amount Amount withdrawn.
     */
    event WithdrawFDBeforeMaturity(uint256 indexed _fdId, address _userAddr, uint256 _amount);  
        
    
    /**
     * @dev Emitted when User requests for a loan.
     * @param _loanId Loan id.
     * @param _userAddr User address.
     * @param _amount Loan amount.
     * @param _tariffId Tariff Id for Loan.
     */
    event RequestLoan(uint256 indexed _loanId, address _userAddr, uint256 _amount, uint256 _tariffId);  
    
    /**
     * @dev Emitted when User cancel Loan request.
     * @param _loanId Loan id.
     * @param _userAddr User address.
     */
    event CancelLoanRequest(uint256 indexed _loanId, address _userAddr); 
        
    
    /**
     * @dev Emitted when User repays the loan.
     * @param _loanId Loan id.
     * @param _userAddr User address.
     * @param _amount Repay amount.
     */
    event RepayLoan(uint256 indexed _loanId, address _userAddr, uint256 _amount);   
    
    /**
     * @dev Emitted when User failed to repay loan.
     * @param _loanId Loan id.
     * @param _userAddr User address.
     */
    event LoanDeadLineCrosssed(uint256 indexed _loanId, address _userAddr); 
    
    /**
     * @dev Emitted when Loan is closed.
     * @param _userAddr User address.
     * @param _loanId Loan Id.
     */
    event LoanClosed(uint256 indexed _loanId, address _userAddr); 
        
    
    /**
     * @dev Emitted when Manager approve or reject loan.
     * @param _loanId Loan Id
     * @param _userAddr User address.
     * @param _status Loan status, if `true` then loan approved else if `false` then loan rejected.
     */
    event ApproveOrRejectLoan(uint indexed _loanId, address _userAddr, bool _status);  
        
    
    /**
     * @dev Emitted when new deposits are freezed.
     */
    event PausedNewDeposits();  
        
    
    /**
     * @dev Emitted when allows new deposits.
     */
    event ResumedNewDeposits();  
        
    
    /**
     * @dev Emitted when new loans are freezed.
     */
    event PausedNewLoans();  
        
    
    /**
     * @dev Emitted when new loans are available.
     */
    event ResumedNewLoans();  
        
        
    /**
     * @dev Emitted when Owner deposits Eth to the Bank.
     * @param _amount Deposit amount.
     */
    event DepositEthToBank(uint256 _amount);   
        
    
    /**
     * @dev Emitted when Owner withdraws profit.
     * @param _amount Withdraw amount.
     */
    event OwnerWithdraw(uint256 _amount);  
        
    
    /**
     * @dev Emitted when Owner sets a loan duration and its interest rate.
     * @param _duration Loan duration.
     * @param _interest Loan interest.
     * 
     */
    event SetLoanDurationAndInterest(uint256 _duration, uint256 _interest); 

    
    /**
     * @dev Emitted when Owner remove a loan duration and its interest rate.
     * @param _duration Loan duration.
     */
    event RemoveLoanDurationAndInterest(uint256 _duration);  
        
    
    /**
     * @dev Emitted when Owner sets a Fixed deposit duration and its interest rate. 
     * @param _duration of Fixed deposit.
     * @param _interest Fixed deposit interest.
     */
    event SetFDDurationAndInterest(uint256 _duration, uint256 _interest); 
    
    
     /**
     * @dev Emitted when Owner remove a fixed deposit duration and its interest rate.
     * @param _duration Duration of fixed deposit.
     */
    event RemoveFDDurationAndInterest(uint256 _duration);  
        
    
     /**
     * @dev Emitted when Owner changes the manager.
     * @param _managerAddrs Manager's address.
     */
    event SetManager(address _managerAddrs);  
        
    
    
    
     /* Storage */
    
    address[] userAddress; // Array of User addresses.
    
    address public managerAddress; // Managers's Address.
    
    uint256 public contractBalance; // Balance amount of the contract.
    
    uint256 ownerBalance; // Owner Balance.
    
    uint256 constant public loanInterestAmountShare = 10 ; // Loan interest amount share for owner in percent.
    
    uint256 public totalFixedDiposit; // Total fixed diposit.
    
    bool public acceptDeposit; // User can diposit Eth only if `acceptDeposit` is `true`;
    
    bool public loanAvailable; // User can request Loan only if `loanAvailable` is `truw`;
    
    LoanTariff[] lnTariff; // Loan durations and its interest rate.
    
    FdTariff[] fxDptTariff; // Fixed Diposit durations and its interest rate.
    
    
    mapping(address => UsrInfo) userInfo; // Information of User.
    
    
    /* Modifiers */
    
    /** @dev Requires that the sender is the Manager */
    modifier onlyByManager() {
        
        require(managerAddress == msg.sender);
        _;
        
    }
    
    
    /*Constructor */
    
    constructor () public {
        
    
        
    }
    
    
    
    /* Functions */
    

    /**
     * @notice Send eth to deposit it in the account.
     * @dev User deposits to his/her account.
     */
    function deposit() external payable{
        
        if(!userInfo[msg.sender].acc_status) {
            userInfo[msg.sender].acc_status = true;
            userAddress.push(msg.sender);
        }
        userInfo[msg.sender].balance = userInfo[msg.sender].balance.add(msg.value);
        contractBalance = contractBalance.add(msg.value);
        
        emit Deposit(msg.sender, msg.value);
      
    }
    
    /**
     * @notice Withdraw an amount from account. 
     * @dev User withdraw from his/her account.
     * @param _amount Withdrawal amount.
     */
    function withdraw(uint256 _amount) external {
        
        require(userInfo[msg.sender].balance >= _amount, "Insufficient Balance");
        msg.sender.transfer(_amount);
        userInfo[msg.sender].balance = userInfo[msg.sender].balance.sub(_amount);
        
        emit Withdraw(msg.sender, _amount);
        
    }
    
    /**
     * @notice Send fixed diposit amount in Eth and choose a tariff.
     * @dev User deposits an amount for a fixed duration.
     * @param _tariffId Tariff id for fixed deposit.
     */
    function fixedDeposit(uint256 _tariffId) external payable {
        
        if(!userInfo[msg.sender].acc_status) {
            userInfo[msg.sender].acc_status = true;
            userAddress.push(msg.sender);
        }
        
        userInfo[msg.sender].totalUsrFD = userInfo[msg.sender].totalUsrFD.add(msg.value);
        
        uint256 _fdId = uint256(keccak256(abi.encodePacked(now, msg.sender)));
        userInfo[msg.sender].fdInfo.push(
            FxDptInfo(
                _fdId,
                msg.value,
                fxDptTariff[_tariffId].duration,
                fxDptTariff[_tariffId].interest,
                now.add(fxDptTariff[_tariffId].duration.mul(1 days) )
            ));
        
        contractBalance = contractBalance.add(msg.value); 
        totalFixedDiposit = totalFixedDiposit.add(msg.value);
        
        emit FixedDeposit(_fdId, msg.sender, msg.value, _tariffId);
        
    }
    
    /**
     * @notice Withdraw fixed deposit.
     * @dev User withdraws his/her fixed deposit with interest.
     * @param _fdIndex Index of the Fixed deposit to be withdrawn.
     */
    function withdrawFD(uint256 _fdIndex) public {
        
        uint256 _fdCount = userInfo[msg.sender].fdInfo.length;
        
        require(_fdIndex < _fdCount, "Invalid choice");
        
        require(userInfo[msg.sender].fdInfo[_fdIndex].endTime >= now, "This Fixed deposit is not matured");
        
        uint256 _interest =  userInfo[msg.sender].fdInfo[_fdIndex].interest;
        
        uint256 _numOfDays = userInfo[msg.sender].fdInfo[_fdIndex].duration.add((now.sub(userInfo[msg.sender].fdInfo[_fdIndex].endTime)).div(1 days));
        
        uint256 _amount =  userInfo[msg.sender].fdInfo[_fdIndex].amount;
        
        _amount = _amount.add(_amount.div(100).mul(_interest));
        
        _amount = _amount.div(365).mul(_numOfDays);
        
        require(contractBalance >= _amount, "Insufficient balance in contract");
        
        userInfo[msg.sender].totalUsrFD = userInfo[msg.sender].totalUsrFD.sub(_amount);
        
        contractBalance = contractBalance.sub(_amount); 
        totalFixedDiposit = totalFixedDiposit.sub(_amount);
        
        emit WithdrawFD(userInfo[msg.sender].fdInfo[_fdIndex].fdId,msg.sender, _amount);
        
        userInfo[msg.sender].fdInfo[_fdIndex] =  userInfo[msg.sender].fdInfo[_fdCount.sub(1)];
        userInfo[msg.sender].fdInfo.pop;
        
        msg.sender.transfer(_amount);
        
    }
    
    /**
     * @notice Withdraw fixed deposit before maturity period.
     * @dev User withdraws his/her fixed deposit before maturity period with penality of 5 percent of the FD.
     * @param _fdIndex Index of the Fixed deposit to be withdrawn.
     */
    function withdrawFDBeforeMaturity(uint256 _fdIndex) external {
        
        if(userInfo[msg.sender].fdInfo[_fdIndex].endTime >= now) {
            
            withdrawFD(_fdIndex);
        }
        else {
        
            uint256 _fdCount = userInfo[msg.sender].fdInfo.length;
            
            require(_fdIndex < _fdCount, "Invalid choice");
            
            uint256 _interest =  userInfo[msg.sender].fdInfo[_fdIndex].interest;
            
            uint256 _numOfDays = (userInfo[msg.sender].fdInfo[_fdIndex].endTime.sub(now)).div(1 days);
            
            uint256 _amount =  userInfo[msg.sender].fdInfo[_fdIndex].amount;
            
            _amount = _amount.add(_amount.div(100).mul(_interest));
            
            _amount = _amount.div(365).mul(_numOfDays);
            
            _amount = _amount.sub(_amount.div(100).mul(5)); // Penality deducted.
            
            require(contractBalance >= _amount, "Insufficient balance in contract");
            
            userInfo[msg.sender].totalUsrFD = userInfo[msg.sender].totalUsrFD.sub(_amount);
            contractBalance = contractBalance.sub(_amount); 
            totalFixedDiposit = totalFixedDiposit.sub(_amount);
            
            emit WithdrawFDBeforeMaturity(userInfo[msg.sender].fdInfo[_fdIndex].fdId,msg.sender, _amount);
            
            userInfo[msg.sender].fdInfo[_fdIndex] =  userInfo[msg.sender].fdInfo[_fdCount.sub(1)];
            userInfo[msg.sender].fdInfo.pop;
            
            msg.sender.transfer(_amount);
            
            
        
        }
        
        
    }
    
    /**
     * @notice Request for a loan.
     * @dev User requests for a loan.
     * @param _amount Loan amount.
     * @param _tariffId Tariff id for Loan.
     */
    function requestLoan(uint256 _amount, uint256 _tariffId) external {
        
        if(!userInfo[msg.sender].acc_status) {
            userInfo[msg.sender].acc_status = true;
            userAddress.push(msg.sender);
        }
        
        uint256 _loanId = uint256(keccak256(abi.encodePacked(now, msg.sender)));
        userInfo[msg.sender].loanInfo.push(
            LnInfo(
                _loanId,
                _amount,
                lnTariff[_tariffId].duration,
                lnTariff[_tariffId].interest,
                0,
                0,
                LnStatus.WaitingForCollateralVerification
            ));
        
        emit RequestLoan(_loanId, msg.sender, _amount, _tariffId);
        
    }
    
    /**
     * @notice Repay loan partially or completely.
     * @dev User repays the loan.
     * @param _loanIndex Index of this Loan.
     */
    function repayLoan(uint256 _loanIndex) external payable {
        
        uint256 _amount = msg.value; 
                
        uint256 _lnCount = userInfo[msg.sender].loanInfo.length;
        
        require(_loanIndex < _lnCount, "Invalid choice");
        
         if(userInfo[msg.sender].loanInfo[_loanIndex].endTime >= now){
             
            userInfo[msg.sender].loanInfo[_loanIndex].loanStatus = LnStatus.CrossedDeadline;
            
            emit LoanDeadLineCrosssed(userInfo[msg.sender].loanInfo[_loanIndex].loanId, msg.sender );
        }
        else{
            
            uint256 _repayAmount = userInfo[msg.sender].loanInfo[_loanIndex].repayAmountBal;
            
            require(_amount > _repayAmount , "Excess Payment");
        
            userInfo[msg.sender].loanInfo[_loanIndex].repayAmountBal = userInfo[msg.sender].loanInfo[_loanIndex].repayAmountBal.sub(_amount); 
            
            contractBalance = contractBalance.add(_repayAmount);
            
            if( _repayAmount == 0 ) {
                emit LoanClosed(userInfo[msg.sender].loanInfo[_loanIndex].loanId, msg.sender);  
                
                uint256 _ownerShare = (userInfo[msg.sender].loanInfo[_loanIndex].amount
                    .div(100)
                    .mul(userInfo[msg.sender].loanInfo[_loanIndex].interest)
                    )
                    .div(100)
                    .mul(loanInterestAmountShare); // `loaloanInterestAmountShare` percent of intrest amount
                
                ownerBalance = ownerBalance.add(_ownerShare);
                contractBalance = contractBalance.sub(_ownerShare);
                userInfo[msg.sender].loanInfo[_loanIndex] =  userInfo[msg.sender].loanInfo[_lnCount.sub(1)];
                userInfo[msg.sender].loanInfo.pop;

            }
            
            emit RepayLoan(userInfo[msg.sender].loanInfo[_loanIndex].loanId, msg.sender, _amount);
        }
        
    }
    
    /**
     * @notice Request for a loan.
     * @dev User requests for a loan.
     * @param _loanIndex Loan index id.
     */
    function cancelLoanRequest(uint256 _loanIndex) external {
        
        require(userInfo[msg.sender].loanInfo[_loanIndex].loanStatus == LnStatus.WaitingForCollateralVerification, "Invalid Loan Id");
        uint256 _lnCount = userInfo[msg.sender].loanInfo.length;
        userInfo[msg.sender].loanInfo[_loanIndex] =  userInfo[msg.sender].loanInfo[_lnCount.sub(1)];
        userInfo[msg.sender].loanInfo.pop;
        
        emit CancelLoanRequest(_loanIndex, msg.sender);
        
    }
    
    
    
    /**
     * @notice View loan requests.
     * @dev Manager can view all loan requests waiting for approval.
     * @return _loans Loans waiting for approval.
     */
    function viewLoanRequests() external returns(uint[] memory _loans) {
        
    }
    
    /**
     * @notice Approve or reject loan.
     * @dev Manager approve or reject loan.
     * @param _loanId Loan Id
     */
    function approveOrRejectLoan(uint _loanId) external {
        
    }
    
    /**
     * @notice Prevent new deposits.
     * @dev Prevent new deposits.
     */
    function pauseNewDeposits() external {
        
    }
    
    /**
     * @notice Allow new deposits.
     * @dev Allow new deposits.
     */
    function resumeNewDeposits() external {
        
    }
    
    /**
     * @notice Prevent new loans.
     * @dev Prevent new loans.
     */
    function pauseNewLoans() external {
        
    }
    
    /**
     * @notice Allow new loans.
     * @dev Allow new loans.
     */
    function resumeNewLoans() external {
        
    }
    
    /**
     * @notice Deposits Eth to the Bank.
     * @dev Owner deposits Eth to the Bank.
     */
    function depositEthToBank() external payable {
        
    }
    
    /**
     * @notice Owner can withdraws profit.
     * @dev Owner withdraws profit.
     * @param _amount Withdraw amount.
     */
    function ownerWithdraw(uint256 _amount) external {
        
    }
    
    /**
     * @notice Get the deposit details of an user.
     * @dev Get the deposit details of an user.
     * @param _userAddrs User address.
     */
    function getUserDepositDetails(address _userAddrs) external {
        
    }
    
    /**
     * @notice Get the loan details of an user.
     * @dev Get the loan details of an user.
     * @param _userAddrs User address.
     */
    function getUserLoanDetails(address _userAddrs) external {
        
    }
    
    /**
     * @notice Set a loan duration and its interest rate.
     * @dev Owner sets a loan duration and its interest rate.
     * @param _duration Loan duration.
     * @param _interest Loan interest.
     * 
     */
    function setLoanDurationAndInterest(uint256 _duration, uint256 _interest) external {
        
    }
    
    /**
     * @notice Get all loan durations and their interest rates
     * @dev Get all loan durations and their interest rates.
     * @param _duration Loan duration.
     * @param _interest Loan interest.
     */
    function getLoanDurationAndInterest() external returns(uint256 _duration, uint256  _interest) {
        
    }
    
    /**
     * @notice Owner can remove a loan duration and its interest rate.
     * @dev Owner remove a loan duration and its interest rate.
     * @param _duration Loan duration.
     */
    function removeLoanDurationAndInterest(uint256 _duration) external {
        
    }
    
    
    /**
     * @notice Owner sets fixed deposit duration and its interest rate.
     * @dev Owner sets fixed deposit duration and its interest rate
     * @param _duration Fixed deposit duration.
     * @param _interest Interest rate for fixed deposit.
     */
    function setFDDurationAndInterest(uint256 _duration, uint256 _interest) external {
        
    }
    
    /**
     * @notice Get all fixed deposit durations and their interest rates. 
     * @dev Get all fixed deposit durations and their interest rates. 
     * @param _duration Fixed deposit duration.
     * @param _interest Interest rate for fixed deposit.
     */
    function getFDDurationAndInterest() external returns (uint256 _duration, uint256 _interest) {
        
    }
    
    
     /**
     * @notice Owner can remove a fixed deposit duration and its interest rate.
     * @dev Owner remove a fixed deposit duration and its interest rate.
     * @param _duration Duration of fixed deposit.
     */
    function removeFDDurationAndInterest(uint256 _duration) external {
        
    }
    
     /**
     * @notice Owner can change the manager. 
     * @dev Owner changes the manager.
     * @param _managerAddrs Manager's address.
     */
    function setManager(address _managerAddrs) external onlyOwner {
        
        managerAddress = _managerAddrs; 
        
    }
    
}
