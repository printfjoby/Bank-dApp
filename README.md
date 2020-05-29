# Bank-dApp
Bank-dApp is an implementation of real world banking operations on Blockchain.
## Basic Description:
This dApp allows users to deposit Eth as an investment and also avail loans as well. User can request Loan by selecting a Loan Tariff, that specifies the Loan Duration to Loan Interest, and Loan Amount. The bank manager, appointed by the owner, verifies the collateral for the Loan offline, provided by the user, manually, and hence approves or rejects the loan request.
 
## User Specification
 
**Manager can :**
 
* Approve 
* Loan
* Reject Loan
* Add new Loan and Fixed Deposit Tariff (Duration to Interest Rate)
* Remove Loan and Fixed Deposit Tariff.
 
**Owner can :**
 
* Appoint Manager
* Stop accepting new Deposits.
* Prevent allowing new Loans.
* Supply Eth to Bank.
* Withdraw Owner’s profit.
 
**User can:**
 
* Deposit
* Withdraw
* Make Fixed Deposit
* Request Loan
* Repay Loan completely or partially
 
**Function List**
* *deposit:* This function is used to deposit an amount in Eth to User’s account. It adds the amount to the balance of the User. User does not get any interest for this deposit.

* *withdraw:* This function is used to withdraw from User’s balance. It takes the amount to withdraw as input and transfer it to the user’s address.
* *fixedDeposit:*  This function is used to deposit an amount as a Fixed Deposit. It takes Fixed Deposit Duration to Interest Rate Tariff’s Id, chosen by the User, as input.
* *withdrawFD:* This function is used to withdraw a Fixed Deposit along with its interest amount if the Fixed Deposit period is completed. It takes the Index Id of the Fixed Deposit to be withdrawn as input.
* *withdrawFDBeforeMaturity:* This function is used to withdraw a Fixed Deposit along with its interest amount, before completion of the Fixed Deposit period. It takes the Index Id of the Fixed Deposit to be withdrawn as input. Five percent of the amount withdrawn is deducted as a penalty.
* *requestLoan:* This function is used to request a new Loan. It takes the amount of Loan required and the Loan Duration to Interest Rate Tariff’s Id, chosen by the User, as input.
* *repayLoan:* This function helps to repay Loan completely or partially. It takes the Index Id of the Loan, which is to be repaid, as Input.
* *cancelLoanRequest:* This function is used to cancel a Requested Loan. It takes the Index of the Loan to be canceled as input.
* *viewLoanRequests:* This function is only accessible by the Manager to view pending Loan requests. It returns Loan Id, User’s Address, Loan Amount, Loan Duration, and Loan Interest of all pending Requests.
* *approveOrRejectLoan:* This function is only accessible by the Manager to approve or reject loan request. Loan Id and a Boolean value as input. Boolean input is given as a `true` value in order to approve a Loan or a `false` value is given to reject a Loan.
* *deadLineCrossed:* This function is only accessible by the Manager to change the Loan Status, when the repayment deadline is crossed. It takes Loan Id as input.
* *pauseNewDeposits:* This function is only accessible by the Owner to stop accepting new Deposits.
* *resumeNewDeposits:* This function is only accessible by the Owner to resume accepting new Deposits.
* *pauseNewLoans:* This function is only accessible by the Owner to prevent new Loans.
* *resumeNewLoans:* This function is only accessible by Owner to allow new Loans.
* *depositEthToBank:* This function is only accessible by Owner to deposit Eth to Bank.
* *ownerWithdraw:* This function is only accessible by the Owner to withdraw the profit amount. It takes the withdrawal amount as input.
* *getUserFdDetails:* This function is used to get the Fixed Deposit Details of a User. It takes the User Address as input and returns Fixed Deposit’s Index, Id, Amount, Interest, Endtime.
* *getUserDepositDetails:* This function is used to get the Deposit details of an User. It takes User Address as input and returns Balance Amount and Total Fixed Deposit Amount.
* *getUserLoanDetails:* This function is used to get the Loan Details of an User. It takes User Address as input and returns Loan’s Index, Id, Amount, Duration, Interest, End Time, Status.
* *getUserLoanStatus:* This function is a private function to get Loan Status. It takes User Address as input and returns Loan Status.
* *setLoanDurationAndInterest:* This function is only accessible by the Manager to set Loan Duration to Interest Tariff. It takes Loan Duration in Days and Interest Rate as input.
* *getLoanDurationAndInterest:* This function is used to get Loan Duration to Interest Rate Tariff. It takes Loan Tariff Id as input.
* *removeLoanDurationAndInterest:* This function is only accessible by Manager to remove a Loan Duration to Interest Rate Tariff. It takes Loan Tariff Id as input.
* *setFDDurationAndInterest:* This function is only accessible by the Manager to set Fixed Deposit Duration to Interest Tariff. It takes Fixed Deposit Duration in Days and its Interest Rate as input.
* *getFDDurationAndInterest:* This function is used to get Fixed Deposit Duration to Interest Rate Tariff. It takes Fixed Deposit Tariff Id as input.
* *removeFDDurationAnd Interest:* This function is only accessible by Manager to remove a Fixed Deposit Duration to Interest Rate Tariff as input. It takes Fixed Deposit Tariff Id as input.
* *setManager:* This function is only accessible by the owner to appoint Manager.
* *getAllUsers:* This function is only accessible by the Manager to get addresses of all users.

## Future Upgrades

* Adjust Fixed Deposit Interest proportionate to the investment amount.
* More than one manager.
