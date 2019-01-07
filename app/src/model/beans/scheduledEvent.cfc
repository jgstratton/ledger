/**
 * scheduledEvents are the actual instances of sceduled events (with the scheduled date).
 * */
 component persistent="true" table="scheduledEvents" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="event" ormtype="string" length="50";
    property name="dateScheduled";
    property name="status";
}