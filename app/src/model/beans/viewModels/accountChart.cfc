component accessors="true" {
    property name="trailingAverage" input="viewModels.inputs.select";
    property name="density" input="viewModels.inputs.select";
    property name="startDate" input="viewModels.inputs.date";
    property name="endDate" input="viewModels.inputs.date";
    property name="accounts" input="viewModels.inputs.select";
    property name="includeLinked" input="viewModels.inputs.boolean";

    //values that come from the rc struct when viewModel is initialized
    property name="user" rcProperty="true";

    public struct function getChartData() {
        var selectedAccountIds = getAccounts().getValue();
        var userAccounts = getAccountService().getAccounts();
        var chartData = {
            'datasets' : [],
            'labels' : []
        };
        for (account in UserAccounts) {
            getLoggerService().debug("Getting chart data for account #account.getid()#");
            if (listFind(selectedAccountIds,account.getId())) {
                chartData.datasets.append({
                    'label': account.getName(),
                    'data': getAccountRunningHistory(account)
                });
            }
        }
        return chartData;
    }

    private void function init(required struct rc) {
        initializeInputs();
        populatePropertiesFromRc(rc);
        setOptions();
        setDefaultValues();
        populateInputsFromRc(rc);
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
    private void function populatePropertiesFromRc(required struct rc) {
        var meta = getMetaData(this);

        //update values with rcProperty attribute
        for (var property in meta.properties) {
            if (property.keyExists('rcProperty') && rc.keyExists(property.name)) {
                invoke(this,"set#property.name#", { "#property.name#": rc[property.name]});
            }
        }
    }

    /**
     * Copy the relavent values directly from the rc struct
     */
    private void function populateInputsFromRc(required struct rc) {
        var meta = getMetaData(this);
        //set the input values based on rc
        for (var property in meta.properties) {
            if (property.keyExists('input') && rc.keyExists(property.name)) {
                var inputProperty = invoke(this,"get#property.name#");
                inputProperty.setValue(rc[property.name]);
            }
        }
    }

    private void function setOptions() {
        getTrailingAverage().setOptions([
            {value: 1, text: 'No Average'},
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

        var userAccounts = getAccountService().getAccounts();
        if (local.keyExists('userAccounts')) {
            getAccounts().setOptions(arrayMap(userAccounts, function(userAccount){
                return {value: userAccount.getId(), text: userAccount.getName()}
            }));
        }
    }

    private void function setDefaultValues() {
        getTrailingAverage().setValue(7);
        getDensity().setValue(7);
        getStartDate().setValue(dateadd('yyyy',-1,now()));
        getEndDate().setValue(now());
        if (getAccounts().getOptions().len()) {
            getAccounts().setValueByIndex(1);
        }
        getIncludeLinked().setValue(false);
    }

    /**
     * Get the account running avergage data for the chart
     */
    private array function getAccountRunningHistory(required account account) {
        transaction{
            queryExecute("
                SET @runtot:=0;
                SET @entryNum:=0;

                CREATE TEMPORARY TABLE RunningTotals
                SELECT
                    q1.transactionDate,
                    (@runtot := @runtot + q1.dayTotal) AS balance,
                    (@entryNum := @entryNum + 1) as EntryNum
                FROM
                    (
                        SELECT transactionDate, SUM(signedAmount) AS dayTotal
                        FROM  vw_transactionData vw 
                        LEFT JOIN accounts a on vw.account_id = a.id
                        WHERE  (vw.account_id = :accountid or a.linkedAccount = :linkedAccountId)
                            AND vw.transactionDate >= :accountStartDate
                            AND vw.transactionDate <= :accountEndDate
                        GROUP  BY transactionDate
                        ORDER BY transactionDate
                    ) AS q1;

                /* Can't use the same temp table twice in 1 query, so i have to duplicated it */
                CREATE TEMPORARY TABLE RunningTotals2
                SELECT transactionDate, balance FROM RunningTotals;",

                {
                    accountId: arguments.account.getId(),
                    linkedAccountId: getIncludeLinked().getValue() ? arguments.account.getId() : 0,
                    accountStartDate: getStartDate().getSqlValue(),
                    accountEndDate: getEndDate().getSqlValue()
                }
            );

            var qryRunningTotals = queryExecute("
                
                SELECT 
                    t.transactionDate, 
                    date_format(t.transactionDate,'%Y-%m-%d') as x, 
                    t.balance, 
                    avg(t_past.balance) as y
                FROM RunningTotals t
                INNER JOIN RunningTotals2 as t_past 
                    ON t_past.transactionDate between t.transactionDate - :trailingAverage and t.transactionDate
                WHERE t.transactionDate > '2012-01-01'
                    AND MOD(EntryNum, :density) = 0
                GROUP BY t.transactionDate, date_format(t.transactionDate,'%Y-%m-%d'), t.balance
                ORDER BY t.transactionDate;
                ",
                {
                    accountId: arguments.account.getId(),
                    trailingAverage: getTrailingAverage().getValue(),
                    density: getDensity().getValue()
                }
            );

            /* Delete temporary tables */
            queryExecute("                
                DROP TEMPORARY TABLE RunningTotals;
                DROP TEMPORARY TABLE RunningTotals2;
            ");
        }

        return getQueryUtilService().queryToArray(qryRunningTotals);
    }

    private component function getTransactionDataService() {
        return request.beanfactory.getBean("transactionDataService");
    }

    private component function getLoggerService() {
        return request.beanfactory.getBean("loggerService");
    }

    private component function getAccountService() {
        return request.beanfactory.getBean("accountService");
    }

    private component function getQueryUtilService() {
        return request.beanfactory.getBean("queryUtilService");
    }
}