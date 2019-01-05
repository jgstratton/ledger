component displayName="Account Integration Tests" extends="testbox.system.BaseSpec" {
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
            var parentAccount = new generators.account({name: 'parent'});
            var nonParentAccount = new generators.account({name: 'not-parent'});
            var childAccount = new generators.account({name: 'child-1', linkedAccount: parentAccount});
            var childAccount2 = new generators.account({name: 'child-2', linkedAccount: parentAccount});
            var nonChildAccount = new generators.account({name: 'non-child', linkedAccount: nonParentAccount});

            $assert.isEqual(2,arrayLen(parentAccount.getSubAccounts()));
            transaction action="rollback";
        }
    }

    function getLinkedAccountIdShouldReturnZeroIfNoneExistsTest() {
        var account = new generators.account({name: 'parent'});
        $assert.isEqual(0,account.getlinkedAccountId());
    }

    function getLinkedAccountIdShouldNotBeZeroIfExistsTest() {
        var parentAccount = new generators.account();
        var childAccount = new generators.account({linkedAccount:parentAccount});
        var linkedAccountId = childAccount.getLinkedAccountId();

        $assert.isNotEqual(0,linkedAccountId);
        $assert.typeOf("numeric",linkedAccountId);
    }


}