component displayName="Summary Rounding Integration Tests" extends="testbox.system.BaseSpec" {
    
    function _setup(){
        variables.transactionGenerator = new generators.transaction();
        variables.userGenerator = new generators.user();
        variables.mockedCheckbookSummaryService = createMock("services.checkbookSummary");
        variables.mockedTransferService = createMock("services.transfer");
        variables.mockedTransferBean = createMock("beans.transfer");

        mockedTransferBean.$property(propertyName="categoryService", mock = new services.category());
        mockedTransferBean.$property(propertyName="transactionService", mock = new services.transaction());
        mockedCheckbookSummaryService.$property(propertyName="transferService", mock = mockedTransferService);
        mockedTransferService.$("getNewTransferBean", mockedTransferBean );

        variables.user = userGenerator.generate();
        variables.parentAccount = new generators.account({user: user, Summary: 'Y'});
        variables.subAccount = new generators.account({user: user, Summary: 'N', linkedAccount: parentAccount});
        user.setRoundingAccount(subAccount);
    }

    function roundingModular1Test() {
        transaction {
            _setup();
            user.setRoundingModular(1);
            parentAccount.addTransactions( transactionGenerator.generateCreditTransaction({amount: 100}));
            parentAccount.addTransactions( transactionGenerator.generateExpenseTransaction({amount: 0.01}));
            ormFlush();

            mockedCheckbookSummaryService.transferSummaryRounding(user);
            $assert.isEqual(99, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

    function roundingModular5Test() {
        transaction {
            _setup();
            user.setRoundingModular(5);
            parentAccount.addTransactions( transactionGenerator.generateCreditTransaction({amount: 100}));
            parentAccount.addTransactions( transactionGenerator.generateExpenseTransaction({amount: 0.01}));
            ormFlush();

            mockedCheckbookSummaryService.transferSummaryRounding(user);
            $assert.isEqual(95, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

    function roundingModular10Test() {
        transaction {
            _setup();
            user.setRoundingModular(10);
            parentAccount.addTransactions( transactionGenerator.generateCreditTransaction({amount: 100}));
            parentAccount.addTransactions( transactionGenerator.generateExpenseTransaction({amount: 0.01}));
            ormFlush();

            mockedCheckbookSummaryService.transferSummaryRounding(user);
            $assert.isEqual(90, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

}