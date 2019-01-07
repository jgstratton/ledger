<cfoutput>
    <form method="post" data-validate-url="#buildurl('schedular.validateTransactionGeneratorForm')#">
        <div class="row">
            <label class="col-3 col-form-label">Name:</label>
            <div class="col-9">
                <input type="text" name="eventName" value="#rc.transactionGenerator.getEventName()#" class="form-control form-control-sm">
            </div>
        </div>
        <hr>
        <div class="row">
            <label class="col-3 col-form-label">Account:</label>
            <div class="col-9">
                <select name="newAccountId" class="form-control form-control-sm">
                    <cfloop array="#rc.accounts#" item="local.account">
                        <option value="#local.account.getId()#" #matchSelect(local.account.getId(), rc.transactionGenerator.getAccountId())#>
                            #local.account.getLongName()#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Description:</label>
            <div class="col-9">
                <input type="text" name="Name" value="#rc.transactionGenerator.getname()#" class="form-control form-control-sm">
            </div>
        </div>
        
        <div class="row">
            <label class="col-3 col-form-label">Type:</label>
            <div class="col-9">
                <select name="Category" class="form-control form-control-sm">
                    <cfloop array="#rc.categories#" item="local.category">
                        <option value="#local.category.getid()#" #matchSelect(local.category.getid(), rc.transactionGenerator.getCategoryid())#>
                            #local.category.getName()#
                        </option>
                    </cfloop>
                </select>
            </div>
            
        </div>
        
        <div class="row">
            <label class="col-3 col-form-label">Amount:</label>
            <div class="col-9">
                <input type="text" name="Amount" value="#rc.transactionGenerator.getAmount()#" class="form-control form-control-sm">
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Defer Date:</label>
            <div class="col-9">
                <div class="input-group">
                    <select name="Defer Date" class="form-control form-control-sm">
                        <option value="0" #matchSelect(0, rc.transactionGenerator.getDeferDate())#>
                            (Use scheduled date)
                        </option>
                        <cfloop from="1" to="31" index="local.i">
                            <option value="#local.i#" #matchSelect(local.i, rc.transactionGenerator.getDeferDate())#>
                                #local.i# days
                            </option>
                        </cfloop>
                    </select>
                </div>
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Note:</label>
            <div class="col-9">
                <input type="text" name="Note" value="#rc.transactionGenerator.getNote()#" class="form-control form-control-sm">
            </div>
        </div>
        
    </form>
</cfoutput>