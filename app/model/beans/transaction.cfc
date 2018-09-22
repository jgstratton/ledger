component persistent="true" table="transactions" accessors="true" extends="_entity" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="account" fieldtype="many-to-one" cfc="account" fkcolumn="account_id";
    property name="category" fieldtype="many-to-one" cfc="category" fkcolumn="category_id";

    property name="name" ormtype="string" length="100";
    property name="transactionDate" ormtype="date";
    property name="amount" ormtype="big_decimal" precision="10" scale="2";
    property name="note" ormtype="string" length="200";
    property name="verifiedDate" ormtype="timestamp";

    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";

    public array function validate(){
       
        var errors = [];
        
        variables.validate_field(errors,"Description",this.getName(),"required");
        variables.validate_field(errors,"Amount",this.getAmount(),"required,numeric");
        variables.validate_field(errors,"Date",this.getTransactionDate(),"required,USdate");
        
        if(not this.hasCategory()){
            arrayAppend(errors,"Please select a transaction type");
        }

        if(not this.hasAccount()){
            arrayAppend(errors,"The account is required");
        }
        return errors;

    }

    public any function getCategoryId(){
        if(this.hasCategory()){
            return this.getCategory().getid();
        }
        return 1;
    }
}