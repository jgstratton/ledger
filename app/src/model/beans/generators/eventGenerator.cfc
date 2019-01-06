/**
 * This is the base element for the event generators.  The event generators do exactly what they sound like,
 * they generate and event (create transaction, create transfer, send notification, create reminder...)  it doesn't matter what
 * kind of event it is, we can just create a new event generater for it and then the generator can be adde to the schedular.
 */
component persistent="true" table="eventGenerators" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="user_id";
    property name="eventName";
    property name="eventDescription";
    property name="created" ormtype="timestamp";
    property name="edited" ormtype="timestamp";
}

