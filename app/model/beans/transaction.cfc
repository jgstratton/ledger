component persistent="true" table="transactions" accessors="true" {

    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="account" fieldtype="many-to-one" cfc="account" fkcolumn="account_id";
    property name="category" fieldtype="many-to-one" cfc="category" fkcolumn="category_id";

    property name="name" ormtype="string" length="100";
    property name="transactionDate" ormtype="date";
    property name="amount" ormtype="big_decimal" precision="10" scale="2";
    property name="note" ormtype="string" length="200";
    property name="verifiedDate" ormtype="timestamp";

    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
    property name="deleted" ormtype="timestamp";



}