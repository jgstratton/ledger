component persistent="true" table="users" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="username" ormtype="string" length="50";
    property name="email" ormtype="string" length="255";
    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
    property name="accounts" fieldtype="one-to-many" cfc="account" fkcolumn="user_id" singularname="account";
    property name="roundingAccount" fieldtype="many-to-one" cfc="account" fkcolumn="roundingAccount_id";
    property name="roundingModular" ormtype="integer";
    property name="category" fieldtype="many-to-many" cfc="category" linktable="userCategories" fkcolumn="user_id" inverseJoinColumn="category_id" lazy="true";

    public function init(){
        variables.cached = structnew();
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
        return getCheckbookSummaryService().getSummaryBalance();
    }

    public numeric function getRoundingAccountId(){
        if (!isNull(getRoundingAccount())) {
            return getRoundingAccount().getId();
        }
        return 0;
    }

    public void function removeRoundingAccount(){
        setRoundingAccount(javaCast('null', ''));
    }

    private component function getBeanfactory() {
        return request.beanfactory;
    }

    private component function getCheckbookSummaryService() {
        return getBeanFactory().getBean("checkbookSummaryService");
    }
}

