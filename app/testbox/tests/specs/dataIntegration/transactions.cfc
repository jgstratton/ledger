component displayName="Transaction Integration Tests" extends="testbox.system.BaseSpec" {
    
    // executes before all tests
    function beforeTests() {}
    // executes after all tests
    function afterTests() {}

    private component function setupTestTransactionsAndGetAccount() {
        var transactionGenerator = new generators.transaction(); 
        var parentAccount = new generators.account();
        var subAccount = new generators.account({linkedAccount: parentAccount});
        parentAccount.addTransactions( transactionGenerator.generateTransaction( {verifiedDate:'2000-01-01' } ));
        parentAccount.addTransactions( transactionGenerator.generateTransaction( {verifiedDate:'2000-01-01' } ));
        parentAccount.addTransactions( transactionGenerator.generateTransaction());
        subAccount.addTransactions( transactionGenerator.generateTransaction( {verifiedDate:'2000-01-01' } ));
        subAccount.addTransactions( transactionGenerator.generateTransaction( {verifiedDate:'2000-01-01' } ));
        subAccount.addTransactions( transactionGenerator.generateTransaction());
        ormFlush();
        return parentAccount;
    }

    function getUnverifiedTransactionsWithoutSubAccountsTest() {
        transactionService = new services.transaction();
        transaction {
            parentAccount = setupTestTransactionsAndGetAccount();
            $assert.isEqual(1, transactionService.getUnverifiedTransactions(parentAccount).len());
            transaction action="rollback";
        }
    }

    function getVerifiedTransactionsWithoutSubAccountsTest() {
        transactionService = new services.transaction();
        transaction {
            parentAccount = setupTestTransactionsAndGetAccount();
            $assert.isEqual(2, transactionService.getVerifiedTransactions(parentAccount).len());
            transaction action="rollback";
        }
    }

    function getUnverifiedTransactionsWithSubAccountsTest() {
        transactionService = new services.transaction();
        transaction {
            var parentAccount = setupTestTransactionsAndGetAccount();
            var includeSubAccounts = true;
            var totalTransactions = transactionService.getUnverifiedTransactions(parentAccount, includeSubAccounts).len();
            $assert.isEqual(2, totalTransactions);
            transaction action="rollback";
        }
    }

    function getVerifiedTransactionsWithSubAccountsTest() {
        transactionService = new services.transaction();
        transaction {
            var parentAccount = setupTestTransactionsAndGetAccount();
            var includeSubAccounts = true;
            var totalTransactions = transactionService.getVerifiedTransactions(parentAccount, includeSubAccounts).len();
            $assert.isEqual(4, totalTransactions);
            transaction action="rollback";
        }
    }

    function getTransactionsReturnsArrayOfTransactionsTest() {
        transactionService = new services.transaction();
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