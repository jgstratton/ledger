component displayName="Summary Rounding Integration Tests" extends="resources.BaseSpec" {
    
    function _setup(){
        
        variables.user = getUserFactory().getTestUser();

        beanFactory = new factories.beanFactory("/beans, /services");
        beanFactory.populateBeanFactory([
            {beanName="checkbookSummaryService", dottedPath="services.checkbookSummary"},
            {beanName="transactionBean", dottedPath="beans.transaction"}
        ]);
  
        beanFactory.getBean("userService").$("getCurrentUser", variables.user);
        request.beanFactory = beanFactory;
    }

    function _setupModular(){
        _setup();
        variables.parentAccount = getAccountFactory().getAccount( {user: variables.user, Summary: 'Y'} );
        variables.subAccount = getAccountFactory().getAccount( {user: variables.user, Summary: 'N', linkedAccount: parentAccount} );
        user.setRoundingAccount(subAccount);
    }

    function roundingModular1Test() {
        transaction {
            _setupModular();
            user.setRoundingModular(1);
            parentAccount.addTransaction( getTransactionFactory().createCreditTransaction({amount: 100}) );
            parentAccount.addTransaction( getTransactionFactory().createExpenseTransaction({amount: 0.01}) );
            ormFlush();
            beanFactory.getBean("checkbookSummaryService").transferSummaryRounding();
            $assert.isEqual(99, user.getSummaryBalance());
            transaction action="rollback";
        }
        
       
        
    }

    function roundingModular5Test() {
        transaction {
            _setupModular();
            user.setRoundingModular(5);
            parentAccount.addTransaction( getTransactionFactory().createCreditTransaction({amount: 100}));
            parentAccount.addTransaction( getTransactionFactory().createExpenseTransaction({amount: 0.01}));
            ormFlush();

            beanFactory.getBean("checkbookSummaryService").transferSummaryRounding();
            $assert.isEqual(95, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

    function roundingModular10Test() {
        transaction {
            _setupModular();
            user.setRoundingModular(10);
            parentAccount.addTransaction( getTransactionFactory().createCreditTransaction({amount: 100}));
            parentAccount.addTransaction( getTransactionFactory().createExpenseTransaction({amount: 0.01}));
            ormFlush();

            beanFactory.getBean("checkbookSummaryService").transferSummaryRounding();
            $assert.isEqual(90, user.getSummaryBalance());
            transaction action="rollback";
        }
    }

    function childAccountInsummaryCannotBeUsedForRoundingTest() {
        transaction {
            _setup();
            variables.parentAccount = getAccountFactory().getAccount( {user: user, Summary: 'Y'} );
            variables.subAccount_canBeUsed = getAccountFactory().getAccount( {user: user, Summary: 'N', linkedAccount: parentAccount} );
            variables.subAccount_canNotBeUsed1 = getAccountFactory().getAccount( {user: user, Summary: 'Y', linkedAccount: parentAccount} );
            ormFlush();

            var numberOfEligibleSubAccounts = beanFactory.getBean("checkbookSummaryService").getAccountsEligibleForRounding(user).len();
            $assert.isEqual(1,numberOfEligibleSubAccounts);
            transaction action="rollback";
        }
    }

    function parentAccountNotInsummaryCannotBeUsedForRoundingTest() {
        transaction {
            _setup();
            variables.parentAccount = getAccountFactory().getAccount( {user: user, Summary: 'N'} );
            variables.subAccount_canBeUsed = getAccountFactory().getAccount( {user: user, Summary: 'N', linkedAccount: parentAccount} );
            variables.subAccount_canNotBeUsed1 = getAccountFactory().getAccount( {user: user, Summary: 'Y', linkedAccount: parentAccount} );
            ormFlush();

            var numberOfEligibleSubAccounts = beanFactory.getBean("checkbookSummaryService").getAccountsEligibleForRounding(user).len();
            $assert.isEqual(0,numberOfEligibleSubAccounts);
            transaction action="rollback";
        }
    }

    function multipleChildAccountsForRoundingTest() {
        transaction {
            _setup();
            variables.parentAccount = getAccountFactory().getAccount( {user: user, Summary: 'Y'} );
            variables.parentAccount2 = getAccountFactory().getAccount( {user: user, Summary: 'Y'} );
            variables.subAccount_canBeUsed = getAccountFactory().getAccount( {user: user, Summary: 'N', linkedAccount: parentAccount} );
            variables.subAccount_canBeUsed2 = getAccountFactory().getAccount( {user: user, Summary: 'N', linkedAccount: parentAccount2} );
            ormFlush();

            var numberOfEligibleSubAccounts = beanFactory.getBean("checkbookSummaryService").getAccountsEligibleForRounding(user).len();
            $assert.isEqual(2,numberOfEligibleSubAccounts);
            transaction action="rollback";
        }
    }

    function generatedFromTransactionIsHidden_Test(){
        transaction {
            _setupModular();
            user.setRoundingModular(10);
            parentAccount.addTransaction( getTransactionFactory().createCreditTransaction({amount: 100}));
            parentAccount.addTransaction( getTransactionFactory().createExpenseTransaction({amount: 0.01}));
            ormFlush();
            beanFactory.getBean("checkbookSummaryService").transferSummaryRounding();
            var sourceTransaction = EntityLoad("transaction", {account:parentAccount},"id desc");
            $assert.isTrue(sourceTransaction[1].isHidden());
            transaction action="rollback";
        }
    }
}