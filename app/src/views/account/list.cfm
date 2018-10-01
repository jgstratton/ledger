<cfoutput>
<div class="alert alert-success">
	<span class="badge badge-light summary">
		#moneyFormat(rc.summary)#
	</span>
	<span>- Accounts Summary</span>
	
</div>

<div class="container-fluid d-none d-md-block">
    <div class="row list-group-header">
        <div class="col-6">
            Account          
        </div>
        <div class="col-2 text-right ">
            Total
        </div>
        <div class="col-2 text-right">
            Verified
        </div>
        <div class="col-2"></div>
    </div>
</div>

<ul class="list-group">

    <cfloop array="#rc.mainAccounts#" item="thisAccount" index="i">
        
        <cfset local.editUrl = buildURL('account.edit?accountid=' & thisAccount.getId())>
        <cfset local.openUrl = buildURL('transaction.new?accountid=' & thisAccount.getId())>

        <cfset local.badgeClass = "info">
        <cfif thisAccount.inSummary()>
            <cfset local.badgeClass = "success">
        </cfif>

        <li class="list-group-item">

            <!--- Display for small devices --->
            <div class="d-block d-md-none clearfix">
                <a class="btn btn-link" href="#local.openUrl#">
                    <i class="fa fa-fw #thisAccount.getIcon()#"></i>
                    #thisAccount.getName()#
                </a>
                <div class="pull-right text-right">
                    <span class="badge badge-#local.badgeClass#">
                        $#thisAccount.getBalance()#
                    </span>
                    <br>
                    <span class="badge badge-light text-muted">
                        $#thisAccount.getVerifiedBalance()#
                    </span>
                </div>
            </div>

            <!--- Display for large devices --->
            <div class="container-fluid d-none d-md-block">
                <div class="row">
                    <div class="col-6">
                        <a class="btn btn-link" href="#local.openUrl#">
                            <i class="fa fa-fw #thisAccount.getIcon()#"></i>
                            #thisAccount.getname()#
                        </a>
                    </div>
                    <div class="col-2 text-right ">
                        <span class="badge badge-#local.badgeClass#">
                            #moneyFormat(thisAccount.getBalance())#
                        </span>
                    </div>
                    <div class="col-2 text-right">
                        #moneyFormat(thisAccount.getVerifiedBalance())#
                    </div>
                    <div class="col-2 text-right">
                        <a class="btn btn-link btn-sm" href="#local.editUrl#" >
                            <i class="fa fa-pencil"></i> edit
                        </a>
                    </div>
                </div>
            </div>

            <!--- List any sub accounts--->
            <cfif thisAccount.hasSubAccount()>
                
                <cfloop array="#thisAccount.getSubAccount()#" index="subAccount">

                    <cfset local.editUrl = buildURL('account.edit?accountid=' & subAccount.getId())>
                    <cfset local.openUrl = buildURL('transaction.new?accountid=' & subAccount.getId())>

                    <cfset local.badgeClass = "info">
                    <cfif subAccount.inSummary()>
                        <cfset local.badgeClass = "success">
                    </cfif>

                    <!--- Display for small devices --->
                    <div class="d-block d-md-none clearfix">
                        <hr class="sm">
                        <a class="btn btn-link" href="#local.openUrl#">
                            <span class="margin-l-20">&dash;</span>
                            #subAccount.getName()#
                        </a>
                        <div class="pull-right text-right">
                            <span class="badge badge-#local.badgeClass#">
                                $#subAccount.getBalance()#
                            </span>
                            <br>
                            <span class="badge badge-light text-muted">
                                $#subAccount.getVerifiedBalance()#
                            </span>
                        </div>
                    </div>

                    <!--- Display for large devices --->
                    <div class="container-fluid d-none d-md-block">
                        <div class="row">
                            <div class="col-6">
                                <a class="btn btn-link" href="#local.openUrl#">
                                    <span class="margin-l-20">&dash;</span>
                                    #subAccount.getname()#
                                </a>
                            </div>
                            <div class="col-2 text-right ">
                                <span class="badge badge-#local.badgeClass#">
                                    #moneyFormat(subAccount.getBalance())#
                                </span>
                            </div>
                            <div class="col-2 text-right">
                                #moneyFormat(subAccount.getVerifiedBalance())#
                            </div>
                            <div class="col-2 text-right">
                                <a class="btn btn-link btn-sm" href="#local.editUrl#" >
                                    <i class="fa fa-pencil"></i> edit
                                </a>
                            </div>
                        </div>
                    </div>
                </cfloop>

                <!--- Display account summary (only for accounts that have sub accounts) --->

                <!--- Display for small devices --->
                <div class="d-block d-md-none clearfix">
                    <hr class="sm">
                    <span class="text-muted margin-l-20">Account Balance</span>
                    <div class="pull-right text-right">
                        <span class="badge badge-info">
                            #moneyFormat(thisAccount.getLinkedBalance())#
                        </span>
                        <br>
                        <span class="badge badge-light text-muted">
                            #moneyFormat(thisAccount.getVerifiedLinkedBalance())#
                        </span>
                    </div>
                </div>

                <!--- Display for large devices --->
                <div class="container-fluid d-none d-md-block">
                    <hr class="sm">
                    <div class="row">
                        <div class="col-6">
                            <span class="text-muted margin-l-20">Account Balance</span>
                        </div>
                        <div class="col-2 text-right ">
                            <span class="badge badge-info">
                                #moneyFormat(thisAccount.getLinkedBalance())#
                            </span>
                        </div>
                        <div class="col-2 text-right">
                            #moneyFormat(thisAccount.getVerifiedLinkedBalance())#
                        </div>
                        <div class="col-2"></div>
                    </div>
                </div>
            </cfif>
        </li>
    </cfloop>

</ul>

<br>

<a href="#buildurl('account.create')#" class="btn btn-primary btn-sm pull-right d-none d-md-inline" ><i class="fa fa-plus"></i> Create New Account</a>

</cfoutput>