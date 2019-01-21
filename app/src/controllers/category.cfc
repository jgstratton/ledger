component name="transfer" accessors=true {
    property userService;
    property validatorService;
    property categoryService;

    public void function init(fw){
        variables.fw = arguments.fw;
    }

    public void function manageCategories(required struct rc) {
        rc.viewModel = new beans.viewModels.manageCategories();
    }

    public void function validateCategory(required struct rc) {
        var response = validatorService.getValidateCategory(arguments.rc);
        variables.fw.renderData().data( response ).type( 'json' );
    }

    public void function validateEditCategory(required struct rc) {
        var response = validatorService.c(arguments.rc);
        variables.fw.renderData().data( response ).type( 'json' );
    }

    public void function addCategory(required struct rc) {
        var response = validatorService.getValidateCategory(arguments.rc);
        abortControllerOnFailedResponse(response);

        categoryService.magicCategory(rc.name, rc.multiplier);
        response.setMessage("New category has been added");

        response.generateAlerts();
        variables.fw.redirect("category.manageCategories");
    }

    public void function editCategory(required struct rc) {
        var response = validatorService.getValidateCategory(arguments.rc);
        abortControllerOnFailedResponse(response);
        categoryService.updateExistingCategory(rc.name, rc.multiplier, rc.categoryid);
        response.setMessage("Category has been updated");

        response.generateAlerts();
        variables.fw.redirect("category.manageCategories");
    }

    public void function deleteCategory(required struct rc) {
        response = validatorService.validateMissingParameters(arguments.rc,[
            {name: 'categoryId', errormsg: 'Category id is missing'}
        ]);
        abortControllerOnFailedResponse(response);
        
        categoryService.removeCategoryById(rc.categoryid);
        response.setMessage("Category has been deleted / disabled");
        response.generateAlerts();
        variables.fw.redirect("category.manageCategories");
    }


    public void function newCategoryModal(required struct rc) {
        rc.categoryId = 0;
        rc.multiplier = -1;
        rc.category = new beans.category();
        rc.url = {
            submit: variables.fw.buildurl('category.addCategory'),
            validate: variables.fw.buildurl('category.validateCategory')
        }
        variables.fw.setLayout("ajax");
        variables.fw.setView('category.categoryModal');
    }

    public void function editCategoryModal(required struct rc) {
        rc.category = categoryService.getCategoryById(rc.categoryid);
        rc.multiplier = rc.category.getType().getMultiplier();
        rc.url = {
            submit: variables.fw.buildurl('category.editCategory'),
            validate: variables.fw.buildurl('category.validateCategory'),
            delete: variables.fw.buildurl('category.deleteCategory')
        }
        variables.fw.setLayout("ajax");
        variables.fw.setView('category.categoryModal');
    }

/** Private Functions **/

     /**
     * If there are validation errors when saving the generators, then abort and redirect to the list
     */
    private void function abortControllerOnFailedResponse(required component response) {
        if (!arguments.response.isSuccess()){ 
            arguments.response.generateAlerts();
            variables.fw.redirect("category.manageCategories");
            variables.fw.abortController();
        }
    }

}