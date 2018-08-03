component{

    public function init (appid, secret, redirecturl){
        variables.appid = arguments.appid;
        variables.secret = arguments.secret;
        variables.redirecturl = arguments.redirecturl;
        return this;
    }

    public function getAccessToken(code){
        cfhttp(url="https://graph.facebook.com/oauth/access_token?client_id=#variables.appid#&redirect_uri=#urlEncodedFormat(variables.redirecturl)#&client_secret=#variables.secret#&code=#arguments.code#");
        
        if(findNoCase("access_token", cfhttp.filecontent)){
            local.results =  deserializejson(cfhttp.filecontent);
            return local.results.access_token;
        }
    }

    public function getAuthURL(scope, state){
        return   "https://www.facebook.com/dialog/oauth?client_id=#variables.appid#&redirect_uri=#urlEncodedFormat(variables.redirecturl)#&state=#arguments.state#&scope=#arguments.scope#";
    }

    public function getMe(accesstoken){
        cfhttp(url="https://graph.facebook.com/me?access_token=#arguments.accesstoken#", result="local.httpResult");
        return deserializeJSON(httpResult.filecontent);
    }

}
