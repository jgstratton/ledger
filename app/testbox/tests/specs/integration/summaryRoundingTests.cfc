component displayName="Summary Rounding Integration Tests" extends="testbox.system.BaseSpec" {
    
    function _setup(){
        variables.transactionGenerator = new generators.transaction();
        variables.userGenerator = new generators.user();
        variables.mockedCheckbookSummaryService = createMock("services.checkbookSummary");
        variables.mockedTransferService = createMock("services.transfer");
        variables.mockedTransferBean = createMock("beans.transfer");

        mockedTransferBean.$property(propertyName="categoryService", mock = new services.category());
        mockedTransferBean.$property(propertyName="transactionService", mock = new services.transaction());
        mockedTransferBean.$property(propertyName="accountService", mock = new services.account());
        mockedCheckbookSummaryService.$property(propertyName="transferService", mock = mockedTransferService);
        mockedTransferService.$("getNewTransferBean", mockedTransferBean );

        variables.user = userGenerator.generate();
    }

    function _setupModular(){
        _setup();
        variables.parentAccount = new generators.account({user: user, Summary: 'Y'});
        variables.subAccount = new generators.account({user: user, Summary: 'N', linkedAccount: parentAccount});
        user.setRoundingAccount(subAccount);
    }

    function roundingModular1Test() {
        transaction {
            _setupModular();
            user.setRoundingModular(1);
            parentAccount.addTransactions( transactionGenerator.generateCreditTransaction({amount: 100}));
            parentAccount.addTransactions( transactionGenerator.generateExpenseTransaction({amount: 0.01}));
            ormFlush();

            mockedCheckbookSummaryService.transferSummaryRounding();
            $assert.isEqual(99, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

    function roundingModular5Test() {
        transaction {
            _setupModular();
            user.setRoundingModular(5);
            parentAccount.addTransactions( transactionGenerator.generateCreditTransaction({amount: 100}));
            parentAccount.addTransactions( transactionGenerator.generateExpenseTransaction({amount: 0.01}));
            ormFlush();

            mockedCheckbookSummaryService.transferSummaryRounding();
            $assert.isEqual(95, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

    function roundingModular10Test() {
        transaction {
            _setupModular();
            user.setRoundingModular(10);
            parentAccount.addTransactions( transactionGenerator.generateCreditTransaction({amount: 100}));
            parentAccount.addTransactions( transactionGenerator.generateExpenseTransaction({amount: 0.01}));
            ormFlush();

            mockedCheckbookSummaryService.transferSummaryRounding();
            $assert.isEqual(90, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

    function childAccountInsummaryCannotBeUsedForRoundingTest() {
        transaction {
            _setup();
            variables.parentAccount = new generators.account({user: user, Summary: 'Y'});
            variables.subAccount_canBeUsed = new generators.account({user: user, Summary: 'N', linkedAccount: parentAccount});
            variables.subAccount_canNotBeUsed1 = new generators.account({user: user, Summary: 'Y', linkedAccount: parentAccount});
            ormFlush();

            var numberOfEligibleSubAccounts = mockedCheckbookSummaryService.getAccountsEligibleForRounding(user).len();
            $assert.isEqual(1,numberOfEligibleSubAccounts);
            transaction action="rollback";
        }
    }

    function parentAccountNotInsummaryCannotBeUsedForRoundingTest() {
        transaction {
            _setup();
            variables.parentAccount = new generators.account({user: user, Summary: 'N'});
            variables.subAccount_canBeUsed = new generators.account({user: user, Summary: 'N', linkedAccount: parentAccount});
            variables.subAccount_canNotBeUsed1 = new generators.account({user: user, Summary: 'Y', linkedAccount: parentAccount});
            ormFlush();

            var numberOfEligibleSubAccounts = mockedCheckbookSummaryService.getAccountsEligibleForRounding(user).len();
            $assert.isEqual(0,numberOfEligibleSubAccounts);
            transaction action="rollback";
        }
    }

    function multipleChildAccountsForRoundingTest() {
        transaction {
            _setup();
            variables.parentAccount = new generators.account({user: user, Summary: 'Y'});
            variables.parentAccount2 = new generators.account({user: user, Summary: 'Y'});
            variables.subAccount_canBeUsed = new generators.account({user: user, Summary: 'N', linkedAccount: parentAccount});
            variables.subAccount_canBeUsed2 = new generators.account({user: user, Summary: 'N', linkedAccount: parentAccount2});
            ormFlush();

            var numberOfEligibleSubAccounts = mockedCheckbookSummaryService.getAccountsEligibleForRounding(user).len();
            $assert.isEqual(2,numberOfEligibleSubAccounts);
            transaction action="rollback";
        }
    }

    function generatedFromTransactionIsHidden_Test(){
        transaction {
            _setupModular();
            user.setRoundingModular(10);
            parentAccount.addTransactions( transactionGenerator.generateCreditTransaction({amount: 100}));
            parentAccount.addTransactions( transactionGenerator.generateExpenseTransaction({amount: 0.01}));
            ormFlush();
            mockedCheckbookSummaryService.transferSummaryRounding();
            var sourceTransaction = EntityLoad("transaction", {account:parentAccount},"id desc");
            $assert.isTrue(sourceTransaction[1].isHidden());
            transaction action="rollback";
        }
    }
}