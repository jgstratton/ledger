component output="false" {
    property transferService;

    public numeric function getSummaryBalance(required component user) {
        return ormExecuteQuery("
            SELECT coalesce(sum(trn.amount*ctype.multiplier),0) as Balance
            FROM transaction trn
            JOIN trn.category cat
            JOIN cat.type ctype
            JOIN trn.account act
            WHERE act.user = :user
            AND act.summary = 'Y'
            AND act.deleted is null",
        {user: user},true);
    }

    public void function transferSummaryRounding(required component user) {
        //if rounding account is not set up, exit
        if (!isNull(roundingAccount)) {
            return;
        }

        var transferAmount = getTransferSummaryAmount(arguments.user);  
        var roundingAccount =  arguments.user.getRoundingAccount(); 
        if (transferAmount) {
            roundingTransfer = transferService.createTransfer({
                fromAccount = roundingAccount.getLinkedAccount(),
                toAccount = roundingAccount,
                amount = transferAmount,
                name = "Summary rounding",
                transferDate = now()
            });
            roundingTransfer.save();
        }
    }

    public numeric function getTransferSummaryAmount(required component user) {
        var roundingModular = arguments.user.getRoundingModular();
        if (!isNull(roundingModular) && roundingModular > 0){
            return getSummaryBalance(arguments.user) % roundingModular; 
        }
        return 0;
    }
}