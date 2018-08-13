<cfoutput>
    <cfif ArrayLen(rc.errors) gt 0>
        <div class="alert alert-danger">
            <div class="">
                <i class="fa fa-exclamation-triangle"></i> #rc.errorMsg#
            </div>
            <ul>
                <cfloop array="#rc.errors#" item="error">
                    <li>#error#</li>
                </cfloop>
            </ul>
        </div>
    </cfif>
</cfoutput>