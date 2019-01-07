component persistent="true" table="transferGenerators" accessors="true" extends="eventGenerator" joincolumn="eventGenerator_id" { 
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
}