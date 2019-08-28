<cfoutput>

    <cfif rc.transaction.isTransfer()>
        #view("transaction/_transferForm")# 
    <cfelse>
        #view("transaction/_transactionForm")#   
    </cfif>
    #view("navigation/navBackFooter", {
        paramList: 'accountid'
    })#
</cfoutput>