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
            SELECT act.id, accountTypes.fa_icon, act.name, coalesce(Balance,0) as Balance, coalesce(VerifiedBalance,0) as VerifiedBalance
            FROM   accounts act
            LEFT JOIN 
                (SELECT coalesce(accounts.linkedAccount,accounts.id) as id, sum(trn.amount*ctype.multiplier) as Balance
                 FROM transactions trn
                 LEFT JOIN categories cat on trn.category_id = cat.id
                 LEFT JOIN categoryTypes ctype on cat.categoryType_id = ctype.id
                 LEFT JOIN accounts on accounts.id = trn.account_id
                 WHERE accounts.user_id = :user_id
                 GROUP BY coalesce(accounts.linkedAccount,accounts.id)) balanceQry
            ON act.id = balanceQry.id
            LEFT JOIN 
                (SELECT coalesce(accounts.linkedAccount,accounts.id) as id, sum(trn.amount*ctype.multiplier) as VerifiedBalance
                 FROM transactions trn
                 LEFT JOIN categories cat on trn.category_id = cat.id
                 LEFT JOIN categoryTypes ctype on cat.categoryType_id = ctype.id
                 LEFT JOIN accounts on accounts.id = trn.account_id
                 WHERE accounts.user_id = :user_id
                 and trn.verifiedDate is not null
                 GROUP BY coalesce(accounts.linkedAccount,accounts.id)) verifiedBalanceQry
            ON act.id = verifiedBalanceQry.id
            LEFT JOIN 
                accountTypes on act.accountType_id = accountTypes.id
            WHERE act.id in 
                (Select linkedAccount
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

