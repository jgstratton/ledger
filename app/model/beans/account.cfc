component persistent="true" table="accounts" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="user_id";
    property name="name" ormtype="string" length="100";
    property name="linkedAccount" fieldtype="one-to-one" cfc="account" fkcolumn="linkedAccount";
    property name="summary" ormType="string" length="1";
    
    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
    property name="deleted" ormtype="timestamp";

    property name="transactions" fieldtype="one-to-many" cfc="transaction" fkcolumn="id";
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
        if(Not this.hasLinkedAccount()){
            arrayAppend(local.errors,"Missing linked account");
        } else {
            if(this.getLinkedAccount().getId() neq this.getId() and this.hasType()){
                arrayAppend(local.errors,"Non virtual accounts must link to themselves");
            }
            if(this.getLinkedAccount().getId() eq this.getid() and not this.hasType()){
                arrayAppend(local.errors,"Virtual accounts cannot be linked to themselves");
            }
        }
            
        return local.errors;
    }

    public any function getTypeId(){
        if(this.hasType()){
            return this.getType().getId();
        } 
        return;
    }

    public any function getLinkedAccountID(){
        if(this.hasLinkedAccount()){
            return this.getLinkedAccount().getId();
        }
        return;
    }
    
    public boolean function inSummary(){
        return (this.getSummary() eq 'Y');
    }
    
    public numeric function getBalance(){
        return variables.getBalanceByType('all');
    }

    public numeric function getVerifiedBalance(){
        return variables.getBalanceByType('verified');
    }

    private numeric function getBalanceByType(type){

        local.sql = "
            SELECT coalesce(sum(trn.amount*ctype.multiplier),0) as Balance
            FROM transactions trn
            LEFT JOIN categories cat on trn.category_id = cat.id
            LEFT JOIN categoryTypes ctype on cat.categoryType_id = ctype.id
            WHERE trn.account_id = :account_id
        ";

        if(arguments.type eq 'verified'){
            local.sql &= 'and trn.verifiedDate is not null';
        }

        local.balanceQry = queryExecute(local.sql, {account_id: this.getid()});

        return balanceQry.Balance;

    }



}