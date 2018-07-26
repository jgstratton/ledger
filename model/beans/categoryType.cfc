component persistent="true" table="categoryTypes" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="name" ormtype="string" length="50";
    property name="multiplier" ormtype="integer";
    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";


    property name="categories" fieldtype="one-to-many" cfc="category" fkcolumn="id";


}