    <cfoutput>

        #view("transaction/_tabs")#
        
        <cfset local.viewID = "view" & randrange(1,10000000)>
        <cfset local.transactions = []>
        <cfset local.transactions.addAll(rc.unverifiedTransactions)>
        <cfset local.transactions.addAll(rc.verifiedTransactions)>

        <div id="#local.viewId#">

            <table class="table">
            
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th class="d-none d-md-table-cell">Category</th>
                        <th class="d-none d-md-table-cell">Note</th>
                        <th style="text-align:right">Amount</th>
                        <th>&nbsp;</th>
                    </tr>
            
                </thead>

                <cfloop array="#local.transactions#" item="local.transaction">
                    
                    <cfset local.transStyle = ''>
                    <cfif local.transaction.getSignedAmount() lt 0>
                        <cfset local.transStyle = 'text-danger'>
                    </cfif>

                    <!--- build the current row class --->
                    <cfset local.rowClass = 'verify-row'>
                    <cfif len(local.transaction.getVerifiedDate())>
                        <cfset local.rowClass &= ' verified'>
                    </cfif>
                    <cfif local.transaction.getid() eq rc.lastVerifiedTransaction.getid()>
                        <cfset local.rowClass &= ' last-verified'>
                    </cfif>
                    
                    <tr class="#local.rowClass#" data-trn="#local.transaction.getid()#">
                        <td>#dayFormat(local.transaction.getTransactionDate())#</td>
                        <td>#local.transaction.getName()#</td>
                        <td class="d-none d-md-table-cell">
                            <cfif local.transaction.hasCategory()>
                                #local.transaction.getCategory().getName()#
                            </cfif>
                        </td>
                        <td class="d-none d-md-table-cell">#local.transaction.getNote()#</td>
                        <td class="#local.transStyle#" align="right">#moneyFormat(abs(local.transaction.getSignedAmount()))#</td>
                        <td>
                            <button type="submit" class="btn btn-link" data-edit-transaction="#local.transaction.getid()#">
                                <i class="fa fa-pencil"></i>
                            </button>
                        </td>
                        <td class="right d-none d-md-table-cell">
                            <button type="button" class="btn btn-sm btn-primary">clear</button>
                            <button type="button" class="btn btn-sm btn-danger">undo</button>
                        </td>   
                    </tr>

                </cfloop>

            </table>
        </div>

        <script>
            viewScripts.add( function(){
                var viewId = '#local.viewId#',
                    $viewDiv = $("##" + viewId),
                    $editBtn = $viewDiv.find("[data-edit-transaction]"),
                    $transactionRow = $viewDiv.find("tr[data-trn]"),
                    $clearBtn = $transactionRow.find("button.btn-primary"),
                    $undoBtn = $transactionRow.find("button.btn-danger"),
                    
                    getRow = function($rowElement){
                        return $rowElement.closest("tr");
                    },

                    clear = function($tr){
                        var transactionId = $tr.data("trn");
                        $tr.addClass('highlight');  
                        $tr.removeClass('default');
                        updateSummary('clear',transactionId);
                    },
                
                    undo = function($tr){
                        var transactionId = $tr.data("trn");
                        $tr.addClass('default');  
                        $tr.removeClass('highlight');
                        updateSummary('undo',transactionId);
                    },
                    
                    updateSummary = function(action,trnID){
                        postJSON( root_path + 'transaction/' + action, {
                            transactionId: trnID
                        }, function(data){
                            jsHook.getElement('accountBalance').html("$" + data.DefaultBalance);
                            jsHook.getElement('accountBalanceVerified').html("$" + data.LinkVerified);
                            $transactionRow.removeClass('last-verified');
                            $transactionRow.find("[data-trn='" + data.LastVerified + "']").addClass('primary');
                        });
                    };

                $editBtn.click(function(){
                    post(root_path + 'transaction/edit', {
                        transactionid:$(this).data('editTransaction'),
                        returnPage: 'verify'
                    });
                });

                $clearBtn.click(function(){
                    clear(getRow($(this)));
                });

                $undoBtn.click(function(){
                    undo(getRow($(this)));
                });
                
            });
        </script>

    </cfoutput>