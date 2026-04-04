component persistent="true" table="magic_link_tokens" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="token" ormtype="string" length="255" index="idx_magic_token";
    property name="email" ormtype="string" length="255";
    property name="expires" ormtype="timestamp";
    property name="created" ormtype="timestamp";

    public function init(){
        variables.created = now();
    }
}
