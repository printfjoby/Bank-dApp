pragma solidity ^0.5.1;
    /**
     * @title Decentralized Bank
     * @author Joby Augustine
     * @notice You use this contract for banking operations. 
     * @dev The main Bank contract for banking operations.
     */
contract Bank {
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
     * @param _amount Withdrawal amount.
     * @param _duration Duration of fi deposit.
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
     * @notice Owner can set a fixed deposit duration and its intrest rate. 
     * @dev Owner sets a fixed deposit duration and its intrest rate. 
     * @return _durationToIntrest Array of duration to intrest rate.
     */
    function setFDDurationAndIntrest(mapping[] (uint256 => uint256) _durationToIntrest ) external {
        
    }
    
    /**
     * @notice Get all fixed deposit durations and their intrest rates.
     * @dev Get all fixed deposit durations and their intrest rates.
     * @return _duration Fixed deposit duration.
     * @p _intrest Intrest rate for fixed deposit.
     */
    function getFDDurationAndIntrest() external returns(uint256 _duration, uint256 _intrest) {
        
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
