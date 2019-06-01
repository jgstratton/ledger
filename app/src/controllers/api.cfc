component name="account" output="false"  accessors=true {
    property logger;
    
    public void function init(fw){
        variables.fw=arguments.fw;
        variables.apiControllers = {};
    }

    public void function before( required struct rc ){
        var start = getTickCount();
        var apiName = fw.getItem();

        rc.response = new beans.response();
        rc.response.executionTime = start

        try {
            var apiObj = getApi(apiName).obj;
            var apiStruct = translateRc(rc);

            //run any middleware defined.  If middleware returns false, exit immediately.
            for (var mw in getMiddleware(apiName,apiStruct.method)) {
                logger.debug("API Middleware -  #apiName#.#mw#");
                var continueExecution = invoke(apiObj, mw, {rc: rc, api: apiStruct});
                if (!continueExecution) {
                    return;
                }
            }
            
            logger.debug("API Request - #apiName#.#apiStruct.method#");

            invoke(apiObj, apiStruct.method, {rc: rc, api: apiStruct});
        } catch (any e) {
            rc.response.addError(e.message);
            rc.response.setStatusCode(500);
            logger.error(e);
        }
    }

    public void function after( struct rc = {} ){
        rc.response.executionTime = numberformat((getTickCount() - rc.response.executionTime),"0") & "ms";
        variables.fw.renderData( 'json', rc.response ).statusCode( rc.response.getStatusCode() );
    }

    private struct function getApi(required string apiName){
        if (!variables.apiControllers.keyExists(apiName)) {
            variables.apiControllers[apiName] = {}
            var apiRef = variables.apiControllers[apiName];
            getLogger().debug("Api Controller: api.#apiName#");
            apiRef.obj = new "api.#apiName#"(variables.fw); 

            // get the defined middleware from the annotations
            var meta = getComponentMetadata("api.#apiName#");
            apiRef.functions = {};
            for (var fnc in meta.functions){
                apiRef.functions[fnc.name] = {middleware: fnc.keyExists("middleware") ? listToArray(fnc.middleWare) : [] };
            }
        }
        return variables.apiControllers[apiName];
    }


    private array function getMiddleWare(required string apiName, required string functionName) {
        var api = getApi(apiName);
        return api.functions[functionName].middleware;
    }

    /**
     * expecting routes in the form of /api/section/item/data
     * 
     * examples:   
     *      GET: /api/section/item   -  section.getItem
     *      GET: /api/sections       -  section.getSections
     *      POST: /api/section/item  -  section.postItem    
     * 
     * @returns apiMethod
     */
    private struct function translateRc(required struct rc) {
        
        var pathArray = listToArray(cgi.PATH_INFO, "/\");
        rc.apiData = [];
        var api = {
            section: pathArray[2],
            item: pathArray.len() > 2 ? pathArray[3] : pathArray[2]
        };
        api.type = lcase(cgi.request_method);
        api.method = api.type & api.item;

        if (rc.keyExists(api.item)) {
            StructDelete(rc, api.item);
        }
        for (var i = 4; i <= pathArray.len(); i++) {
            rc.apiData.append(pathArray[i]);
            if(rc.keyExists(pathArray[i])){
                StructDelete(rc,pathArray[i]);
            }
        }
        return api;
    }

}