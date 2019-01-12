<cfoutput>
    <cfset local.mode = request.item eq 'edit' ? 'edit' : 'new'>
    <div class="sm-pad">
        #view("includes/alerts")#
        
        <form name="frmTransfer" method="post">
            #formPreserveKeys(rc,"transactionId,returnTo,accountId")#
            <cfif local.mode eq "edit">
                <div class="row">
                    <div class="col-md-6">
                        <i class="fa fa-exchange"></i> Edit Transfer
                        
                        <button type="button" class="btn btn btn-outline-danger btn-sm pull-right" data-delete-btn>
                            <i class="fa fa-trash"></i> Delete Transfer
                        </button>   
                        <hr>
                    </div>
                </div>
            </cfif>
            <div class="row">
                <div class="col-md-6">
                    <div class="row">
                        <label class="col-3 col-form-label">From Account:</label>
                        <div class="col-9">
                            <select name="fromAccountId" class="form-control form-control-sm" >
                                <cfloop array="#rc.accounts#" index="local.account">
                                    <option value="#local.account.getId()#" #selectIf(local.account.getId() eq rc.transfer.getfromAccountId())#>
                                        #local.account.getName()# ... $#local.account.getBalance()#
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
                                        #local.account.getName()# ... $#local.account.getBalance()#
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
                                <input type="text" name="transferDate" value="#rc.transfer.getTransferDate()#" class="form-control form-control-sm" data-datepicker readonly >
                                <div class="input-group-append">
                                    <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    #view('transaction/_formButtons', {
                        type = 'transfer',
                        mode = local.mode
                    })#

                </div>
            </div>
        </form>
    </div>

    <script>
        viewScripts.add(function(){
            var $view = $("###local.templateid#"),
                $form = $view.find("form"),
                transactionId = $form.find("[name='transactionId']").val();


            $view.find("[data-delete-btn]").click(function(){
                
                jConfirm("Are you sure you want to delete this transfer?",function(){
                    post('#buildurl('transaction.deleteTransaction')#',{
                        transactionId: transactionId,
                        returnTo: '#rc.returnTo#',
                        accountID: '#(rc.keyExists('accountId') ? rc.accountId : 0)#'
                    });
                });
            });
            $view.find("[datepicker]").datepicker();
            
        });
    </script>

</cfoutput>