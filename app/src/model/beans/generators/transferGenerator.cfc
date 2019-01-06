component persistent="true" table="transferGenerators" accessors="true" extends="eventGenerator" joincolumn="eventGenerator_id" { 
    property name="fromAccount" fieldtype="many-to-one" cfc="account" fkcolumn="fromAccount_id";
    property name="toAccount" fieldtype="many-to-one" cfc="account" fkcolumn="toAccount_id";
    property name="amount";
    property name="name";
 }