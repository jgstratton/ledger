<cfoutput>
    
    <cfif Not Session.Loggedin>
        <p class="text-info">
            Welcome to your personal checkbook ledger. Login to start balancing your life...
        </p>
        <a class="btn btn-primary" href="?startfb=1"><i class="fa fa-facebook-square"></i> Login with Facebook</a>
    <cfelse>
        You are logged in:
        <a href="/logout">Log out</a>
    </cfif>

</cfoutput>