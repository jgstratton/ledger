component accessors="true" {
    property name="trailingAverage" input="viewModels.inputs.select";
    property name="density" input="viewModels.inputs.select";
    property name="startDate" input="viewModels.inputs.date";
    property name="endDate" input="viewModels.inputs.date";
    property name="accounts" input="viewModels.inputs.select";
    property name="includeLinked" input="viewModels.inputs.boolean";

    //values that come from the rc struct when viewModel is initialized
    property name="user" rcProperty="true";

    public string function getChartData() {
        var selectedAccountIds = getAccounts().getValue();
        var userAccounts = getUser().getAccountGroups();
        var chartData = {
            'datasets' : []
        };
        for (account in UserAccounts) {
            getLoggerService().debug("Getting chart data for account #account.getid()#");
            if (listFind(selectedAccountIds,account.getId())) {
                chartData.datasets.append({
                    'label': account.getName(),
                    'data': getTransactionDataService().getAccountRunningHistory(account)
                });
            }
        }
        return serializeJson(chartData);
    }

    private void function init(required struct rc) {
        initializeInputs();
        populateFromRc(rc);
        setOptions();
        setDefaultValues();
    }

    /**
     * Initialize each of the "input" properties with a new instance.
     */
    private void function initializeInputs() {
        var meta = getMetaData(this);
        for (var property in meta.properties) {
            if (property.keyExists('input')) {
                invoke(this,"set#property.name#", { "#property.name#": createObject(property.input)});
                var value = invoke(this,"get#property.name#");
                value.init();
                value.setName(property.name);
            }
        }
    }

    /**
     * Copy the relavent values directly from the rc struct
     */
    private void function populateFromRc(required struct rc) {
        var meta = getMetaData(this);
        for (var property in meta.properties) {
            if (property.keyExists('rcProperty') && rc.keyExists(property.name)) {
                invoke(this,"set#property.name#", { "#property.name#": rc[property.name]});
            }
        }
    }

    private void function setOptions() {
        getTrailingAverage().setOptions([
            {value: 0, text: 'No Average'},
            {value: 7, text: 'Weekly'},
            {value: 30, text: 'Monthly'},
            {value: 365, text: 'Yearly'}
        ]);

        getDensity().setOptions([
            {value: 1, text: 'Daily'},
            {value: 7, text: 'Weekly'},
            {value: 30, text: 'Monthly'},
            {value: 365, text: 'Yearly'}
        ]);

        var userAccounts = getUser().getAccountGroups();
        if (local.keyExists('userAccounts')) {
            getAccounts().setOptions(arrayMap(userAccounts, function(userAccount){
                return {value: userAccount.getId(), text: userAccount.getName()}
            }));
        }
    }

    private void function setDefaultValues() {
        getTrailingAverage().setValue(0);
        getDensity().setValue(1);
        getStartDate().setValue(dateadd('yyyy',1,now()));
        getEndDate().setValue(now());
        if (getAccounts().getOptions().len()) {
            getAccounts().setValueByIndex(1)
        }
        getIncludeLinked().setValue(true);
    }

    private component function getTransactionDataService() {
        return request.beanfactory.getBean("transactionDataService");
    }

    private component function getLoggerService() {
        return request.beanfactory.getBean("loggerService");
    }
}