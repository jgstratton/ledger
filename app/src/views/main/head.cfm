<cfoutput>

    <title>My Checkbook</title>
            
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">                   
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/> 
    <meta property="og:url" content="#application.root_path#?action=#request.section#.#request.item#">
    <meta property="og:type" content="website">
    <meta property="og:title" content="My Checkbook"> 
    <meta property="og:image" content="#application.root_path#/images/credit-card-front-152-182038.png"> 
    <meta property="og:description" content="My Checkbook">
    <meta property="og:app_id" content="#application.facebook.getAppId()#">
    <link rel="manifest" href="#application.root_path#/assets/json/manifest.json">

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

</cfoutput>