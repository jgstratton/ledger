component persistent="true" table="accounts" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="user_id";
    property name="name" ormtype="string" length="100";
    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
    property name="deleted" ormtype="timestamp";

    property name="transactions" fieldtype="one-to-many" cfc="transaction" fkcolumn="id";


}