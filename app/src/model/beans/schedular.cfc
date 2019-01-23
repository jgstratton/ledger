/**
 * The schedular controls when events will be scheduled for, and if new events will be scheduled.
 * The events will be scheduled one at a time, once the event occurs, the schedular will determine if
 * and when the event should be rescheduled.
 * */
component persistent="true" table="schedular" accessors="true" {
    property name="id" generator="native" ormtype="integer" fieldtype="id";
    property name="schedularType" fieldtype="many-to-one" cfc="schedularType" fkcolumn="schedularType_id";
    property name="eventGenerator" fieldtype="one-to-one" cfc="eventGenerator" fkcolumn="eventGenerator_id";
    property name="lastRunDate" ormType="timestamp";
    property name="nextRunDate" ormType="timestamp";
    property name="startDate" ormtype="timestamp";
    property name="monthsOfYear" default="";
    property name="daysOfMonth" default="";
    property name="dayInterval" default="1";
    property name="status" default="0";

    public void function save(){
        getSchedularService().saveSchedular(this);
    }

    public void function setSchedularTypeID(required numeric schedularTypeId) {
        setSchedularType(getSchedularService().getSchedularTypeById(arguments.schedularTypeId));
    }

    public void function setStartDate(required string startDate) {
        if (len(arguments.startDate)){           
            variables.startDate = arguments.startDate;
        }
    }

    public void function setschedularStatus(required boolean schedularStatus) {
        setStatus(arguments.schedularStatus);
    }

    private component function getBeanFactory() {
        return request.beanfactory;
    }

    private component function getSchedularService() {
        return getBeanfactory().getBean("schedularService");
    }
    
}