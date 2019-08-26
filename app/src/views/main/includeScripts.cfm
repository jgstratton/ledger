<cfoutput>

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
</cfoutput>