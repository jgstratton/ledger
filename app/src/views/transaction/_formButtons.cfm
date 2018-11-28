<cfoutput>
    <!--- Required paramters for this view --->
    <cfparam name="local.type" default="">
    <cfparam name="local.mode" default="">
    
    <cfset local.submitText = "Submit Entry">
    <cfif type eq "transfer">
        <cfset local.submitText = "Submit Transfer">
    </cfif>
   
    <cfif local.mode eq "new">
        <div class="row">
            <div class="col-9 offset-3">
                <button type="submit" name="submitTransaction" class="btn btn-primary btn-sm">
                   Submit #( (local.type eq "transfer") ? "Transfer" : "Entry")#
                </button>
            </div>
        </div>
    <cfelse>
        <div class="row">
            <div class="col-9 offset-3">
                <button type="submit" name="submitTransaction" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> Save Changes</button>
                <a href="#buildurl(rc.returnTo & '?accountID=#rc.accountid#')#" class="btn btn  btn-outline-secondary btn-sm pull-right">
                    <i class="fa fa-times"></i> cancel changes
                </a>                
            </div>
        </div>
    </cfif>

    <script>
        viewScripts.add( function(){
            var $view = $("###local.templateID#");
        });
    </script>

</cfoutput>
