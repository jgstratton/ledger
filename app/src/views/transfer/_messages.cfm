<cfoutput>

    <cfif StructKeyExists(rc,"errors") and ArrayLen(rc.errors) gt 0>
        <div class="alert alert-danger">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            <div class="">
                <i class="fa fa-exclamation-triangle"></i> Please correct the following errors and then try to save your transfer again.
            </div>
            <ul>
                <cfloop array="#rc.errors#" item="error">
                    <li>#error#</li>
                </cfloop>
            </ul>
        </div>
    </cfif>

    <cfif StructKeyExists(rc,"success")>
        <div class="alert alert-success">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            <div class="">
                <i class="fa fa-check"></i> #rc.success#
            </div>
        </div>
    </cfif>

</cfoutput>