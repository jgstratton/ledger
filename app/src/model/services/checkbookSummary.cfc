component output="false" accessors=true {
    property transferService;
    property userService;

    public numeric function getSummaryBalance() {
        return ormExecuteQuery("
            SELECT coalesce(sum(trn.amount*ctype.multiplier),0) as Balance
            FROM transaction trn
            JOIN trn.category cat
            JOIN cat.type ctype
            JOIN trn.account act
            WHERE act.user = :user
            AND act.summary = 'Y'
            AND act.deleted is null",
        {user: userService.getCurrentUser()}, true);
    }

    public array function getAccountsEligibleForRounding() {
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
            {user: userService.getCurrentUser()});
    }

    public void function transferSummaryRounding() {
        ormflush();
        var transferAmount = getTransferSummaryAmount();  
        
        var roundingAccount =  userService.getCurrentUser().getRoundingAccount(); 
        
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

    public numeric function getTransferSummaryAmount() {
        var roundingModular = userService.getCurrentUser().getRoundingModular();
        if (!isNull(roundingModular) && roundingModular > 0){
            return getSummaryBalance() % roundingModular; 
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