component displayName="Schedular Service" extends="testbox.system.BaseSpec" {

    public void function schedularParameterValidForTypeTest(){
        var schedularService = new services.schedular();
        var schedularType = createMock("beans.schedularType");
        schedularType.$("getAllowedParameters", "testParameter1,testParameter2");
        $assert.isTrue(schedularService.schedularParameterValidForType("testParameter1",schedularType));
        $assert.isTrue(schedularService.schedularParameterValidForType("testParameter2",schedularType));
        $assert.isFalse(schedularService.schedularParameterValidForType("testParameter3",schedularType));
    }
}