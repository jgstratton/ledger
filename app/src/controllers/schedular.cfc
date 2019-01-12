component name="schedular" output="false" accessors=true {
    property eventGeneratorService;
    property accountService;
    property categoryService;
    property alertService;
    property schedularService;
    property validatorService;

    public void function init(fw){
        variables.fw = arguments.fw;
    }

    public void function autoPaymentList(required struct rc){
        rc.generators = eventGeneratorService.getEventGenerators(); 
    }

    public void function autoPaymentNewModal(required struct rc){
        rc.accounts = accountService.getAccounts();
        rc.categories = categoryService.getCategories();
        rc.transactionGenerator = eventGeneratorService.createTransactionGenerator();
        rc.transferGenerator = eventGeneratorService.createTransferGenerator();
        rc.schedularTypes = schedularService.getSchedularTypes;
        rc.activeTab = 'transaction';

        variables.fw.setLayout("ajax");
        variables.fw.setView('schedular.autoPaymentModal');
    }

    public void function autoPaymentEditModal(required struct rc) {
        rc.accounts = accountService.getAccounts();
        rc.categories = categoryService.getCategories();
        rc.schedularTypes = schedularService.getSchedularTypes;
        rc.eventGenerator = eventGeneratorService.getEventGeneratorById(rc.eventGeneratorId);
        rc['#rc.eventGenerator.getGeneratorType()#Generator'] = rc.eventGenerator;
        rc.activeTab = rc.eventGenerator.getGeneratorType();

        variables.fw.setLayout("ajax");
        variables.fw.setView('schedular.autoPaymentModal');
    }

    public void function validateTransactionGeneratorForm(required struct rc){
        var validators = ["ValidateTransactionGenerator", "ValidateGeneratorSchedular"];
        var response = validatorService.runValidators(validators, arguments.rc);
        variables.fw.renderData().data( response ).type( 'json' );
    }

    public void function validateTransferGeneratorForm(required struct rc){
        var validators = ["ValidateTransferGenerator", "ValidateGeneratorSchedular"];
        var response = validatorService.runValidators(validators, arguments.rc);
        variables.fw.renderData().data( response ).type( 'json' );
    }

    public void function saveGeneratorForm(required struct rc) {
        param name="rc.schedularStatus" default="0";
        param name="rc.generatorType" default="";

        var validators = ["Validate#rc.generatorType#Generator", "ValidateGeneratorSchedular"];
        var validateResponse = validatorService.runValidators(validators, arguments.rc);

        abortSaveGeneratorOnFailedResponse(validateResponse);

        //save the transaction generator
        var generator = eventGeneratorService.createGeneratorByType(rc.generatorType);
        var schedular = schedularService.createSchedular();
        if (rc.eventGeneratorId) {
            generator = eventGeneratorService.getEventGeneratorById(rc.eventGeneratorId);
            schedular = generator.getSchedular();
        }
        variables.fw.populate(generator);
        variables.fw.populate(schedular);
        schedular.setEventGenerator(generator);

        transaction{
            eventGeneratorService.saveEventGenerator(generator);
            schedularService.saveSchedular(schedular);
        }
        alertService.add('success','Your auto payment "#rc.eventName#" has been saved.');

        //redirect back to list
        variables.fw.redirect('schedular.autoPaymentList');
    }

    /**
     * If there are validation errors when saving the generators, then abort and redirect to the list
     */
    private void function abortSaveGeneratorOnFailedResponse(required component response) {
        if (!arguments.response.isSuccess()){ 
            arguments.response.generateAlerts();
            variables.fw.setView('schedular.autoPaymentList');
            variables.fw.abortController();
        }
    }
   
}