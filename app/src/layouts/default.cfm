<cfoutput>
<!DOCTYPE html>

<html>	
	<head>
        <title>Checkbook FW1</title>
        
        <meta http-equiv="X-UA-Compatible" content="IE=Edge">                   
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/> 

        <link rel="shortcut icon" href="images/credit-card-front-152-182038.png" /> 

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css" />

        <link 
            rel="stylesheet" 
            href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" 
            integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" 
            crossorigin="anonymous">


        <link rel="stylesheet" type="text/css" href="#application.root_path#/assets/css/app.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="#application.root_path#/assets/css/transactions.css?v=#application.version#" />
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
                        Summary - <span class="badge badge-primary text-nowrap"></span>
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
                                <a class="dropdown-item" href="TRN_300.php">Cost Breakdown</a>
                                <a class="dropdown-item" href="TRN_500.php">Manage Categories</a>
                                <a class="dropdown-item" href="TRN_700.php">Manage Bills</a>
                                </div>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="logout">Logout</a>
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
                    #body#
                </div>
            </div>
        </main>

        <!--- Scripts needed for bootstrap 4 --->
        <script
            src="https://code.jquery.com/jquery-3.2.1.min.js"
            integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
            crossorigin="anonymous"></script>

        <script 
            src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" 
            integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" 
            crossorigin="anonymous"></script>

        <script 
            src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" 
            integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" 
            crossorigin="anonymous"></script>
        
        <!--- Scripts for UI and validate--->
        <script
            src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
            integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
            crossorigin="anonymous"></script>

        <script 
            src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.js" 
            integrity="sha256-yazfaIh2SXu8rPenyD2f36pKgrkv5XT+DQCDpZ/eDao=" 
            crossorigin="anonymous"></script>
        
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-touch-events/1.0.5/jquery.mobile-events.js"></script>
        <script src="#application.root_path#/assets/js/app.js?v=#application.version#"></script>

        <!--- add global js variables --->
        <script>
            var root_path = '#application.root_path#/';
            viewScripts.run();
        </script>	  
			
	</body>
</html>

</cfoutput>






