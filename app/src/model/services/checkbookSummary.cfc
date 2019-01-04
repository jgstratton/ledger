component output="false" accessors=true {
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

    public array function getAccountsEligibleForRounding(required component user) {
        return ormExecuteQuery("
            Select a
            FROM account a
            JOIN a.linkedAccount l
            WHERE a.user = :user 
            AND a.deleted IS NULL
            AND l.summary = 'Y'
            AND a.summary = 'N'
            ORDER BY coalesce(l.type.id,a.type.id),
                        coalesce(l.name,a.name),
                        a.id", 
            {user: arguments.user});
    }

    public void function transferSummaryRounding(required component user) {

        var transferAmount = getTransferSummaryAmount(arguments.user);  
        var roundingAccount =  arguments.user.getRoundingAccount(); 

        //if rounding account is not set up, exit
        if (isNull(roundingAccount)) {
            return;
        }

        if (transferAmount) {
            roundingTransfer = transferService.createTransfer({
                fromAccount = roundingAccount.getLinkedAccount(),
                toAccount = roundingAccount,
                amount = transferAmount,
                name = "Summary rounding",
                transferDate = now()
            });
            roundingTransfer.save();
            transferService.hideFromTransaction(roundingTransfer);
            ormFlush();
        }
    }

    public numeric function getTransferSummaryAmount(required component user) {
        var roundingModular = arguments.user.getRoundingModular();
        if (!isNull(roundingModular) && roundingModular > 0){
            return getSummaryBalance(arguments.user) % roundingModular; 
        }
        return 0;
    }

    public array function getRoundingModularOptions(){
        return [
            {roundingModular: 1, description: "Round to nearest $1.00"},
            {roundingModular: 5, description: "Round to nearest $5.00"},
            {roundingModular: 10, description: "Round to nearest $10.00"}
        ];
    }
}