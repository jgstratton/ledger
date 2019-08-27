<cfparam name="local.activeSection" default="">

<cfoutput>
    <div class="center-content">
    <nav class="navbar navbar-dark bg-dark">
        <div class="navbar-collapse collapse" id="navbar">
            <ul class="navbar-nav mr-auto">
                <cfif local.activeSection eq "account">
                    <cfset local.accountOptions = [{
                            action: 'transaction.transactionList',
                            label: 'Transaction History',
                            icon: 'fa fa-list'
                        },{
                            action: 'transaction.newTransaction',
                            label: 'New Transaction',
                            icon: 'fa fa-plus'
                        },{
                            action: 'transaction.verify',
                            label: 'Verify Transactions',
                            icon: 'fa fa-check-circle-o'
                        },{
                            action: 'accountChart.view',
                            label: 'View Account Balance History',
                            icon: 'fa fa-chart-line'
                        },{
                            action: 'account.edit',
                            label: 'Edit Account',
                            icon: 'fa fa-gear'
                        },
                    ]>
                    <li class="nav-item">
                        Account Options
                        <div class="nav-section">                        
                            <ul class="navbar-nav mr-auto">
                                <cfset local.currentAction = "#request.section#.#request.item#">
                                <cfloop array="#local.accountOptions#" index="accountOption">
                                    <li class="nav-item">
                                        <cfif accountOption.action neq local.currentAction>
                                            <a class="nav-link" href="#buildUrl(action: accountOption.action, queryString: {
                                                accountid: rc.accountid,
                                                returnTo: local.currentAction
                                            })#">
                                                <i class="#accountOption.icon#"></i>
                                                #accountOption.label#
                                            </a>
                                        <cfelse>
                                            <span class="nav-link active">
                                                <i class="#accountOption.icon#"></i>
                                                #accountOption.label#
                                            </span>
                                        </cfif>  
                                    </li>
                                </cfloop>
                            </ul>
                        </div>
                    </li>
                    <li class="nav-divider"></li>
                </cfif>
                <li class="nav-item">
                    <a class="nav-link" href="#buildUrl('main.accountsList')#">
                        <i class="fa fa-fw fa-university"></i> Accounts List
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#buildUrl('transfer.new')#">
                        <i class="fa fa-fw fa-exchange"></i> Transfer Funds
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#buildUrl('transactionSearch.search')#">
                        <i class="fa fa-fw fa-search"></i> Search Transactions
                    </a>
                </li>
                <li class="nav-divider"></li>
               
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
                    <a class="nav-link" href="#buildurl('auth.logout')#">
                        <i class="fa fa-sign-out"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </nav>
</div>
    <script>
        viewScripts.add( function(){
            var $navbar = $("##navbar");

            $(document).click(function (event) {
                var clickover = $(event.target);             
                var _opened = $navbar.hasClass("show");
                if (_opened === true && clickover.closest('.navbar').length == 0) {      
                    $navbar.collapse('hide');
                }
            });
        });

    </script>
</cfoutput>
