component name="account" output="false"  accessors=true {
    property transactionDataService;
    property accountService;

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function getAccountBalanceChart (struct rc = {}, account){
        rc.chartData = transactionDataService.getAccountRunningHistory(accountService.getAccountByid(1));
        fw.setView('charts.accountBalance');
    }
}