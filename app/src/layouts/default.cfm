<cfoutput>
<!DOCTYPE html>

<html>	
	<head>
        <title>My Checkbook</title>
        
        <cfinclude template="includes/meta.cfm">

        <link rel="icon" href=".assets/images/credit_card.png" /> 

        <!--- include styles from libraries --->
        <link rel="stylesheet" href="./assets/lib/font-awesome/css/all.css">
        <link rel="stylesheet" href="./assets/lib/font-awesome/css/v4-shims.css">
        <link rel="stylesheet" href="./assets/lib/jquery-ui-themes/smoothness.jquery-ui.min.css" />
        <link rel="stylesheet" href="./assets/lib/bootstrap/bootstrap.min.css" />
        <link rel="stylesheet" href="./assets/lib/multiple-select/multiple-select.min.css">
        <link rel="stylesheet" href="./assets/lib/datatables/css/jquery.dataTables.min.css">
        <link rel="stylesheet" href="./assets/lib/datatables/css/responsive.dataTables.min.css">
        <link rel="stylesheet" href="./assets/lib/daterangepicker/daterangepicker.css">
        <!--- include application styles --->
        <link rel="stylesheet" type="text/css" href="./assets/css/app.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="./assets/css/transactions.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="./assets/css/classes.css?v=#application.version#" />
       
        <script src="./assets/js/viewScripts.js?v=#application.version#"></script>
        

	</head>

	<body> 
        <header class="bg-dark">
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
                                <div class="dropdown-menu dropdown-dark">
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
    
                <div class="title-bar">
                    <hr>
 
                    <cfif request.section eq "transaction" or (request.section eq 'transfer' and request.item eq 'edit')>
                        #view('transaction/_header')#
                    </cfif>

                </div>
            </div>
    
        </header>
    
        <main>
            <div class="center-content">
                <div class="container-fluid inner-content">
                    <div class="sm-pad">
                        #body#
                    </div>
                </div>
            </div>
        </main>

        <!--- include js libraries / dependencies--->
        <script src="./assets/lib/jquery/jquery.min.js"></script>
        <script src="./assets/lib/popper/popper.min.js"></script>
        <script src="./assets/lib/bootstrap/bootstrap.min.js"></script>
        <script src="./assets/lib/jquery-ui/jquery-ui.min.js"></script>
        <script src="./assets/lib/jquery-validate/jquery.validate.min.js"></script>
        <script src="./assets/lib/jquery-validate/additional-methods.min.js"></script>
        <script src="./assets/lib/jquery-touch-events/jquery.mobile-events.min.js"></script>
        <script src="./assets/lib/multiple-select/multiple-select.min.js"></script>
        <script src="./assets/lib/datatables/js/jquery.dataTables.min.js"></script>
        <script src="./assets/lib/datatables/js/dataTables.responsive.min.js"></script>
        <script src="./assets/lib/moment/moment.min.js"></script>
        <script src="./assets/lib/moment/moment.min.js"></script>
        <script src="./assets/lib/chart/chart.min.js"></script>
        <script src="./assets/lib/daterangepicker/daterangepicker.js"></script>
        


        <script src="#application.root_path#/assets/js/app.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/dateUtil.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/chartUtil.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/routerUtil.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/formUtil.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/formatUtil.js?v=#application.version#"></script>

        <!--- add global js variables --->
        <script>
            var root_path = '#application.root_path#/';
            viewScripts.run();
        </script>	  
        
        <!--- Show the layout/view wrappers if dev toggle is on --->
        <cfif application.devToggles.showTemplateWrappers>
            <script src="#application.root_path#/assets/js/templateViewer.js?v=#application.version#"></script>
        </cfif>
	</body>
</html>

</cfoutput>






