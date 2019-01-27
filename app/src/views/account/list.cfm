<cfoutput>
    <div class="alert alert-success">
        <span class="badge badge-light summary">
            #moneyFormat(rc.summary)#
        </span>
        <span>- Accounts Summary</span>
        
    </div>

    <div class="row">
        
        <cfloop array="#rc.mainAccounts#" item="thisAccount" index="i">
            
            <cfset local.editUrl = buildURL('account.edit?accountid=' & thisAccount.getId())>
            <cfset local.openUrl = buildURL('transaction.newTransaction?accountid=' & thisAccount.getId())>

            <cfset local.badgeClass = "">
            <cfif thisAccount.inSummary()>
                <cfset local.badgeClass = "success">
            </cfif>

        
            <div class="col-lg-6 mb-3">

                <div class="card">
                    <div class="card-header h6">
                        <i class="fa fa-fw #thisAccount.getIcon()#"></i>
                        #thisAccount.getname()#
                        <div class="pull-right text-right">
                            <h4>#moneyFormat(thisAccount.getLinkedBalance())#</h4>
                        </div> 
                    </div>
                    <div class="card-body">
                        
                        <!--- Display for large devices --->

                        <div class="row">
                            <div class="col-9">
                                <a class="btn btn-link" href="#local.openUrl#">
                                    #thisAccount.getname()#
                                </a>
                            </div>
                            <div class="col-3 text-right ">
                                <span class="badge badge-#local.badgeClass#">
                                    #moneyFormat(thisAccount.getBalance())#
                                </span>
                            </div>

                            <!---
                                <div class="col-2 text-right">
                                    <a class="btn btn-link btn-sm" href="#local.editUrl#" >
                                        <i class="fa fa-pencil"></i> edit
                                    </a>
                                </div>
                            --->
                        </div>
                        
                        <!--- List any sub accounts--->
                        <cfif thisAccount.hasSubAccount()>
                            
                            <cfloop array="#thisAccount.getSubAccounts()#" index="subAccount">

                                <cfset local.editUrl = buildURL('account.edit?accountid=' & subAccount.getId())>
                                <cfset local.openUrl = buildURL('transaction.newTransaction?accountid=' & subAccount.getId())>

                                <cfset local.badgeClass = "">
                                <cfif subAccount.inSummary()>
                                    <cfset local.badgeClass = "success">
                                </cfif>

                                <!--- Display for large devices --->
                                <div class="row">
                                    <div class="col-9">
                                        <a class="btn btn-link" href="#local.openUrl#">
                                            #subAccount.getname()#
                                        </a>
                                    </div>
                                    <div class="col-3 text-right ">
                                        <span class="badge badge-#local.badgeClass#">
                                            #moneyFormat(subAccount.getBalance())#
                                        </span>
                                    </div>
                                    <!---
                                        <div class="col-2 text-right">
                                            <a class="btn btn-link btn-sm" href="#local.editUrl#" >
                                                <i class="fa fa-pencil"></i> edit
                                            </a>
                                        </div>
                                    --->
                                </div>

                            </cfloop>
                        </cfif>

                        <hr>
                        <div class="text-muted font-weight-light">
                            Verified account total: 
                            <span class="pull-right">#moneyFormat(thisAccount.getVerifiedLinkedBalance())#</span>
                        </div>
                    </div>
                </div>
            </div>  

        </cfloop>
    </div>

    <a href="#buildurl('account.create')#" class="btn btn-primary btn-sm pull-right d-md-inline" ><i class="fa fa-plus"></i> Create New Account</a>

</cfoutput>