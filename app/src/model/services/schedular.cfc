component accessors="true" {
	property name="hoursBetweenScheduleRuns" default="6";
	property eventGeneratorService;
	property userService;

	public component function createSchedular(){
		var Schedular = EntityNew("schedular");
		schedular.setSchedularType(EntityLoad("schedularType",{name:"Date"},true));
		return schedular;
	}

	public void function runSchedule(){
		if (getHoursSinceLastScheduleRun() >= getHoursBetweenScheduleRuns() ){
			var readySchedulars = getReadySchedulars();
			for (schedular in readySchedulars) {
				runSchedular(schedular);
			}
			session.lastScheduleRun = now();
		}
	}

	public array function getReadySchedulars(){
		return ormExecuteQuery("
			Select s
			From schedular s
			join s.eventGenerator g
			Where g.user = :user
				and nextRunDate <= now()
				and status = 1
				and g.deleted = 0",{
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
		transaction {
			if (schedular.hasEventGenerator()) {
				eventGeneratorService.runEventGenerator(schedular.getEventGenerator());
			}
			schedular.setLastRunDate(now());
			schedular.setNextRunDate( determineNextRunDate(arguments.schedular) );
		}
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
					var currentDate = getValidDateThisMonth(year, month, day);
					if (DateCompare(currentDate, compareDate, "d") >= 0) {
						var currentDate = createDate(year, month, day);
						if (!schedularRanThisDay(arguments.schedular, currentDate) ) {
							return currentDate;
						}
					}
				}
			}
		}
		abort;
		throw("Unable to determine next run date #schedular.getId()#");
	}

	//returns the closest valid date for the values/month given
	private date function getValidDateThisMonth(required numeric year, required numeric month, required numeric day) {
		var checkDay = arguments.day;
		if (checkDay <= 28) {
			return createDate(year, month, day);
		}
		while(checkDay >= 28) {
			try {
				return createDate(year,month,checkDay);
			} catch (any e) {
				checkDay -= 1;
			}
		}
		throw("Unable to deterime a valid run date #schedular.getId()#");
	}

	private date function determineNextRunDateByInterval(required component schedular) {
		var compareDate = getNextRunCompareDate();
		var currentDate = arguments.schedular.getStartDate();
		while (DateCompare(compareDate, currentDate, "d") > 0 && !schedularRanThisDay(arguments.schedular, currentDate)) {
			currentDate = DateAdd('d', arguments.schedular.getDayInterval(), currentDate);
		}
		return currentDate;
	}

	private boolean function schedularRanThisDay(required component schedular, required date checkDate) {
		if (!IsNull(arguments.schedular.getLastRunDate()) && Datecompare(arguments.checkDate, arguments.schedular.getLastRunDate(),'d') == 0) {
			return true;
		}
		return false;
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