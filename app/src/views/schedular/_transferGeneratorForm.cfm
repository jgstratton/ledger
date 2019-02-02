<cfoutput>
    <form method="post"  action="#buildurl('schedular.saveGeneratorForm')#" data-validate-url="#buildurl('schedular.validateTransactionGeneratorForm')#">
        <input type="hidden" name="eventGeneratorId" value="#rc.transferGenerator.getEventGeneratorId()#">
        <input type="hidden" name="generatorType" value="transfer">
        <div class="row">
            <label class="col-3 col-form-label">Name:</label>
            <div class="col-9">
                <input type="text" name="eventName" value="#rc.transferGenerator.getEventName()#" class="form-control form-control-sm">
            </div>
        </div>
        
        <h6 class="small text-muted mt-3"><i class="fa #rc.transferGenerator.getGeneratorIcon()#"></i> Transfer Details</h6>
        <hr class="sm">
        <div class="row">
            <label class="col-3 col-form-label">From<span class="d-none d-lg-inline"> Account</span>:</label>
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
            <label class="col-3 col-form-label">To<span class="d-none d-lg-inline"> Account</span>:</label>
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
            <label class="col-3 col-form-label">Defer<span class="d-none d-lg-inline"> Date</span>:</label>
            <div class="col-9">
                <div class="input-group">
                    <select name="deferDate" class="form-control form-control-sm">
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
        <h6 class="small text-muted mt-4"><i class="fa fa-calendar"></i> Schedule</h6>
        <hr class="sm">     
        #view("schedular/_scheduleSubForm", {schedular: rc.transferGenerator.getSchedular()})#
    </form>
</cfoutput>