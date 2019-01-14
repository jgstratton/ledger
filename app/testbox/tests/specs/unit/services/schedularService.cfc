component displayName="Schedular Service" extends="testbox.system.BaseSpec" {

    public void function setup(){
        variables.schedularService = createMock("services.schedular");
    }

    public void function schedularParameterValidForTypeTest(){
        var schedularType = createMock("beans.schedularType");
        schedularType.$("getAllowedParameters", "testParameter1,testParameter2");
        $assert.isTrue(schedularService.schedularParameterValidForType("testParameter1",schedularType));
        $assert.isTrue(schedularService.schedularParameterValidForType("testParameter2",schedularType));
        $assert.isFalse(schedularService.schedularParameterValidForType("testParameter3",schedularType));
    }

    public void function setNextRun_DateisNextMonth_Test(){ 
        var schedular = getDateSchedularMock();
        schedular.$('getMonthsOfYear','2,3,4');
        schedular.$('getDaysOfMonth','5,10,15');
        schedularService.$('getNextRunCompareDate','01/01/2020');
        schedular.setNextRunDate( schedularService.determineNextRunDate(schedular));
        $assert.isEqual('02/05/2020', schedular.getNextRunDate());
    }

    public void function setNextRun_DateisToday_Test(){     
        var schedular = getDateSchedularMock();
        schedular.$('getMonthsOfYear','1,2,3,4');
        schedular.$('getDaysOfMonth','1,5,10,15');
        schedularService.$('getNextRunCompareDate','01/01/2020');
        schedular.setNextRunDate( schedularService.determineNextRunDate(schedular));
        $assert.isEqual('01/01/2020', schedular.getNextRunDate());
    }

    public void function setNextRun_DateisNextYear_Test(){     
        var schedular = getDateSchedularMock();
        schedular.$('getMonthsOfYear','1');
        schedular.$('getDaysOfMonth','1');
        schedularService.$('getNextRunCompareDate','07/01/2020');
        schedular.setNextRunDate( schedularService.determineNextRunDate(schedular));
        $assert.isEqual('01/01/2021', schedular.getNextRunDate());
    }

    public void function setNextRun_Interval_Test(){
        var schedular = getIntervalSchedularMock();
        schedular.$('getStartDate','01/01/2020');
        schedular.$('getInterval', '14');
        schedularService.$('getNextRunCompareDate','02/01/2020');
        schedular.setNextRunDate( schedularService.determineNextRunDate(schedular));
        $assert.isEqual('02/12/2020', schedular.getNextRunDate());
    }

    public void function setNextRun_NewInterval_Test(){
        var schedular = getIntervalSchedularMock();
        schedular.$('getStartDate','01/01/2020');
        schedular.$('getInterval', '14');
        schedularService.$('getNextRunCompareDate','07/01/2019');
        schedular.setNextRunDate( schedularService.determineNextRunDate(schedular));
        $assert.isEqual('01/15/2020', schedular.getNextRunDate());
    }


    public void function runSchedular_LastRunDateGetsSet_Test() {
        var schedular = createMock("beans.schedular");
        schedularService.$('determineNextRunDate',now());
        schedularService.runSchedular(schedular);
        $assert.isEqual(0, Datecompare(now(),schedular.getLastRunDate(),'d'));
    }

    public void function runSchedular_NextRunDateGetsSet_Test() {
        var schedular = getIntervalSchedularMock();
        schedular.$('getStartDate',now());
        schedular.$('getInterval', '1');
        schedularService.runSchedular(schedular);
        $assert.notNull(schedular.getNextRunDate());
    }

/** Private helper methods for tests **/

    private component function getDateSchedularMock(){
        var schedular = createMock("beans.schedular");
        var schedularType = createMock("beans.schedularType");
        schedular.$('getSchedularType',schedularType, false);
        schedularType.$('getName','Date');
        return schedular;
    }

    private component function getIntervalSchedularMock() {
        var schedular = createMock("beans.schedular");
        var schedularType = createMock("beans.schedularType");
        schedular.$('getSchedularType',schedularType, false);
        schedularType.$('getName','Interval');
        return schedular;
    }

}