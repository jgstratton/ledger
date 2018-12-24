component category{

    public component function init(struct categoryParameters){
        cfparam(name ="arguments.categoryParameters.type", default = EntityLoadByPk("CategoryType",2));
        var categoryBean = EntityNew("category", arguments.categoryParameters);	
        categoryBean.save();
        return categoryBean;	
    }
    
}