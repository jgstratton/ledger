component persistent="true" table="users" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="username" ormtype="string" length="50";
    property name="email" ormtype="string" length="255";
    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
    property name="accounts" fieldtype="one-to-many" cfc="account" fkcolumn="user_id";
    property name="roundingAccount" fieldtype="many-to-one" cfc="account" fkcolumn="roundingAccount_id";
    property name="roundingModular" ormtype="integer";

    public function init(){
        //setup private properties
        variables.cached = structnew();
        variables.beanFactory = application.beanFactory;
		variables.checkbookSummaryService = beanFactory.getBean("checkbookSummaryService");
    }

    public function save(){
        EntitySave(this);
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
        return checkbookSummaryService.getSummaryBalance(this);
    }

}

