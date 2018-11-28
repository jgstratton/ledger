<cfoutput>
   
    
    <cfset local.alertService = getBeanFactory().getBean("alertService")>
    <cfset local.alerts = local.alertService.fetch()>

    <cfloop list="danger,warning,success" index="alertType">
        <cfset local.showMessageArray = true>
        <cfif local.alerts.keyExists(alertType)>
            <div class="alert alert-#alertType#">
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <cfif len(local.alerts[alertType].title) or arrayLen(local.alerts[alertType].messages) eq 1>
                    <div>
                        <i class="#local.alertService.getFontIcon(alertType)#"></i> 
                        <cfif len(local.alerts[alertType].title)>
                            #local.alerts[alertType].title#
                        <cfelseif arrayLen(local.alerts[alertType].messages) eq 1>
                            #local.alerts[alertType].messages[1]#
                            <cfset showMessageArray = false>
                        </cfif>
                    </div>
                </cfif>
                <cfif arrayLen(local.alerts[alertType].messages) and showMessageArray>
                    <ul>
                        <cfloop array="#local.alerts[alertType].messages#" item="message">
                            <li>#message#</li>
                        </cfloop>
                    </ul>
                </cfif>
            </div>
        </cfif>
    </cfloop>
    
</cfoutput>