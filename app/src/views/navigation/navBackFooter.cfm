<cfparam name="paramList" default="">

<cfoutput>
    <cfif rc.keyExists('returnTo')>

        <cfset local.queryString = {}>
        <cfloop list="#paramList#" index="param">
            <cfif rc.keyExists(param)>
                <cfset local.queryString[param] = rc[param]>
            </cfif>
        </cfloop>

        <script type="text/html" data-footer-content>
            <div class="footer-bar">
                <div class="center-content">
                    <a href="#buildurl(action: rc.returnto, queryString: local.queryString )#"><i class="fa fa-arrow-left"></i></a>
                </div>
            </div>
        </script>
        <script>
            viewScripts.add(function(){
                var $view = $('###local.templateID#');
                var $footerContent = $view.find("[data-footer-content]");
                $("footer").append($footerContent.html());
            });
        </script>
    </cfif>
</cfoutput>
