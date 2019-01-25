component {


    public component function getCategory(struct categoryParameters) {
        cfparam(name ="arguments.categoryParameters.type", default = EntityLoadByPk("CategoryType",2));
        var category = EntityNew("category", arguments.categoryParameters);	
        category.save();
        return category;
    }
    
}