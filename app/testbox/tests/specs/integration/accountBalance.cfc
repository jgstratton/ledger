component displayName="Account Balance Calculations" extends="resources.BaseSpec" {
    
    private component function setupTestTransactionsAndGetAccount() {
        var parentAccount = getAccountFactory().getAccount();
        var subAccount = getAccountFactory().getAccount({linkedAccount: parentAccount});
        parentAccount.addTransaction( getTransactionFactory().createTransaction( {amount: '1.01', verifiedDate:'2000-01-01' } ));
        parentAccount.addTransaction( getTransactionFactory().createTransaction( {amount: '2.06', verifiedDate:'2000-01-01' } ));
        parentAccount.addTransaction( getTransactionFactory().createTransaction( {amount: '3.00'} ));
        subAccount.addTransaction( getTransactionFactory().createTransaction( {amount: '10.50', verifiedDate:'2000-01-01' } ));
        subAccount.addTransaction( getTransactionFactory().createTransaction( {amount: '12.51', verifiedDate:'2000-01-01' } ));
        subAccount.addTransaction( getTransactionFactory().createTransaction( {amount: '13.11'} ));
        ormFlush();
        return parentAccount;
    }

    function getBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-6.07, account.getBalance());
            transaction action="rollback";
        }
    }

    function getVerifiedBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-3.07, account.getVerifiedBalance());
            transaction action="rollback";
        }
    }

    function getLinkedBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-42.19, account.getLinkedBalance());
            transaction action="rollback";
        }
    }

    function getVerifiedLinkedBalanceTest() {
        transaction {
            var account = setupTestTransactionsAndGetAccount();
            $assert.isEqual(-26.08, account.getVerifiedLinkedBalance());
            transaction action="rollback";
        }
    }

}