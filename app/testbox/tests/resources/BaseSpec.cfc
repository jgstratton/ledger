component extends="testbox.system.BaseSpec" {

    private component function getUserFactory() {
        return new factories.userFactory();
    }

    private component function getCategoryFactory() {
        return new factories.categoryFactory();
    }

    private component function getCategoryFactory() {
        return new factories.categoryFactory();
    }

    private component function getTransactionFactory() {
        return new factories.transactionFactory();
    }

    private component function getAccountFactory() {
        return new factories.accountFactory();
    }
}