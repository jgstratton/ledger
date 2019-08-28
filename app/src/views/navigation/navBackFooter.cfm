<cfparam name="paramList" default="">

<cfoutput>
    <cfif rc.keyExists('returnTo')>

        <cfset local.queryString = {}>
        <cfloop list="#paramList#" index="param">
            <cfif rc.keyExists(param)>
                <cfset local.queryString[param] = rc[param]>
            </cfif>
        </cfloop>

        <div class="footer-bar">
            <a href="#buildurl(action: rc.returnto, queryString: local.queryString )#"><i class="fa fa-arrow-left"></i></a>
        </div>
    </cfif>
</cfoutput>
