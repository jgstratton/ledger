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
        <link rel="stylesheet" href="./assets/lib/datatables/jquery.dataTables.min.css">
        <link rel="stylesheet" href="./assets/lib/datatables/responsive.dataTables.min.css">
        <link rel="stylesheet" href="./assets/lib/daterangepicker/daterangepicker.css">
        <!--- include application styles --->
        <link rel="stylesheet" type="text/css" href="./assets/css/app.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="./assets/css/mobile.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="./assets/css/transactions.css?v=#application.version#" />
        <link rel="stylesheet" type="text/css" href="./assets/css/classes.css?v=#application.version#" />
       
        <script src="./assets/js/viewScripts.js?v=#application.version#"></script>
        

	</head>

	<body> 
        #view('main/header')#
    
        <main>
            <div class="center-content">
                <div class="container-fluid inner-content">
                    <div class="px-2">
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
        <script src="./assets/lib/datatables/jquery.dataTables.min.js"></script>
        <script src="./assets/lib/datatables/dataTables.responsive.min.js"></script>
        <script src="./assets/lib/moment/moment.min.js"></script>
        <script src="./assets/lib/moment/moment.min.js"></script>
        <script src="./assets/lib/chart/chart.min.js"></script>
        <script src="./assets/lib/daterangepicker/daterangepicker.js"></script>
        


        <script src="#application.root_path#/assets/js/app.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/dateUtil.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/chartUtil.js?v=#application.version#"></script>
        <script src="#application.root_path#/assets/js/routerUtil.js?v=#application.version#"></script>

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






