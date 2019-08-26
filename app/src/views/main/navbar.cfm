<cfoutput>
    <div class="navbar-collapse collapse" id="navbar">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="#buildUrl('main.accountsList')#">Accounts</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#buildUrl('transfer.new')#">Transfer</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="#buildUrl('transactionSearch.search')#">Search</a>
            </li>
            <li class="nav-item dropdown">
                <a href="##" class="nav-link dropdown-toggle" data-toggle="dropdown">Other Features</a>
                <div class="dropdown-menu">
                    <a class="dropdown-item" href="#buildUrl('schedular.autoPaymentList')#">Automatic Payments</a>
                    <a class="dropdown-item" href="#buildUrl('user.checkbookRounding')#">Add Auto Rounding</a>
                    <a class="dropdown-item" href="#buildUrl('category.manageCategories')#">Manage Categories</a>
                    <a class="dropdown-item" href="TRN_300.php">Cost Breakdown</a>
                    <cfif getEnvironment() eq "Dev">
                        <a class="dropdown-item" href="#buildUrl('admin.devToggles')#">Dev toggles</a>
                    </cfif>
    
                </div>
            </li>
        
            <li class="nav-item">
                <a class="nav-link" href="#buildurl('auth.logout')#">Logout</a>
            </li>
        </ul>
    </div>
</cfoutput>
