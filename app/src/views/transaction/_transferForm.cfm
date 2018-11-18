<cfoutput>

    <!--- Display any validation errors --->
    <cfif StructKeyExists(rc,"errors") and ArrayLen(rc.errors) gt 0>
        <div class="alert alert-danger">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            <div class="">
                <i class="fa fa-exclamation-triangle"></i> Please correct the following errors and then try to save your transfer again.
            </div>
            <ul>
                <cfloop array="#rc.errors#" item="error">
                    <li>#error#</li>
                </cfloop>
            </ul>
        </div>
    </cfif>

    <!--- Display success messages afer completion --->
    <cfif StructKeyExists(rc,"success")>
        <div class="alert alert-success">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            <div class="">
                <i class="fa fa-check"></i> #rc.success#
            </div>
        </div>
    </cfif>

    <form name="frmTransfer" method="post">
        #formPreserveKeys(rc,"transactionId,returnTo,accountId")#
        <div class="row">
            <div class="col-md-6">
                <div class="row">
                    <label class="col-3 col-form-label">From Account:</label>
                    <div class="col-9">
                        <select name="fromAccountId" class="form-control form-control-sm" >
                            <cfloop array="#rc.accounts#" index="local.account">
                                <option value="#local.account.getId()#" #selectIf(local.account.getId() eq rc.transfer.getfromAccountId())#>
                                    #local.account.getName()# #rc.transfer.getfromAccountId()#
                                </option>
                            </cfloop>
                        </select>
                        <div id="fromAccountBalance"></div>
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label">To Account:</label>
                    <div class="col-9">
                        <select name="toAccountId" class="form-control form-control-sm" >
                            <cfloop array="#rc.accounts#" index="local.account">
                                <option value="#local.account.getId()#" #selectIf(local.account.getId() eq rc.transfer.getToaccountId())#>
                                    #local.account.getName()# #rc.transfer.getToaccountId()#
                                </option>
                            </cfloop>
                        </select>
                        <div id="toAccountBalance"></div>
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label">Amount:</label>
                    <div class="col-9">
                        <input type="text" value="#rc.transfer.getAmount()#" name="Amount" class="form-control form-control-sm">
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label">Description:</label>
                    <div class="col-9">
                        <input type="text" value="#rc.transfer.getName()#" name="name" class="form-control form-control-sm" >
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label">Date:</label>
                    <div class="col-9">
                        <div class="input-group">
                            <input type="text" name="transferDate" value="#rc.transfer.getTransferDate()#" class="form-control form-control-sm" data-datepicker readonly>
                            <div class="input-group-append">
                                <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label"></label>
                    <div class="col-9">
                        <button type="submit" class="btn btn-primary" name="submit">
                            Submit Transfer
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</cfoutput>
<script>
    $("[data-datepicker]").datepicker();
</script>