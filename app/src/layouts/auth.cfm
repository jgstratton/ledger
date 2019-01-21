<cfset DisableLayout()>
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
	</head>

	<body> 
        <header class="bg-dark">
            <div class="center-content">

                <nav class="navbar navbar-expand-md navbar-dark bg-dark">
                    <div>
                        <button class="navbar-toggler collapsed" type="button" data-toggle="collapse" data-target="#navbar">
                            <i class="fa fa-bars"></i>
                        </button>
                        <span class="navbar-brand">
                            My checkbook
                        </span>
                    </div>
                </nav>
    
                <div class="title-bar">
                <hr>
        </div>
    </div>
    
    </header>
    
    <main>
    <div class="center-content">
    
        <div class="container-fluid inner-content">
            <cfoutput>#body#</cfoutput>
        </div> 
    </div>

    </main>

        <!--- Scripts needed for bootstrap 4 --->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
            
	</body>
</html>






