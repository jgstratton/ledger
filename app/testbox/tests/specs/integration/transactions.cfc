component displayName="Transaction Integration Tests" extends="resources.BaseSpec" {
    
    // executes before all tests
    function beforeTests() {
        request.user = getUserFactory().getTestUser();

        beanFactory = new factories.beanFactory("/beans, /services");
        beanFactory.populateBeanFactory([
            {beanName="transactionService", dottedPath="services.transaction"}
        ]);
    }
    // executes after all tests
    function afterTests() {}

    private component function setupTestTransactionsAndGetAccount() {
        var parentAccount = getAccountFactory().getAccount();
        var subAccount = getAccountFactory().getAccount( {linkedAccount: parentAccount} );
        parentAccount.addTransactions( getTransactionFactory().createTransaction( {verifiedDate:'2000-01-01' } ));
        parentAccount.addTransactions( getTransactionFactory().createTransaction( {verifiedDate:'2000-01-01' } ));
        parentAccount.addTransactions( getTransactionFactory().createTransaction());
        subAccount.addTransactions( getTransactionFactory().createTransaction( {verifiedDate:'2000-01-01' } ));
        subAccount.addTransactions( getTransactionFactory().createTransaction( {verifiedDate:'2000-01-01' } ));
        subAccount.addTransactions( getTransactionFactory().createTransaction());
        ormFlush();
        return parentAccount;
    }

    function getUnverifiedTransactionsWithoutSubAccountsTest() {
        transactionService = beanFactory.getBean("transactionService");
        transaction {
            parentAccount = setupTestTransactionsAndGetAccount();
            $assert.isEqual(1, transactionService.getUnverifiedTransactions(parentAccount).len());
            transaction action="rollback";
        }
    }

    function getVerifiedTransactionsWithoutSubAccountsTest() {
        transactionService = beanFactory.getBean("transactionService");
        transaction {
            parentAccount = setupTestTransactionsAndGetAccount();
            $assert.isEqual(2, transactionService.getVerifiedTransactions(parentAccount).len());
            transaction action="rollback";
        }
    }

    function getUnverifiedTransactionsWithSubAccountsTest() {
        transactionService = beanFactory.getBean("transactionService");
        transaction {
            var parentAccount = setupTestTransactionsAndGetAccount();
            var includeSubAccounts = true;
            var totalTransactions = transactionService.getUnverifiedTransactions(parentAccount, includeSubAccounts).len();
            $assert.isEqual(2, totalTransactions);
            transaction action="rollback";
        }
    }

    function getVerifiedTransactionsWithSubAccountsTest() {
        transactionService = beanFactory.getBean("transactionService");
        transaction {
            var parentAccount = setupTestTransactionsAndGetAccount();
            var includeSubAccounts = true;
            var totalTransactions = transactionService.getVerifiedTransactions(parentAccount, includeSubAccounts).len();
            $assert.isEqual(4, totalTransactions);
            transaction action="rollback";
        }
    }

    function getTransactionsReturnsArrayOfTransactionsTest() {
        transactionService = beanFactory.getBean("transactionService");
        makePublic( transactionService, 'getTransactions' );
        transaction {
            var parentAccount = setupTestTransactionsAndGetAccount();
            var transactions = transactionService.getTransactions(parentAccount, true, true);
            for (var t in transactions) {
                $assert.instanceOf( t, "beans.transaction" );
            }
            transaction action="rollback";
        }
    }

}