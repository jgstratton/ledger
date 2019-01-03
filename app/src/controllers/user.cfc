component name="transfer" accessors=true {
    property checkbookSummaryService;
    property accountService;
    property alertService;
    property fw;

    public function checkbookRounding(required struct rc) {
        rc.roundingModularOptions = checkbookSummaryService.getRoundingModularOptions();
        rc.accounts = checkbookSummaryService.getAccountsEligibleForRounding(request.user);
        rc.roundingAccount = request.user.getRoundingAccountId();
        rc.roundingModular = request.user.getRoundingModular();
    }

    public function disableAutoRounding(required struct rc) {
        request.user.removeRoundingAccount();
        request.user.setRoundingModular(1);
        ormFlush();
        alertService.add('success','Auto rounding has been disabled');
        variables.fw.redirect('user.checkbookRounding');
    }

    public function updateAutoRounding(required struct rc) {
        request.user.setRoundingAccount( accountService.getAccountByid(rc.roundingAccount));
        request.user.setRoundingModular(rc.roundingModular);
        ormFlush();
        alertService.add('success','Auto rounding settings have been saved');
        variables.fw.redirect('user.checkbookRounding');
    }
}