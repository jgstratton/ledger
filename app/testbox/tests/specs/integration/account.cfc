component displayName="Account Integration Tests" extends="resources.BaseSpec" {
    // executes before all tests
    function beforeTests() {}
    // executes after all tests
    function afterTests() {}

    function accountPersistenceTest() {
        transaction {
            var accountsBefore = EntityLoad("account");
            var newAccount = EntityNew("account");
            newAccount.save();
            var accountsAfter = EntityLoad("account");
            $assert.isEqual(arraylen(accountsBefore)+1,arraylen(accountsAfter));
            transaction action="rollback";
        }
    }

    function getSubAccountsTest() {
        transaction {
            var parentAccount = getAccountFactory().getAccount({name: 'parent'});
            var nonParentAccount = getAccountFactory().getAccount({name: 'not-parent'});
            var childAccount = getAccountFactory().getAccount({name: 'child-1', linkedAccount: parentAccount});
            var childAccount2 = getAccountFactory().getAccount({name: 'child-2', linkedAccount: parentAccount});
            var nonChildAccount = getAccountFactory().getAccount({name: 'non-child', linkedAccount: nonParentAccount});

            $assert.isEqual(2,arrayLen(parentAccount.getSubAccounts()));
            transaction action="rollback";
        }
    }

    function getLinkedAccountIdShouldReturnZeroIfNoneExistsTest() {
        var account = getAccountFactory().getAccount({name: 'parent'});
        $assert.isEqual(0,account.getlinkedAccountId());
    }

    function getLinkedAccountIdShouldNotBeZeroIfExistsTest() {
        var parentAccount = getAccountFactory().getAccount();
        var childAccount = getAccountFactory().getAccount({linkedAccount:parentAccount});
        var linkedAccountId = childAccount.getLinkedAccountId();

        $assert.isNotEqual(0,linkedAccountId);
        $assert.typeOf("numeric",linkedAccountId);
    }


}