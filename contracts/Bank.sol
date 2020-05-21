pragma solidity ^0.5.1;

    /**
     * @title Decentralized Bank
     * @author Joby Augustine
     * @notice You use this contract for banking operations. 
     * @dev The main Bank contract for banking operations.
     */
     
contract Bank {
    
    /* Structs */
     
    // Store information of the User.
    struct UsrInfo{
        
        uint256 balance; // Balance amount.
        
        uint256 totalFD; // Sum total of all Fixed Diposit.
        
        // Store Loan information.
        struct LnInfo { 
            
            uint256 amount; // Loan amount.
            
            uint256 duration; // Duration of Loan. 
            
            uint256 endTime; // Loan end time.
            
            uint256 intrest; // Intrest for the Loan.
            
            enum Status ={ // Loan Status.
                
                WaitingForCollateralVerification, // Waiting for collateral verification by the Manager.
                
                Approved, // Loan approved by Manager after collateral verification.
                
                RepaymetFailed // Failed to repay the loan.
            };
            
        }
        
        LnInfo[] loanInfo; // Store details of all Loans of an User.
         
         
        // Store Fixed Deposit information.
        struct fxDptInfo {
            
            uint256 amount; // Fixed Deposit amount.
            
            uint256 duration; // Duration of Fixed Deposit.
            
            uint256 endTime; // Fixed Deposit end time.
            
            uint256 intrest; // Intrest for the Fixed Diposit.
            
            
        }
        
        fxDptInfoInfo[] FDInfo; // Store details of all Fixed Deposits of an User.
        
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
     * @param _userAddr User address.
     * @param _amount Deposit amount.
     * @param _duration Duration of Fixed deposit.
     */
    event FixedDeposit(address _userAddr, uint256 _amount,uint256 _duration); 
        
    
    /**
     * @dev Emitted when User withdraws his/her fixed deposit.
     * @param _userAddr User address.
     * @param _amount Amount withdrawn.
     * @param _fdId Fixed deposit Id.
     */
    event WithdrawFD(address _userAddr, uint256 _amount, uint256 _fdId);  
        
    
    /**
     * @dev Emitted when User withdraws his/her fixed deposit before maturity period.
     * @param _userAddr User address.
     * @param _amount Amount withdrawn.
     * @param _fdId Fixed deposit Id.
     */
    event WithdrawFDBeforeMaturity(address _userAddr, uint256 _amount, uint256 _fdId);  
        
    
    /**
     * @dev Emitted when User requests for a loan.
     * @param _userAddr User address.
     * @param _amount Loan amount.
     * @param _duration Duration of Loan.
     */
    event RequestLoan(address _userAddr, uint256 _amount, uint256 _durationd);  
        
    
    /**
     * @dev Emitted when User repays the loan.
     * @param _userAddr User address.
     * @param _loanId Loan Id.
     * @param _amount Repay amount.
     */
    event RepayLoan(address _userAddr, uint256 _loanId, uint256 _amount);   
        
    
    /**
     * @dev Emitted when Manager approve or reject loan.
     * @param _userAddr User address.
     * @param _loanId Loan Id
     * @param _status Loan status, if `true` then loan approved else if `false` then loan rejected.
     */
    event ApproveOrRejectLoan(address _userAddr, uint _loanId, bool _status);  
        
    
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
     */
    event DepositEthToBank(uint256 _amount);   
        
    
    /**
     * @dev Emitted when Owner withdraws profit.
     * @param _amount Withdraw amount.
     */
    event OwnerWithdraw(uint256 _amount);  
        
    
    /**
     * @dev Emitted when Owner sets a loan duration and its intrest rate.
     * @param _duration Loan duration.
     * @param _intrest Loan intrest.
     * 
     */
    event SetLoanDurationAndIntrest(uint256 _duration, uint256 _intrest); 

    
    /**
     * @dev Emitted when Owner remove a loan duration and its intrest rate.
     * @param _duration Loan duration.
     */
    event RemoveLoanDurationAndIntrest(uint256 _duration);  
        
    
    /**
     * @dev Emitted when Owner sets a Fixed deposit duration and its intrest rate. 
     * @param _duration of Fixed deposit.
     * @param _intrest Fixed deposit intrest.
     */
    event SetFDDurationAndIntrest(uint256 _duration, uint256 _intrest); 
    
    
     /**
     * @dev Emitted when Owner remove a fixed deposit duration and its intrest rate.
     * @uint256 _duration Duration of fixed deposit.
     */
    event RemoveFDDurationAndIntrest(uint256 _duration);  
        
    
     /**
     * @dev Emitted when Owner changes the manager.
     * @param _managerAddrs Manager's address.
     */
    event SetManager(address _managerAddrs);  
        
    
    
    
     /* Storage */
    
    address[] userAddress; // Array of User addresses.
    
    address managerAddress; // Managers's Address.
    
    uint256 contractBalance; // Balance amount of the contract.
    
    bool acceptDeposit; // User can diposit Eth only if `acceptDeposit` is `true`;
    
    bool loanAvailable; // User can request Loan only if `loanAvailable` is `truw`;
    
    mapping[] (uint256 => uint256) loanDurationToIntrest; // Loan durations and its intrest rate.
    
    mapping[] (uint256 => uint256) FDDurationToIntrest; // Fixed Diposit durations and its intrest rate.
    
    
    mapping(address => UsrInfo) userInfo; // Information of User.
    
    
    
    
    
    /*Constructor */
    
    constructor () public {
        
    }
    
    
    
    /* Functions */
    

    /**
     * @notice Send eth to deposit it in the account.
     * @dev User deposits to his/her account.
     */
    function deposit() external payable{
      
    }
    
    /**
     * @notice Withdraw an amount from account. 
     * @dev User withdraw from his/her account.
     * @param _amount Withdrawal amount.
     */
    function withdraw(uint256 _amount) external {
        
    }
    
    /**
     * @notice Send fixed diposit amount in Eth.
     * @dev User deposits an amount for a fixed duration.
     * @param _amount Deposit amount.
     * @param _duration Duration of fixed deposit.
     */
    function fixedDeposit(uint256 _amount,uint256 _duration) external payable {
        
    }
    
    /**
     * @notice Withdraw fixed deposit.
     * @dev User withdraws his/her fixed deposit.
     * @param _fdId Fixed deposit Id.
     */
    function withdrawFD(uint256 _fdId) external {
        
    }
    
    /**
     * @notice Withdraw fixed deposit before maturity period.
     * @dev User withdraws his/her fixed deposit before maturity period.
     * @param _fdId Fixed deposit Id.
     */
    function withdrawFDBeforeMaturity(uint256 _fdId) external {
        
    }
    
    /**
     * @notice Request for a loan.
     * @dev User requests for a loan.
     * @param _amount Loan amount.
     * @param _duration Duration of Loan.
     */
    function requestLoan(uint256 _amount, uint256 _durationd) external {
        
    }
    
    /**
     * @notice Repay loan partially or completely.
     * @dev User repays the loan.
     * @param _loanId Loan Id.
     * @param _amount Repay amount.
     */
    function repayLoan(uint256 _loanId, uint256 _amount) external payable {
        
    }
    
    /**
     * @notice View loan requests.
     * @dev Manager can view all loan requests waiting for approval.
     * @return _loans Loans waiting for approval.
     */
    function viewLoanRequests() external returns(uint[] _loans) {
        
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
     * @notice Set a loan duration and its intrest rate.
     * @dev Owner sets a loan duration and its intrest rate.
     * @param _duration Loan duration.
     * @param _intrest Loan intrest.
     * 
     */
    function setLoanDurationAndIntrest(uint256 _duration, uint256 _intrest) external {
        
    }
    
    /**
     * @notice Get all loan durations and their intrest rates
     * @dev Get all loan durations and their intrest rates.
     * @return _durationToIntrest Array of duration to intrest rate.
     */
    function getLoanDurationAndIntrest() external returns(mapping[] (uint256 => uint256) _durationToIntrest ) {
        
    }
    
    /**
     * @notice Owner can remove a loan duration and its intrest rate.
     * @dev Owner remove a loan duration and its intrest rate.
     * @param _duration Loan duration.
     */
    function removeLoanDurationAndIntrest(uint256 _duration) external {
        
    }
    
    /**
     * @notice Get all fixed deposit durations and their intrest rates. 
     * @dev Get all fixed deposit durations and their intrest rates. 
     * @return _durationToIntrest Array of duration to intrest rates.
     */
    function getFDDurationAndIntrest() external returns (mapping[] (uint256 => uint256) _durationToIntrest ) {
        
    }
    
    /**
     * @notice Owner sets fixed deposit duration and its intrest rate.
     * @dev Owner sets fixed deposit duration and its intrest rate
     * @param _duration Fixed deposit duration.
     * @param _interest Intrest rate for fixed deposit.
     */
    function setFDDurationAndIntrest(uint256 _duration, uint256 _intrest) external {
        
    }
    
     /**
     * @notice Owner can remove a fixed deposit duration and its intrest rate.
     * @dev Owner remove a fixed deposit duration and its intrest rate.
     * @uint256 _duration Duration of fixed deposit.
     */
    function removeFDDurationAndIntrest(uint256 _duration) external {
        
    }
    
     /**
     * @notice Owner can change the manager. 
     * @dev Owner changes the manager.
     * @param _managerAddrs Manager's address.
     */
    function setManager(address _managerAddrs) public {
        
    }
    
}
