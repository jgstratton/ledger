/**
 * The schedule types controll which combination of paramters are allowed to be used together
 * For instance, don't allow to schedule by interval (every n days) an schedule by day of week (m,w,f)
 */
component persistent="true" table="schedularTypes" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="name" ormtype="string" length="50";
    property name="allowedParameters";
}