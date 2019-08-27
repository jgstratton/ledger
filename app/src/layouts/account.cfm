<cfset DisableLayout()>
<cfoutput>
    <!DOCTYPE html>

    <html>	
        <head>
            #view('main/head')#
        </head>

        <body> 
            <header>
                #view('account/_header')#
                #view('main/navbar')#
            </header>
        
            <main>
                <div class="center-content">
                    <div class="container-fluid inner-content">
                        <div class="px-2">
                            #body#
                        </div>
                    </div>
                </div>
            </main>
            #view('main/includeScripts')#
        </body>
    </html>

</cfoutput>

