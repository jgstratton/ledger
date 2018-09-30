<cfoutput>
    <div class="row nav-2">
        <div class="col text-left">
        <div class="dropdown">
            <button type="button" class="btn btn-link  dropdown-toggle" data-toggle="dropdown">#rc.account.getName()#</button>
            <div class="dropdown-menu bg-dark">
                <cfloop array="#rc.accounts#" index="local.account">
                    <button type="button" class="dropdown-item text-light" data-change-account="#local.account.getid()#" #matchDisplay(local.account.getid(),rc.account.getid(),'disabled')#>
                        #local.account.getLinkedAccount().getName()#
                        <cfif local.account.getLinkedAccount().getName() neq local.account.getName()>
                            : #local.account.getName()#
                        </cfif>
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

</cfoutput>