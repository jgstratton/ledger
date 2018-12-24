component persistent="true" table="categories" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="name" ormtype="string" length="50";

    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
    property name="deleted" ormtype="timestamp";

    property name="transactions" fieldtype="one-to-many" cfc="transaction" fkcolumn="id";
    property name="type" fieldtype="many-to-one" cfc="categoryType" fkcolumn="categoryType_id";

    public void function save(){
        EntitySave(this);
    }
}