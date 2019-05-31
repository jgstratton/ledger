component accessors="true"{

    property appid;
    property secret;
    property redirecturl;
    property redirectProxyUrl;
    
    public function init (appid, secret, redirecturl, redirectProxyUrl){
        variables.appid = arguments.appid;
        variables.secret = arguments.secret;
        variables.redirecturl = arguments.redirecturl;
        variables.redirectProxyUrl = arguments.redirectProxyUrl;
        return this;
    }

    public function getAccessToken(code){
        cfhttp(url="https://graph.facebook.com/oauth/access_token?client_id=#variables.appid#&redirect_uri=#getRedirectPath()#&client_secret=#variables.secret#&code=#arguments.code#");
        
        if(findNoCase("access_token", cfhttp.filecontent)){
            local.results =  deserializejson(cfhttp.filecontent);
            return local.results.access_token;
        }
    }

    public function getAuthURL(scope, state){
        return   "https://www.facebook.com/dialog/oauth?client_id=#variables.appid#&redirect_uri=#getRedirectPath()#&state=#arguments.state#&scope=#arguments.scope#";
    }

    public function getMe(accesstoken){
        cfhttp(url="https://graph.facebook.com/me?access_token=#arguments.accesstoken#&fields=id,name,email", result="local.httpResult");
        return deserializeJSON(httpResult.filecontent);
    }

    private string function getRedirectPath() {
        if (!session.keyExists('loginByProxy') || !session.loginByProxy) {
            return urlEncodedFormat(getRedirecturl());
        }
        return urlEncodedFormat(getRedirectProxyUrl());
    }

}
