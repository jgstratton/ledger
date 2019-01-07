component displayName="Has common account test" extends="testbox.system.BaseSpec" {
    // executes before all tests
    function beforeTests() {
        variables.accountService = new services.account();
        variables.account1 = CreateMock("beans.account");
        variables.account2 = CreateMock("beans.account");
    }

    function commonParentSameAccountTest() {
        account1.$("getId",1);
        account2.$("getId",1);
        $assert.isTrue(accountService.hasCommonParent(account1,account2));
    }

    function commonParentLinkedAccountTest() {
        account1.$("getId",1);
        account2.$("getLinkedAccount",1);
        $assert.isTrue(accountService.hasCommonParent(account1,account2));
    }

    function commonParentDifferentSubAccountsTest() {
        account1.$("getLinkedAccount",1);
        account2.$("getLinkedAccount",1);
        $assert.isTrue(accountService.hasCommonParent(account1,account2));
    }

    function commonParentDifferntSubAccountsFalseTest() {
        account1.$("getLinkedAccount",1);
        account2.$("getLinkedAccount",2);
        $assert.isFalse(accountService.hasCommonParent(account1,account2));
    }

    function commonParentDifferentAccountsFalseTest() {
        account1.$("getId",1);
        account2.$("getId",2);
        $assert.isFalse(accountService.hasCommonParent(account1,account2));
    }

}