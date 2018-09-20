<cfoutput>
<div class="alert alert-success">
	<span class="badge badge-light summary">
		$#rc.summary#
	</span>
	<span>- Accounts Summary</span>
	
</div>

<div class="container-fluid d-none d-md-block">
    <div class="row list-group-header">
        <div class="col">
            Account          
        </div>
        <div class="col text-right ">
            Total
        </div>
        <div class="col text-right">
            Verified
        </div>
        <div class="col"></div>
    </div>
</div>

<ul class="list-group">

    <cfloop array="#rc.accounts#" item="thisAccount" index="i">
        
        <!--- Style accounts that are included in the summary --->
        <cfset local.editUrl = buildURL('account.edit?accountid=' & thisAccount.getId())>
        <cfset local.openUrl = buildURL('transactions.list?accountid=' & thisAccount.getId())>
        <cfset local.badgeClass = "info">

        <cfif thisAccount.inSummary()>
            <cfset local.badgeClass = "success">
        </cfif>

        <li class="list-group-item">

            <!--- Display for small devices --->
            <div class="d-block d-md-none">
                <a class="btn btn-link" href="#local.openUrl#">
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
                    <div class="col">
                        <a class="btn btn-link" href="#local.openUrl#">
                            #thisAccount.getname()#
                        </a>
                    </div>
                    <div class="col text-right ">
                        <span class="badge badge-#local.badgeClass#">
                            $#thisAccount.getBalance()#
                        </span>
                    </div>
                    <div class="col text-right">
                        $#thisAccount.getVerifiedBalance()#
                    </div>
                    <div class="col text-right">
                        <a class="btn btn-link btn-sm" href="#local.editUrl#" >
                            <i class="fa fa-pencil"></i> edit
                        </a>
                    </div>
                </div>
            </div>
            
        </li>
    </cfloop> 
</ul>

<br>

<a href="#buildurl('account.create')#" class="btn btn-primary btn-sm pull-right d-none d-md-inline" ><i class="fa fa-plus"></i> Create New Account</a>

<div class="clearfix"></div>

    <div class="container-fluid ">
    <div class="row list-group-header">
        <div class="col">
            Account Groups          
        </div>
        <div class="col text-right d-none d-md-block">
            Total
        </div>
        <div class="col text-right d-none d-md-block">
            Verified
        </div>
        <div class="col"></div>
    </div>
</div>

<ul class="list-group">
    <cfloop query="#rc.accountGroupsQuery#">
        <li class="list-group-item">
            <div class="d-block d-md-none">
                #name#
                <div class="pull-right text-right">
                    <span class="badge badge-secondary">
                        $#balance#
                    </span>
                    <br>
                    <span class="badge badge-light text-muted">
                        $#verifiedBalance#
                    </span>
                </div>
            </div>
            <div class="container-fluid d-none d-md-block">
                <div class="row">
                    <div class="col">
                        #name#
                    </div>
                    <div class="col text-right ">
                        $#balance#
                    </div>
                    <div class="col text-right">
                        $#verifiedBalance#
                    </div>
                    <div class="col"></div>
                </div>
            </div>
        </li>
    </cfloop>
</ul>
    
</cfoutput>