<cfoutput>
    <cfset local.viewID = "view" & randrange(1,10000000)>

    <div id="#local.viewId#">
        <div class="row nav-2">
            <div class="col text-left">
                <div class="dropdown">
                    <button type="button" class="btn btn-link  dropdown-toggle" data-toggle="dropdown">#rc.account.getLongName()#</button>
                    <div class="dropdown-menu bg-dark">
                        <cfloop from="1" to="#arraylen(rc.accounts)#" index="local.i">
                            <cfset local.account = rc.accounts[local.i]>
                            <button type="button" class="dropdown-item text-light" data-change-account="#local.account.getid()#" #matchDisplay(local.account.getid(),rc.account.getid(),'disabled')#>
                                #local.account.getLongName()#
                            </button>
                        </cfloop>
                    </div>
                </div>
            </div>
            
            <div class="col text-right">
                <div>
                    Account Total - 
                    <span class="badge badge-success" data-js-hook="accountBalance">
                        #dollarformat(rc.account.getBalance())#
                    </span>
                </div>
                <div>
                    Verified Total - 
                    <span class="badge badge-dark" data-js-hook="linkedBalanceVerified">
                        #dollarFormat(rc.account.getVerifiedLinkedBalance())#
                    </span>
                </div>
            </div>
        </div>
    </div>

    <script>
        viewScripts.add( function(){
            var viewId = '#local.viewId#',
                $view = $("##" + viewId),
                $accountBtn = $view.find("[data-change-account]");
            
                $accountBtn.click( function() {
                    var $btn = $(this),
                        accountid = $btn.data('changeAccount');
                    
                    post('#buildurl('transaction.new')#', {
                        accountid:accountid
                    });
                });
            
        });
    </script>
</cfoutput>