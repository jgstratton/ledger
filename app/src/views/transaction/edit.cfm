<cfoutput>

    #view("transaction/_tabs")#
    <cfif rc.transaction.isTransfer()>
        #view("transfer/_form")# 
    <cfelse>
        #view("transaction/_form")#   
    </cfif>
    
</cfoutput>