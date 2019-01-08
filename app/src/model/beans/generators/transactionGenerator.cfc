/**
 * The transaction generator is a type of event that will generate transactions
 * */
component persistent="true" table="transactionGenerators" accessors="true" extends="eventGenerator" joincolumn="eventGenerator_id" { 
   property name="generatorType" persistent="false" default="transaction";
   property name="generatorIcon" persistent="false" default="fa fa-usd";
   property name="id" generator="native" ormtype="integer" fieldtype="id";
   property name="account" fieldtype="many-to-one" cfc="account" fkcolumn="account_id";
   property name="category" fieldtype="many-to-one" cfc="category" fkcolumn="category_id";
   property name="name" ormtype="string" length="100";
   property name="amount" ormtype="big_decimal" precision="10" scale="2";
   property name="note" ormtype="string" length="200";
   property name="deferDate" ormType="integer" default="0";

   public component function init() {
		variables.beanFactory = application.beanFactory;
		variables.categoryService = beanFactory.getBean("categoryService");
      variables.accountService = beanFactory.getBean("accountService");
      return this;
   }
   
   public component function getSourceAccount(){
      return getAccount();
   }
   
   public numeric function getAccountId(){
      if (!isNull(getAccount())) {
         return getAccount().getId();
      }
      return 0;
   }

   public numeric function getCategoryId() {
      if (!isNull(getCategory())) {
         return getCategory().getId();
      }
      return 0;
   }

   public void function setCategoryId(required numeric categoryId) {
      var category = categoryService.getCategoryById(arguments.categoryId);
      setCategory(category);
   }

   public void function setAccountId(required numeric accountId) {
      var account = accountService.getAccountById(arguments.accountId);
      setAccount(account);
   }
}