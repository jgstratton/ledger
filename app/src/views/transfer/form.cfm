<cfoutput>
    <form name="frmTransfer" method="post" action="#buildurl('transfer.submit')#">
        <cfif rc.keyExists("transactionid")>
            <input type="hidden" name="transactionid" value="#rc.transactionid#">
        </cfif>
        
        <div class="row">
            <div class="col-md-6">
                <p class="text-info">
                    Transfer funds between accounts.  This can be used when making actual transfers, making credit card payments, or moving money
                    into a sub account.
                </p>
                
                <div class="row">
                    <label class="col-3 col-form-label">From Account:</label>
                    <div class="col-9">
                        <select name="FromAccount" class="form-control form-control-sm" >
                            <cfloop array="#rc.accounts#" index="local.account">
                                <option value="#local.account.getId()#" #selectIf(local.account.getId() eq rc.fromAccountId)#>
                                    #local.account.getName()#
                                </option>
                            </cfloop>
                        </select>
                        <div id="fromAccountBalance"></div>
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label">To Account:</label>
                    <div class="col-9">
                        <select name="ToAccount" id="ToAccount" class="form-control form-control-sm" >
                            <cfloop array="#rc.accounts#" index="local.account">
                                <option value="#local.account.getId()#" #selectIf(local.account.getId() eq rc.toAccountId)#>
                                    #local.account.getName()#
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
                            <input type="text" name="Date" value="#rc.transfer.getTransactionDate()#" class="form-control form-control-sm" data-datepicker readonly>
                            <div class="input-group-append">
                                <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <label class="col-3 col-form-label"></label>
                    <div class="col-9">
                        <button type="submit" class="btn btn-primary">
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