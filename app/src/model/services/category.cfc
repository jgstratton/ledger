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

	public array function getDisabledCategories() {
		return ormExecuteQuery("
			FROM category c
			WHERE c not in (
				SELECT userCategories
				FROM category userCategories
				JOIN userCategories.user u
				where u = :user
			) and c in (
				SELECT transCategory
				FROM transactions t
				JOIN t.category transCategory
				JOIN t.account a
				WHERE a.user = :user
			)
			ORDER BY name asc",
		{
			user: userService.getCurrentUser()
		});
	}

	/**
	 * The magicCategory function checks if a category exists (by name and multiplier), if it does... it activates that
	 * category for the current user and returns the category.  If one does not, it creates a new category, activates it for the
	 * user and returns it.  It basically serves a combined get, activate, and set, function.  Not sure what to call it.
	 */
	public component function magicCategory(required string categoryName, required numeric multiplier) {
		transaction {
			var category = ormExecuteQuery("
				SELECT c
				FROM category c
				JOIN c.type t
				WHERE c.name = :categoryName
					AND t.multiplier = :multiplier",
			{
				categoryName: arguments.categoryName,
				multiplier: arguments.multiplier
			},true);

			if (isNull(category)) {
				var newCategory = createNewCategory(arguments.categoryName, arguments.multiplier);
				entitySave(newCategory);
				activateCategory(newCategory);
				return newCategory;
			} 
			activateCategory(category);
		}
		
		return category;
	}

	public void function updateExistingCategory(required string categoryName, required numeric multiplier, required  numeric categoryId) {
		var previousCategory = getCategoryById(arguments.categoryId);
		var newCategory = magicCategory(arguments.categoryName, arguments.multiplier);
		transaction{
			if (previousCategory.getId() != newCategory.getId()) {
				mergeCategoryTransactions(previousCategory, newCategory);
				removeCategoryFromCurrentUser(previousCategory);
			}
		}
	}

	public void function removeCategoryById(required numeric categoryId) {
		transaction{
			var category = getCategoryById(arguments.categoryId);
			removeCategoryFromCurrentUser(category);
		}
	}

	public void function removeCategoryFromCurrentUser(required component category) {
		arguments.category.removeUser(userService.getCurrentUser());
	}

	public any function getCategoryById(id){
		return entityLoadByPk("category",arguments.id);
	}

	public any function getCategoryByName( string categoryName ){
		return EntityLoad('category', { name: arguments.categoryname }, true );
	}

	public void function activateCategory(required component category) {
		if (!category.hasUser(userService.getCurrentUser())) {
			category.addUser(userService.getCurrentUser());
		}
	}

	public void function deactivateCategory(required component category) {
		if (category.hasUser(userService.getCurrentUser())) {
			category.removeUser(userService.getCurrentUser());
		}
	}
	
/** private functions **/

	private component function createNewCategory(required string categoryName, required numeric multiplier) {
		return EntityNew("category",{
			name: arguments.categoryName,
			type: getDefaultCategoryType(arguments.multiplier)
		});
	}

	private void function mergeCategoryTransactions(required component fromCategory, required component toCategory) {
		var fixTransactionMultiplier = 1;
		
		if (fromCategory.getType().getMultiplier() != toCategory.getType().getMultiplier()) {
			fixTransactionMultiplier = -1;
		}
		
		ormExecuteQuery("
			UPDATE transaction t
			SET t.category = :toCategory,
				t.amount  = t.amount * :transactionMultiplier
			WHERE t.category = :fromCategory
			and t.account in (
				SELECT a
				FROM account a
				WHERE a.user = :user
			)",
		{
			toCategory: arguments.toCategory,
			fromCategory: arguments.fromCategory,
			user: userService.getCurrentUser(),
			transactionMultiplier: fixTransactionMultiplier
		});
	}

	private boolean function objHasCategory(required component obj) {
		return structKeyExists(arguments.obj,'getCategory') && !IsNull(obj.getCategory());
	}

	/** 
	 * I'm probably going to remove category types completely at some point (and move the multiplier to the category
	 * table (since we're not showing types anywhere), but for now I'll just default the type to the first one found
	 * in the database.
	 * */
	private component function getDefaultCategoryType(required numeric multiplier) {
		return ormExecuteQuery("
			FROM categoryType
			WHERE multiplier = :multiplier
			ORDER BY id",
			{ multiplier: arguments.multiplier },true,
			{ maxResults: 1 }
		);
	}

}