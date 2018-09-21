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
    
    public any function getAccounts(){
        return ormExecuteQuery("
            FROM account a
            WHERE user = :user AND deleted IS NULL
            ORDER BY a.linkedAccount.type.id,
                     a.linkedAccount.name,
                     a.type.isVirtual", 
            {user: this});
    }

    public any function getAccountGroups(){
        return ormExecuteQuery("
            FROM account a
            WHERE user = :user 
            AND deleted IS NULL
            AND a.type.isVirtual = 0
            ORDER BY a.type.id,
                     a.name",
            {user: this});
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
                AND accounts.summary = 'Y'
                AND accounts.deleted is null",
            {user_id: this.getid()});
        }
        return this.cached.SummaryBalance.Balance;
    }
}

