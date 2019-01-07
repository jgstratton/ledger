<cfoutput>
    <form method="post"  action="" data-validate-url="#buildurl('schedular.validateTransferForm')#">
        <div class="row">
            <label class="col-3 col-form-label">Name:</label>
            <div class="col-9">
                <input type="text" name="eventName" value="#rc.transferGenerator.getEventName()#" class="form-control form-control-sm">
            </div>
        </div>
        <hr>
        <div class="row">
            <label class="col-3 col-form-label">From Account:</label>
            <div class="col-9">
                <select name="fromAccountId" class="form-control form-control-sm">
                    <cfloop array="#rc.accounts#" item="local.account">
                        <option value="#local.account.getId()#" #matchSelect(local.account.getId(), rc.transferGenerator.getFromAccountId())#>
                            #local.account.getName()# ... $#local.account.getBalance()#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>
        <div class="row">
            <label class="col-3 col-form-label">To Account:</label>
            <div class="col-9">
                <select name="toAccountId" class="form-control form-control-sm">
                    <cfloop array="#rc.accounts#" item="local.account">
                        <option value="#local.account.getId()#" #matchSelect(local.account.getId(), rc.transferGenerator.getToAccountId())#>
                            #local.account.getName()# ... $#local.account.getBalance()#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>
        <div class="row">
            <label class="col-3 col-form-label">Amount:</label>
            <div class="col-9">
                <input type="text" name="Amount" value="#rc.transferGenerator.getAmount()#" class="form-control form-control-sm">
            </div>
        </div>       
        <div class="row">
            <label class="col-3 col-form-label">Description:</label>
            <div class="col-9">
                <input type="text" name="Name" value="#rc.transferGenerator.getname()#" class="form-control form-control-sm">
            </div>
        </div>
        <div class="row">
            <label class="col-3 col-form-label">Defer Date:</label>
            <div class="col-9">
                <div class="input-group">
                    <select name="Defer Date" class="form-control form-control-sm">
                        <option value="0" #matchSelect(0, rc.transferGenerator.getDeferDate())#>
                            (Use scheduled date)
                        </option>
                        <cfloop from="1" to="31" index="local.i">
                            <option value="#local.i#" #matchSelect(local.i, rc.transferGenerator.getDeferDate())#>
                                #local.i# days
                            </option>
                        </cfloop>
                    </select>
                </div>
            </div>
        </div>        
    </form>
</cfoutput>