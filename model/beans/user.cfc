component persistent="true" table="users" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="username" ormtype="string" length="50";
    property name="emailaddress" ormtype="string" length="255";

    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";

    property name="accounts" fieldtype="one-to-many" cfc="account" fkcolumn="user_id";

}