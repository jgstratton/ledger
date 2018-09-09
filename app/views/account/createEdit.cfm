<cfoutput>


    <cfif rc.mode eq "create">
        <h4>Create a New Account</h4>
    <cfelse>
        <h4>Edit Account: #rc.title# ... #rc.balance#</h4>
    </cfif>

    #view("includes/errors")#
    <form name="frm#rc.mode#Account" method="post" class="form-horizontal" autocomplete="off">
        
        <input type="hidden" name="mode" value="#rc.mode#">
        <input type="hidden" name="accountId" value="#rc.account.getId()#">
        
        <div class="row">
            <label class="col-2 col-form-label">Account Name:</label>
            <div class="col-5">
                <input type="text" name="Name" class="form-control form-control-sm" value="#rc.account.getName()#">
            </div>
        </div>

        <div class="row">
            <label class="col-2 col-form-label">Type:</label>
            <div class="col-5">
                <select name="accountTypeId" class="form-control form-control-sm">
                    <cfloop array="#rc.accountTypes#" index="i" item="thisAccountType">
                        <option value="#thisAccountType.getID()#" #matchSelect(thisAccountType.getId(), rc.account.getTypeId())#>
                            #thisAccountType.getName()#
                        </option>
                    </cfloop>
                    <cfif arrayLen(rc.accounts) gt 0>
                        <option value="0" #matchSelect(0, rc.accountTypeId)#>
                            Virtual / Sub Account 
                        </option>
                    </cfif>
                </select>
            </div>
        </div>
        
        <div id="linkedAccount" class="collapse #matchHide(0,rc.accountTypeId,'collapsed')#">
            <div class="row">
                <div class="col-5 offset-2">
                    <p class="text-info">
                        A virtual account is a partitioning of your real account.  You can use this to "set aside" funds 
                        for a particular use, without actually taking the money out of the account.
                    </p>
                </div>
            </div>
            <div class="row">
                <label class="col-2 col-form-label">Parent Account:</label>
                <div class="col-5">
                    <select name="linkedAccount" class="form-control form-control-sm">
                        <cfloop array="#rc.accounts#" item="thisAccount" index="i">
                            <option value="#thisAccount.getId()#" #matchSelect(rc.account.getLinkedAccountID(),thisAccount.getId())#>
                                #thisAccount.getName()#
                            </option>
                        </cfloop>
                    </select>
                </div>
            </div>
        </div>

        <div class="row" style="padding-top:10px;padding-bottom:10px">
            <label class="col-2"></label>
            <div class="col-5">
                <input type="checkbox" name="Summary" value="Y" #matchCheck(rc.account.getSummary(),'Y')#> Include in checkbook summary?
            </div>
        </div>

        <cfif len(rc.accountId) neq 0>
            <div class="row">
                <label class="col-2"></label>
                <div class="col-5">
                    <button type="submit" class="btn btn-sm btn-primary">
                        Update Account
                    </button>
                    <button type="button" class="btn btn-danger btn-sm pull-right" data-delete="#rc.accountId#">
                        <i class="fa fa-trash"></i> Delete
                    </button>
                </div>
            </div>
        <cfelse>
            <div class="row">
                <label class="col-2"></label>
                <div class="col-5">
                    <button type="submit" name="submitAddAccount" class="btn btn-sm btn-primary">
                        <i class="fa fa-plus"></i> Add Account
                    </button>
                </div>
            </div>
        </cfif>
    </form>

</cfoutput>

<script>
    viewScripts.add( function(){
        "use strict";

        var $typeSelect = $("[name='accountTypeId']"),
            $linkedAccount = $("#linkedAccount"),
            toggle = function(){
                if($typeSelect.val() == 0){
                    $linkedAccount.collapse('show');
                } else {
                    $linkedAccount .collapse('hide');
                }
            };

        $typeSelect.change(toggle);
        toggle();
    });

</script>