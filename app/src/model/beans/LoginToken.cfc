component persistent="true" table="login_tokens" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="token" ormtype="string" length="255" index="idx_token";
    property name="expires" ormtype="timestamp";
    property name="created" ormtype="timestamp";
    
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="user_id";

    public function init(){
        variables.created = now();
    }
}
