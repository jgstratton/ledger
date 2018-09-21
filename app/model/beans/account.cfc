component persistent="true" table="accounts" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="user_id";
    property name="name" ormtype="string" length="100";

    property name="linkedAccount" fieldtype="many-to-one" cfc="account" fkcolumn="linkedAccount";
    property name="subAccount" fieldtype="one-to-many" cfc="account" fkcolumn="linkedAccount" inverse="true";

    property name="summary" ormType="string" length="1";
    
    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
    property name="deleted" ormtype="timestamp";

    property name="transactions" fieldtype="one-to-many" cfc="transaction" fkcolumn="account_id";
    property name="type" fieldtype="many-to-one" cfc="accountType" fkcolumn="accountType_id";

    public function validate(){
        local.errors = [];
        
        if(len(this.getName()) eq 0){
            arrayAppend(local.errors, "Account name is required");
        }
        if(Not this.hasUser()){
            arrayAppend(local.errors,"Account is not associated with a user");
        }
        if(listContains('Y,N',this.getSummary()) eq 0 ){
            arrayAppend(local.errors, "Invalid entry for summary flag");
        }

        if(not this.isVirtual() and this.hasLinkedAccount()){
            arrayAppend(local.errors,"Non virtual accounts cannot have a linked account.");
        }
        
        if(this.isVirtual() and not this.hasLinkedAccount()){
            arrayAppend(local.errors,"Virtual accounts must be linked to a parent account");
        }

        if(this.isVirtual() and this.getLinkedAccountID() eq this.getId()){
            arrayappend(local.errors, "Virtual account cannot be linked to itself.");
        }
            
        return local.errors;
    }

    public any function getTypeId(){
        if(this.hasType()){
            return this.getType().getId();
        } 
        return '';
    }

    public any function getLinkedAccountID(){
        if(this.hasLinkedAccount()){
            return this.getLinkedAccount().getId();
        }
        return;
    }
    
    public string function getIcon(){
        if(this.hasType()){
            return this.getType().getFa_icon();
        }

        return '';
    }

    public boolean function inSummary(){
        return (this.getSummary() eq 'Y');
    }
    
    public boolean function isVirtual(){
        if(this.hasType()){
            return (this.getType().isVirtual());
        }
        return 0;
    }

    public numeric function getBalance(){
        return variables.calculateBalance();
    }

    public numeric function getVerifiedBalance(){
        return variables.calculateBalance(verifiedOnly:true);
    }

    public numeric function getLinkedBalance(){
        return variables.calculateBalance(includeLinked:true);
    }

    public numeric function getVerifiedLinkedBalance(){
        return variables.calculateBalance(verifiedOnly:true,includeLinked:true);
    }

    /*
        calculate the account balance by verified/all and includeLinked
    */
    private numeric function calculateBalance(boolean verifiedOnly = false, boolean includeLinked = false){
        var condition1 = '1=2';
        var condition2 = '1=1';

        if(includeLinked){
            condition1 = "a.linkedAccount = :thisAccount";
        }

        if(verifiedOnly){
            condition2 = "trn.verifiedDate is not null";
        }

        local.hql = "
            SELECT coalesce(sum(trn.amount * catType.multiplier),0)
            FROM account a
            JOIN a.transactions trn
            JOIN trn.category cat
            JOIN cat.type catType
            WHERE (a = :thisAccount OR #condition1#) AND (#condition2#)
        ";

        return ORMExecuteQuery(local.hql, {thisAccount: this},true);

    }

    /*
    public any function getLinkedAccounts(){
        return ormExecuteQuery("
            FROM account a
            WHERE linkedAccount = :thisAccount 
            AND deleted IS NULL
            AND a.isVirtual = 1
            ORDER BY a.name",
            {thisAccount: this});
    }
*/

}