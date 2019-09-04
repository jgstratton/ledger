<cfset DisableLayout()>
<cfoutput>
    <!DOCTYPE html>
    <html>	
        <head>
            #view('main/head')#
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
        <footer></footer>
            <!--- Scripts needed for bootstrap 4 --->
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
                
        </body>
    </html>
</cfoutput>






