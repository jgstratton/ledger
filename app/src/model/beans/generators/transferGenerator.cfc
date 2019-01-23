component persistent="true" table="transferGenerators" accessors="true" extends="eventGenerator" joincolumn="eventGenerator_id" {   
   property name="generatorType" persistent="false" default="transfer";
   property name="generatorIcon" persistent="false" default="fa fa-exchange";
   property name="fromAccount" fieldtype="many-to-one" cfc="account" fkcolumn="fromAccount_id";
   property name="toAccount" fieldtype="many-to-one" cfc="account" fkcolumn="toAccount_id";
   property name="amount" ormtype="big_decimal" precision="10" scale="2";
   property name="name" ormtype="string" length="100";
   property name="deferDate" ormType="integer" default="0";

   public numeric function getFromAccountId(){
      if (!isNull(getFromAccount())) {
         return getFromAccount().getId();
      }
      return 0;
   }

   public numeric function getToAccountId(){
      if (!isNull(getToAccount())) {
         return getToAccount().getId();
      }
      return 0;
   }

   public numeric function getCategoryId() {
      if (!isNull(getCategory())) {
         return getCategory().getId();
      }
      return 0;
   }

   public void function setFromAccountId(required numeric fromAccountId){
      var fromAccount = getAccountService().getAccountById(arguments.fromAccountId);
      setFromAccount(fromAccount);
   }

   public void function setToAccountId(required numeric toAccountId) {
      var toAccount = getAccountService().getAccountById(arguments.toAccountId);
      setToAccount(toAccount);
   }

   public component function getSourceAccount(){
      return getFromAccount();
   }

   private component function getBeanfactory(){
      return request.beanfactory;
   }

   private component function getAccountService() {
      return getBeanfactory().getBean("accountService");
   }
}