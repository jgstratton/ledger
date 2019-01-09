/**
 * The schedular controls when events will be scheduled for, and if new events will be scheduled.
 * The events will be scheduled one at a time, once the event occurs, the schedular will determine if
 * and when the event should be rescheduled.
 * */
component persistent="true" table="schedular" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="schedularType" fieldtype="many-to-one" cfc="schedularType" fkcolumn="schedularType_id";
    property name="eventGenerator" fieldtype="many-to-one" cfc="eventGenerator" fkcolumn="eventGenerator_id";
    property name="startDate" ormtype="timestamp";
    property name="monthsOfYear";
    property name="daysOfMonth";
    property name="dayInterval";
    property name="status";

    public void function init(){
        variables.beanFactory = application.beanFactory;
		variables.schedularService = beanFactory.getBean("schedularService");
    }

    public void function save(){
        schedularService.saveSchedular(this);
    }
}