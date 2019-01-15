component name="transfer" accessors=true {
    property checkbookSummaryService;
    property accountService;
    property alertService;
    property userService;
    property fw;

    public function checkbookRounding(required struct rc) {
        rc.roundingModularOptions = checkbookSummaryService.getRoundingModularOptions();
        rc.accounts = checkbookSummaryService.getAccountsEligibleForRounding();
        rc.roundingAccount = userService.getCurrentUser().getRoundingAccountId();
        rc.roundingModular = userService.getCurrentUser().getRoundingModular();
    }

    public function disableAutoRounding(required struct rc) {
        userService.getCurrentUser().removeRoundingAccount();
        userService.getCurrentUser().setRoundingModular(1);
        ormFlush();
        alertService.add('success','Auto rounding has been disabled');
        variables.fw.redirect('user.checkbookRounding');
    }

    public function updateAutoRounding(required struct rc) {
        userService.getCurrentUser().setRoundingAccount( accountService.getAccountByid(rc.roundingAccount));
        userService.getCurrentUser().setRoundingModular(rc.roundingModular);
        ormFlush();
        alertService.add('success','Auto rounding settings have been saved');
        variables.fw.redirect('user.checkbookRounding');
    }
}