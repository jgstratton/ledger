<cfoutput>
<!DOCTYPE html>

<html>	
	<head>
        <title>My Checkbook</title>
        
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">                   
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/> 

        <link rel="icon" href="#application.root_path#/assets/images/credit_card.png" /> 

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css" />

        <link 
            rel="stylesheet" 
            href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" 
            integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" 
            crossorigin="anonymous">

        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.2/multiple-select.min.css">

        <link rel="stylesheet" type="text/css" href="#application.root_path#/assets/css/app.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="#application.root_path#/assets/css/transactions.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="#application.root_path#/assets/css/classes.css?v=#application.version#" />
       
        <script src="#application.root_path#/assets/js/viewScripts.js?v=#application.version#"></script>
        

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
                                <a class="nav-link" href="TRN_250.php">Search</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" data-toggle="dropdown">Other Features</a>
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

        <!--- Scripts needed for bootstrap 4 --->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>

        
        <!--- Scripts for UI and validate--->
        <script
            src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
            integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
            crossorigin="anonymous"></script>

        <script 
            src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.js" 
            integrity="sha256-yazfaIh2SXu8rPenyD2f36pKgrkv5XT+DQCDpZ/eDao=" 
            crossorigin="anonymous"></script>

        <script 
            src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/additional-methods.min.js" 
            integrity="sha256-0Yg/eibVdKyxkuVo1Qwh0DspoUCHvSbm/oOoYVz32BQ=" 
            crossorigin="anonymous"></script>

        <script 
            src="https://cdnjs.cloudflare.com/ajax/libs/jquery-touch-events/1.0.5/jquery.mobile-events.js" 
            integrity="sha384-PH9iS/KgZGPhP/z3Er7jDrTMgCNk3wS+MMT/u4fBbhryGQJPwDvbltI6Z2LECqCQ" 
            crossorigin="anonymous"></script>
            
        <script 
            src="https://cdnjs.cloudflare.com/ajax/libs/multiple-select/1.2.2/multiple-select.min.js" 
            integrity="sha384-0oWzNuQzyCYxinHFCTnivO8O/5tM8VHyCy/wzssUzMM8dJzW41ZlnP4ud+hX2FYJ" 
            crossorigin="anonymous"></script>

        <script src="#application.root_path#/assets/js/app.js?v=#application.version#"></script>

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






