component output="false" accessors=true {
    property userService;

    public array function getCategories(component anyObj){
        var includeCategoryId = 0;
        if (arguments.keyExists('anyObj') && objHasCategory(arguments.anyObj)) {
            includeCategoryId = anyObj.getCategory().getId();
        }
        return ormExecuteQuery("
            FROM category c
            WHERE c in (
                SELECT userCategories
                FROM category userCategories
                JOIN userCategories.user u
                where u = :user
            )
            or id = :categoryId
            ORDER BY name asc",
        {
            user: userService.getCurrentUser(), 
            categoryId: includeCategoryId
        });
    }

    public any function getCategoryById(id){
        return entityLoadByPk("category",arguments.id);
    }

    public any function getCategoryByName( string categoryName ){
        return EntityLoad('category', { name: arguments.categoryname }, true );
    }

    private boolean function objHasCategory(required component obj) {
        return structKeyExists(arguments.obj,'getCategory') && !IsNull(obj.getCategory());
    }

}