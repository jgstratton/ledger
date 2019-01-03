<cfoutput>
    <div class="sm-pad">
                

        #view("includes/alerts")#
        <h3>
            <i class="fa fa-exchange"></i> Auto Rounding / Savings 
            <cfif not rc.roundingAccount>
                <span class="small text-danger">(disabled)</span>
            </cfif>
        </h3>
        <p class="text-info">
            The auto-rounding features allows you to automatically save money as you spend.  Each time you make 
            a transaction in an account that is included in your checkbook summary, a transaction will be made from the parent account to the
            sub-account you designate.  This will keep your checkbook summary rounded to a nice even number, while automatically putting
            money aside for you.
        </p>

        <form name="frmCheckbookRounding" method="post" action="#buildurl('user.updateAutoRounding')#">
            <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <label class="col-4 col-form-label">Send money to:</label>
                        <div class="col-8">
                            <select name="roundingAccount" class="form-control form-control-sm" >
                                <cfloop array="#rc.accounts#" index="local.account">
                                    <option value="#local.account.getId()#" #selectIf(local.account.getId() eq rc.roundingAccount)#>
                                        #local.account.getName()#
                                    </option>
                                </cfloop>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <label class="col-4 col-form-label">How to round:</label>
                        <div class="col-8">
                            <select name="roundingModular" class="form-control form-control-sm">
                                <cfloop array="#rc.roundingModularOptions#" index="local.modularOption">
                                    <option value="#local.modularOption.roundingModular#" #selectIf(local.modularOption.roundingModular eq rc.roundingModular)#>
                                        #local.modularOption.description#
                                    </option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4"></div>
                        <div class="col-8">
                            <button class="btn btn-sm btn-primary">
                                <i class="fa fa-floppy-o"></i> 
                                <cfif rc.roundingAccount>
                                    Save
                                <cfelse>
                                    Enable
                                </cfif>
                            </button>
                            <cfif rc.roundingAccount>
                                <button type="button" class="btn btn-sm btn-outline-secondary pull-right" data-disable-btn>
                                    <i class="fa fa-times"></i> Disable
                                </button>
                            </cfif>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        viewScripts.add(function(){
            var $view = $("###local.templateid#"),
                $form = $view.find("form");


            $view.find("[data-disable-btn]").click(function(){
                jConfirm("Are you sure you want to disable the auto-rounding feature?",function(){
                    post('#buildurl('user.disableAutoRounding')#',{disableRounding:true});
                });
            });
            
        });
    </script>

</cfoutput>