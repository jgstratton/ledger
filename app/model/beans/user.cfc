component persistent="true" table="users" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="username" ormtype="string" length="50";
    property name="email" ormtype="string" length="255";

    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";

    property name="accounts" fieldtype="one-to-many" cfc="account" fkcolumn="user_id";

    public function init(){
        //location to stored cached queries
        this.cached = structnew();
    }

    public function save(){
        EntityMerge(this);
        EntitySave(this);
    }  
    
    //There's got to be a better place for this... but anyway.
    public query function getAccountGroupsQuery(){

        return queryExecute("
            SELECT actType.id, actType.name, coalesce(Balance,0) as Balance, coalesce(VerifiedBalance,0) as VerifiedBalance
            FROM   accountTypes actType
            LEFT JOIN 
                (SELECT accounts.accountType_id, sum(trn.amount*ctype.multiplier) as Balance
                 FROM transactions trn
                 LEFT JOIN categories cat on trn.category_id = cat.id
                 LEFT JOIN categoryTypes ctype on cat.categoryType_id = ctype.id
                 LEFT JOIN accounts on accounts.id = trn.account_id
                 WHERE accounts.user_id = :user_id
                 GROUP BY accounts.accountType_id) balanceQry
            ON actType.id = balanceQry.accountType_id
            LEFT JOIN 
                (SELECT accounts.accountType_id, sum(trn.amount*ctype.multiplier) as VerifiedBalance
                 FROM transactions trn
                 LEFT JOIN categories cat on trn.category_id = cat.id
                 LEFT JOIN categoryTypes ctype on cat.categoryType_id = ctype.id
                 LEFT JOIN accounts on accounts.id = trn.account_id
                 WHERE accounts.user_id = :user_id
                 and trn.verifiedDate is not null
                 GROUP BY accounts.accountType_id) verifiedBalanceQry
            ON actType.id = verifiedBalanceQry.accountType_id
            WHERE actType.id in 
                (Select accountType_id
                 FROM accounts
                 WHERE user_id = :user_id and deleted is null)",
            {user_id: this.getid()});        
    }

    public numeric function getSummaryBalance(){
        
        if(not StructKeyExists(this.cached,'SummaryBalance')){
            //writelog('summary calculated');
            this.cached.SummaryBalance = queryExecute("
                SELECT coalesce(sum(trn.amount*ctype.multiplier),0) as Balance
                FROM transactions trn
                INNER JOIN categories cat on trn.category_id = cat.id
                INNER JOIN categoryTypes ctype on cat.categoryType_id = ctype.id
                INNER JOIN accounts on accounts.id = trn.account_id
                WHERE accounts.user_id = :user_id
                AND accounts.summary = 'Y'",
            {user_id: this.getid()});
        }
        return this.cached.SummaryBalance.Balance;
    }
}

