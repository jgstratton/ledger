<!--- Determine if header should be visible on mobile devices or not based on current request--->
<cfset hideHeaderOnMobile = false>
<cfif request.section eq "transaction" or (request.section eq 'transfer' and request.item eq 'edit')>
    <cfset hideHeaderOnMobile = true>
</cfif>

<cfoutput>
    <header class="bg-dark #displayif(hideHeaderOnMobile,'mobile-hide')#">
        <div class="center-content">
            <nav class="navbar navbar-expand-md navbar-dark bg-dark">
                <div>
                    <button class="navbar-toggler collapsed" type="button" data-toggle="collapse" data-target="##navbar">
                        <i class="fa fa-bars"></i>
                    </button>
                    <span class="navbar-brand">
                        My checkbook
                    </span>
                </div>
                <div class="text-right flex-nowrap d-flex d-md-none text-secondary">
                    Summary - <span class="badge badge-primary text-nowrap">#moneyFormat(rc.user.getSummaryBalance())#</span>
                </div>
                <div class="navbar-collapse collapse" id="navbar">
                    <ul class="navbar-nav mr-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="#buildUrl('account.list')#">Accounts</a>
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
                <div class="text-right d-none d-md-inline text-secondary">
                    Checkbook Summary - <span class="badge badge-primary">#moneyFormat(rc.user.getSummaryBalance())#</span>
                </div>
            </nav>
            <!---
            <div class="title-bar">
                <hr>

                <cfif request.section eq "transaction" or (request.section eq 'transfer' and request.item eq 'edit')>
                    
                </cfif>

            </div>
        --->
        </div>

    </header>
</cfoutput>