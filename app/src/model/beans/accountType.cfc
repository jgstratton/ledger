component persistent="true" table="accountTypes" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="name" ormtype="string" length="100";
    property name="sortWeight" ormtype="integer";
    property name="fa_icon" ormtype="string" length="20";
    property name="isVirtual" ormtype="integer";
    property name="accounts" fieldtype="one-to-many" cfc="account" fkcolumn="id";

    public boolean function isVirtual(){
        return this.getIsVirtual();
    }
}