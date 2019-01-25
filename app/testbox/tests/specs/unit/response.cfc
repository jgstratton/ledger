component displayName="Reponse Test" extends="resources.BaseSpec" {

    public void function repsponseAppenderTest(){
        var response1 = new beans.response();
        var response2 = new beans.response();
        response1.addError("Error 1");
        response2.addError("Error 2");
        response1.appendResponseErrors(response2);
        $assert.includes(response1.getErrors(), "Error 2");
    }
}