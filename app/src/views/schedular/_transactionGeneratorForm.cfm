<cfoutput>
    <form method="post" action="#buildurl('schedular.saveGeneratorForm')#" data-validate-url="#buildurl('schedular.validateTransferGeneratorForm')#">
        <input type="hidden" name="eventGeneratorId" value="#rc.transactionGenerator.getEventGeneratorId()#">
        <input type="hidden" name="generatorType" value="transaction">
        <div class="row">
            <label class="col-3 col-form-label">Name:</label>
            <div class="col-9">
                <input type="text" name="eventName" value="#rc.transactionGenerator.getEventName()#" class="form-control form-control-sm">
            </div>
        </div>
        <h6 class="small text-muted mt-3"><i class="fa #rc.transactionGenerator.getGeneratorIcon()#"></i> Transaction Details</h6>
        <hr class="sm">
        <div class="row">
            <label class="col-3 col-form-label">Account:</label>
            <div class="col-9">
                <select name="accountid" class="form-control form-control-sm">
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
                <select name="categoryid" class="form-control form-control-sm">
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
            <label class="col-3 col-form-label">Defer<span class="d-none d-lg-inline"> Date</span>:</label>
            <div class="col-9">
                <div class="input-group">
                    <select name="deferDate" class="form-control form-control-sm">
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
        <h6 class="small text-muted mt-4"><i class="fa fa-calendar"></i> Schedule</h6>
        <hr class="sm">
        #view("schedular/_scheduleSubForm", {schedular: rc.transactionGenerator.getSchedular()})#
    </form>
</cfoutput>