<cfoutput>
	
	<div class="float-right">
		<div class="dropdown">
			<button type="button" class="btn btn-link dropdown-toggle" data-toggle="dropdown">
				More...
			</button>
			<div class="dropdown-menu dropdown-light">
				<div class="dropdown-item">
					<a title="Edit Account" href="#buildURL('account.edit?accountid=' & rc.account.getid())#" class="btn btn-link" data-close>
						<i class="fa fa-fw fa-gear" title="account settings"></i> Account Settings
					</a>
				</div>
				<div class="dropdown-item">
					<a href="#buildURL('reports.accountChart?accounts=' & rc.account.getid())#" class="btn btn-link" title="View Account Balance History">
						<i class="fa fa-fw fa-chart-line"></i> Balance Report
					</a>
				</div>
				<div class="dropdown-item">
					<a href="#buildURL('reports.spendingReport?accounts=' & rc.account.getid())#" class="btn btn-link" title="View Account Spending Report">
						<i class="fas fa-fw fa-file-contract"></i> Spending Report
					</a>
				</div>
				<div class="dropdown-item">
					<a href="#buildURL('reconciler.reconcile?accountId=' & rc.account.getid())#" class="btn btn-link" title="View Account Spending Report">
						<i class="fas fa-fw fa-clipboard-check"></i> Reconcile Account
					</a>
				</div>
			</div>
		</div>
	</div>

	
	<ul class="nav nav-tabs">
		<li class="nav-item">
			<a class="nav-link #matchDisplay(getItem(),'newTransaction','active disabled')#" href="#buildurl('transaction.newTransaction?accountid=#rc.account.getid()#')#">Add Entry</a>
		</li>
		<li class="nav-item">
			<a class="nav-link #matchDisplay(getItem(),'verify','active')#" href="#buildurl('transaction.verify?accountid=#rc.account.getid()#')#">Verify Entries</a>
		</li>
		<li class="nav-item">
		<span class="nav-link  #matchDisplay(getItem(),'edit','active','disabled')#">Edit Entry</span>
		</li>
	</ul> 

</cfoutput>