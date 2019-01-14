component accessors="true" {
    property name="hoursBetweenScheduleRuns" default="0";
    property eventGeneratorService;
    property userService;

    public component function createSchedular(){
        var Schedular = EntityNew("schedular");
        schedular.setSchedularType(EntityLoad("schedularType",{name:"Date"},true));
        return schedular;
    }

    public void function runSchedule(){
        transaction {
            if (getHoursSinceLastScheduleRun() >= getHoursBetweenScheduleRuns() ){
                var readySchedulars = getReadySchedulars();
                for (schedular in readySchedulars) {
                    runSchedular(schedular);
                }
                session.lastScheduleRun = now();
            }
        }
    }

    public array function getReadySchedulars(){
        return ormExecuteQuery("
            Select s
            From schedular s
            join s.eventGenerator g
            Where g.user = :user
                and nextRunDate <= now()",{
            user: userService.getCurrentUser()
        });
    }

    public array function getSchedularTypes(){
        return entityLoad("schedularType");
    }

    public component function getSchedularTypeById(required numeric typeId) {
        return entityLoadByPK("schedularType",arguments.typeId);
    }

    public void function saveSchedular(required component schedular) {
        EntitySave(schedular);
    }

    public boolean function schedularParameterValidForType(required string parameterName, required component schedularType) {
        return (listFindNocase(arguments.schedularType.getAllowedParameters(), arguments.parameterName));
    }

    public void function runSchedular(required component schedular) {
        if (schedular.hasEventGenerator()) {
            eventGeneratorService.runEventGenerator(schedular.getEventGenerator());
        }
        schedular.setLastRunDate(now());
        schedular.setNextRunDate( determineNextRunDate(arguments.schedular) );
    }

    public date function determineNextRunDate(required component schedular) {
        var schedularTypeName = arguments.schedular.getSchedularType().getName();
        switch (schedularTypeName) {
            case "date":
                return determineNextRunDateByDate(arguments.schedular);
                break;
            case "interval":
                return determineNextRunDateByInterval(arguments.schedular);
                break;
            default:
                throw('schedular type "#schedularTypeName#" is not supported');
        }
    }

/** Private functions **/

    private date function determineNextRunDateByDate(required component schedular) {
        var compareDate = getNextRunCompareDate();
        for (var year in [year(compareDate), year(compareDate) + 1]) {
            for (var month in arguments.schedular.getMonthsOfYear()) {
                for (var day in arguments.schedular.getDaysOfMonth()) {
                    var currentDate = createDate(year, month, day)
                    if (DateCompare(currentDate, compareDate, "d") >= 0) {
                        if (!schedularRanThisDay(arguments.schedular, currentDate) ) {
                            return currentDate;
                        }
                    }
                }
            }
        }
        throw("Unable to determin next run date");
    }

    private date function determineNextRunDateByInterval(required component schedular) {
        var compareDate = getNextRunCompareDate();
        var currentDate = arguments.schedular.getStartDate();
        while (compareDate > currentDate && !schedularRanThisDay(arguments.schedular, currentDate)) {
            currentDate = DateAdd('d', arguments.schedular.getInterval(), currentDate);
        }
        return currentDate;
    }

    private boolean function schedularRanThisDay(required component schedular, required date checkDate) {
        if (IsNull(arguments.schedular.getLastRunDate())) {
            return false;
        }
        return Datecompare(arguments.checkDate, arguments.schedular.getLastRunDate(),'d');
    }

    private date function getNextRunCompareDate() {
        return now();
    }

    private numeric function getHoursSinceLastScheduleRun() {
        if (!structKeyExists(session,"lastScheduleRun") || !isValid('date',session.lastScheduleRun)) {
            return 1000;
        }
        return dateDiff('d', session.lastScheduleRun, now());
    }

}