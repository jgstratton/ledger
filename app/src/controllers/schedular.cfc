component name="schedular" output="false" accessors=true extends="_baseController" {

    public void function init(fw){
        variables.fw = arguments.fw;
    }

    public void function before( required struct rc ){
		runAuthorizer(rc, false);
		updateLayoutAndView();
    }

    public void function after( struct rc = {} ){
        runRenderData(rc);
    }

    public void function autoPaymentList(required struct rc){
        rc.generators = eventGeneratorService.getEventGenerators(); 
    }

    /**
     * @layout "ajax"
     * @view "schedular.autoPaymentModal"
     */
    public void function autoPaymentNewModal(required struct rc){
        rc.accounts = accountService.getAccounts();
        rc.categories = categoryService.getCategories();
        rc.transactionGenerator = eventGeneratorService.createTransactionGenerator();
        rc.transferGenerator = eventGeneratorService.createTransferGenerator();
        rc.schedularTypes = schedularService.getSchedularTypes();
        rc.activeTab = 'transaction';
    }

    /**
     * @layout "ajax"
     * @view "schedular.autoPaymentModal"
     */
    public void function autoPaymentEditModal(required struct rc) {
        rc.accounts = accountService.getAccounts();
        rc.schedularTypes = schedularService.getSchedularTypes();
        rc.eventGenerator = eventGeneratorService.getEventGeneratorById(rc.eventGeneratorId);
        rc.categories = categoryService.getCategories(rc.eventGenerator);
        rc['#rc.eventGenerator.getGeneratorType()#Generator'] = rc.eventGenerator;
        rc.activeTab = rc.eventGenerator.getGeneratorType();
    }

    /**
     * @renderData "json"
     */
    public void function validateTransactionGeneratorForm(required struct rc){
        var validators = ["ValidateTransactionGenerator", "ValidateGeneratorSchedular"];
        rc.response = validatorService.runValidators(validators, arguments.rc);
    }

    /**
     * @renderData "json"
     */
    public void function validateTransferGeneratorForm(required struct rc){
        var validators = ["ValidateTransferGenerator", "ValidateGeneratorSchedular"];
        rc.response = validatorService.runValidators(validators, arguments.rc);
    }

    public void function saveGeneratorForm(required struct rc) {
        param name="rc.schedularStatus" default="0";
        param name="rc.generatorType" default="";

        var validators = ["Validate#rc.generatorType#Generator", "ValidateGeneratorSchedular"];
        var validateResponse = validatorService.runValidators(validators, arguments.rc);

        abortSaveGeneratorOnFailedResponse(validateResponse);

        //save the transaction generator
        transaction{

            if (len(rc.eventGeneratorId)) {
                var generator = eventGeneratorService.getEventGeneratorById(rc.eventGeneratorId);
            } else {
                var generator = eventGeneratorService.createGeneratorByType(rc.generatorType);   
            }

            var schedular = generator.getSchedular();
            schedular.setEventGenerator(generator);
            variables.fw.populate(generator);
            variables.fw.populate(schedular);
            schedularService.saveSchedular(schedular);
            schedular.setNextRunDate( schedularService.determineNextRunDate(schedular) );
            eventGeneratorService.saveEventGenerator(generator);  
        }

        alertService.add('success','Your auto payment "#rc.eventName#" has been saved.');

        //redirect back to list
        variables.fw.redirect('schedular.autoPaymentList');
    }

    /**
     * @authorizer "authorizeByEventGeneratorId"
     */
    public void function deleteScheduledEvent(required struct rc) {
       var generator = eventGeneratorService.getEventGeneratorById(rc.eventGeneratorId);
       generator.softDelete();
       ormFlush();
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