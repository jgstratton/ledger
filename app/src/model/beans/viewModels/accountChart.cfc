component accessors="true" {
    property name="trailingAverage" input="viewModels.inputs.select";
    property name="density" input="viewModels.inputs.select";
    property name="startDate";
    property name="endDate";
    property name="Accounts" input="viewModels.inputs.select";
    property name="IncludeLinked";

    //values that come from the rc struct when viewModel is initialized
    property name="user" rcProperty="true";

    private void function init(required struct rc) {
        initializeInputs();
        populateFromRc(rc);
        setOptions();
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
        var defaults = {
            trailingAverage: 0,
            density: 1,
            startDate: dateadd('yyyy',1,now()),
            endDate: now()
        }
        variables.trailingAverage = 0;
        variables.density = 1;
        variables.startDate = dateadd('yyyy',1,now());
        variables.endDate = now();
        //variables.accounts = 
    }
}