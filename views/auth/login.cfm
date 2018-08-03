<cfoutput>
    
    <cfif not isDefined("session.fbaccesstoken")>
        Not logged in:
        <a href="?startfb=1">Login with FB</a>
    <cfelse>
        You are logged in:
        <cfdump var="#application.facebook.getMe(session.fbaccesstoken)#" label="me" expand="true">
        <a href="/auth/logout">Log out</a>
    </cfif>

</cfoutput>