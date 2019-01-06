/**
 * The transaction generator is a type of event that will generate transactions
 * */
 component persistent="true" table="transactionGenerators" accessors="true" extends="eventGenerator" joincolumn="eventGenerator_id" { 
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="account" fieldtype="many-to-one" cfc="account" fkcolumn="account_id";
    property name="category" fieldtype="many-to-one" cfc="category" fkcolumn="category_id";
    property name="name" ormtype="string" length="100";
    property name="amount" ormtype="big_decimal" precision="10" scale="2";
    property name="note" ormtype="string" length="200";
    property name="autoVerified" default="0";
 }