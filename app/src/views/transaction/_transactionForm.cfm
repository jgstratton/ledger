<cfoutput>
    <!--- Display any form validation errors --->
    <cfif StructKeyExists(rc,"errors") and ArrayLen(rc.errors) gt 0>
        <div class="alert alert-danger">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            <div class="">
                <i class="fa fa-exclamation-triangle"></i> Please correct the following errors and then try to save your transaction again.
            </div>
            <ul>
                <cfloop array="#rc.errors#" item="error">
                    <li>#error#</li>
                </cfloop>
            </ul>
        </div>
    </cfif>

    <form method="post" style="max-width:600px">
        #formPreserveKeys(rc,"transactionId,returnTo,accountId")#
        <div class="row">
            <label class="col-3 col-form-label">Account:</label>
            <div class="col-9">
                <span class="input-static">
                    #rc.account.getName()#
                </span>
                <button type="button" class="btn btn btn-outline-danger btn-sm pull-right" data-delete-btn>
                    <i class="fa fa-trash"></i> Delete Entry
                </button>  
            </div>
        </div>
        <hr>

        <div class="row">
            <label class="col-3 col-form-label">Description:</label>
            <div class="col-9">
                <input type="text" name="Name" value="#rc.transaction.getname()#" class="form-control form-control-sm">
            </div>
        </div>
        
        <div class="row">
            <label class="col-3 col-form-label">Type:</label>
            <div class="col-9">
                <select name="Category" class="form-control form-control-sm">
                    <cfloop array="#rc.categories#" item="local.category">
                        <option value="#local.category.getid()#" #matchSelect(local.category.getid(), rc.transaction.getCategoryid())#>
                            #local.category.getName()#
                        </option>
                    </cfloop>
                </select>
            </div>
            
        </div>
        
        <div class="row">
            <label class="col-3 col-form-label">Amount:</label>
            <div class="col-9">
                <input type="text" name="Amount" value="#rc.transaction.getAmount()#" class="form-control form-control-sm">
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Date:</label>
            <div class="col-9">

                <div class="input-group">
                    <input type="text" name="transactionDate" value="#dayFormat(rc.transaction.getTransactionDate())#" class="form-control form-control-sm" data-datepicker>
                    <div class="input-group-append">
                        <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                    </div>
                </div>

            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Note:</label>
            <div class="col-9">
                <input type="text" name="Note" value="#rc.transaction.getNote()#" class="form-control form-control-sm">
            </div>
        </div>
        
        #view('transaction/_formButtons', {
            type = 'transaction',
            mode = request.item eq 'edit' ? 'edit' : 'new'
        })#
    </form>

    <script>
        viewScripts.add(function(){
            var $view = $("###local.templateid#"),
                $form = $view.find("form"),
                transactionId = $form.find("[name='transactionId']").val();


            $view.find("[data-delete-btn]").click(function(){
                
                jConfirm("Are you sure you want to delete this transaction?",function(){
                    post('#buildurl('transaction.deleteTransaction')#',{
                        transactionId: transactionId,
                        returnTo: '#rc.returnTo#',
                        accountID: '#rc.accountId#'
                    });
                });
            });
            $view.find("[datepicker]").datepicker();
            
        });
    </script>

</cfoutput>