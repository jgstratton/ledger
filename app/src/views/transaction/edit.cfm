<cfoutput>

    #view("transaction/_tabs")#
    <cfif rc.transaction.isTransfer()>
        #view("transaction/_transferForm")# 
    <cfelse>
        #view("transaction/_transactionForm")#   
    </cfif>
    
</cfoutput>