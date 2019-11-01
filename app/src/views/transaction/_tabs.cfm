<cfoutput>
    
    <a title="Edit Account" href="#buildURL('account.edit?accountid=' & rc.account.getid())#" class="btn btn-outline-secondary btn-sm float-right d-none d-md-inline-block" data-close>
        <i class="fa fa-gear" title="account settings"></i>
    </a>
    <a href="#buildURL('reports.accountChart?accounts=' & rc.account.getid())#" class="btn btn-outline-secondary btn-sm float-right mr-1" title="View Account Balance History">
        <i class="fa fa-chart-line"></i>
    </a>
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


 