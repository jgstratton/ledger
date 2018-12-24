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

    property name="linkedTo" fieldtype="many-to-one" cfc="transaction" fkcolumn="linkedTransId";
    property name="linkedFrom" fieldtype="one-to-many" cfc="transaction" fkcolumn="linkedTransId" inverse="true";
    
    public void function save() {
        EntitySave(this);
    }
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

    public numeric function getSignedAmount(){
        return (this.getAmount() * this.getCategory().getType().getMultiplier());
    }

    public boolean function isVerified(){
        return len(this.getVerifiedDate());
    }

    public boolean function isTransfer(){
        return(
            (this.hasLinkedTo() and this.getCategory().getName() == 'Transfer From') ||
            (this.hasLinkedFrom() and this.getCategory().getName() == 'Transfer Into') 
        )
    }

    public any function hasLinkedTransaction(){
        return(this.hasLinkedTo() || this.hasLinkedFrom());
    }

    public any function getLinkedTransaction(){
        if(this.hasLinkedTo()){
            return this.getLinkedTo();
        } elseif ( this.hasLinkedFrom()) {
            var linkedFromArray = this.getLinkedFrom();
            return linkedFromArray[1];
        }
    }

    public string function getTransferDescription(){
        if(this.isTransfer()){
            if(this.hasLinkedTo()){
                return "Transferred to #this.getLinkedTo().getAccount().getName()#";
            } elseif ( this.hasLinkedFrom()) {
                return "Transferred from #this.getLinkedTransaction().getAccount().getName()#";
            }
        }
        return '';
    }
/*
    public boolean function getTransfer(){
        return ORMExecuteQuery(
            "from transfer 
             where fromTransaction = :trans 
             or toTransaction = :trans",
             { trans: this}, true);
    }

    public boolean function isTransfer(){
        var transfer = ORMExecuteQuery(
            "from transfer 
             where fromTransaction = :trans 
             or toTransaction = :trans",
             { trans: this});

        return arraylen(transfer);
        
    }
*/
}

