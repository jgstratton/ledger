component accessors="true" {

    public component function init() {
        variables.allCategoryData = [];
        variables.activeCategories = [];
        variables.inactiveCategories = [];
        variables.isPopulated = false;
        return this;
    }

    public array function getInactiveCategories(){
        populateCategoryData();
        return variables.inactiveCategories;
    }

    public array function getActiveCategories(){
        populateCategoryData();
        return variables.activeCategories;
    }

    public array function getCategories(){
        populateCategoryData();
        return variables.allCategoryData;
    }

/** Private functions **/

    private void function populateCategoryData() {
        if (!variables.isPopulated) {
            var qryActiveCategories = queryExecute("
                Select 
                    categories.id, 
                    categories.name, 
                    categories.categoryType_id,
                    categoryTypes.multiplier,
                    coalesce(transactionCount,0) as transactionCount,
                    coalesce(totalAmount,0) as totalAmount,
                    CASE 
                        WHEN userCategories.category_id is null THEN 0
                        ELSE 1
                    END as isActive
                From categories
                left join (
                    Select cat.id, count(*) as transactionCount, sum(amount) as totalAmount
                    from transactions trans
                    inner join categories cat 
                        on cat.id = trans.category_id
                    inner join accounts act 
                        on trans.account_id = act.id
                        and act.user_id = :user_id
                    group by cat.id
                ) catCounts
                    on categories.id = catCounts.id
                Left Join userCategories 
                    on categories.id = userCategories.category_id
                    and userCategories.user_id = :user_id
                Left join categoryTypes
                    on categories.categoryType_id = categoryTypes.id
                Where categories.name not in ('Transfer From','Transfer Into')
                and (coalesce(transactionCount,0) or userCategories.category_id is not null)
                Order by categories.name",         
            { user_id: getUserService().getCurrentUser().getId() })

            variables.allCategoryData = convertQueryToArrayOfStruct(qryActiveCategories);

            populateActiveInactiveCategories();
            variables.isPopulated = true;
        }
    }

    private void function populateActiveInactiveCategories(){
        for (var category in variables.allCategoryData) {
            if (category.isActive) {
                variables.activeCategories.append(category);
            } else {
                variables.inactiveCategories.append(category);
            }
        }
    }

    private array function convertQueryToArrayOfStruct(required query qry) {
        var returnArray = [];
        for (var i=1; i <= qry.recordcount; i++ ) {
            var rowStruct = {};
            for (var column in qry.columnlist) {
                rowStruct[column] = qry[column][i];
            }
            returnArray.append(rowStruct);
        }
        return returnArray;
    }

    private component function getBeanFactory() {
        return request.beanfactory;
    }

    private component function getUserService() {
        return getBeanFactory().getBean('userService');
    }
}