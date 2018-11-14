    <cfoutput>

        #view("transaction/_tabs")#
        
        <cfset local.viewID = "view" & randrange(1,10000000)>
        <cfset local.transactions = []>
        <cfset local.transactions.addAll(rc.unverifiedTransactions)>
        <cfset local.transactions.addAll(rc.verifiedTransactions)>

        <div id="#local.viewId#">

            <table class="table">
                <col style="width:20px">
                <thead>
                    <tr>
                        <th></th>
                        <th>Date</th>
                        <th>Description</th>
                        <th class="d-none d-md-table-cell">Category</th>
                        <th class="d-none d-md-table-cell">Note</th>
                        <th style="text-align:right">Amount</th>
                        <th></th>
                        <th></th>
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
                    <cfif local.transaction.getid() eq rc.lastVerifiedId>
                        <cfset local.rowClass &= ' last-verified'>
                    </cfif>
                    
                    <tr class="#local.rowClass#" data-trn="#local.transaction.getid()#">
                        <td>
                            <cfif local.transaction.isTransfer()>
                                <i class="fa fa-fw fa-exchange" title="#local.transaction.getTransferDescription()#"></i>
                            </cfif>
                        </td>
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
                            <button type="button" class="btn btn-sm btn-primary #displayIf(local.transaction.isVerified(), 'd-none')#">clear</button>
                            <button type="button" class="btn btn-sm btn-danger #displayIf(!local.transaction.isVerified(), 'd-none')#">undo</button>
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
                    $transactionRows = $viewDiv.find("tr[data-trn]"),
                    $clearBtn = $transactionRows.find("button.btn-primary"),
                    $undoBtn = $transactionRows.find("button.btn-danger"),
                    
                    getRow = function($rowElement){
                        return $rowElement.closest("tr");
                    },

                    clear = function($tr){
                        var transactionId = $tr.data("trn");
                        $tr.addClass('verified');  
                        $tr.removeClass('default');
                        $tr.find("button").removeClass('d-none');
                        $tr.find("button.btn-primary").addClass('d-none');
                        updateSummary('clear',transactionId);
                    },
                
                    undo = function($tr){
                        var transactionId = $tr.data("trn");
                        $tr.addClass('default');  
                        $tr.removeClass('verified');
                        $tr.find("button").removeClass('d-none');
                        $tr.find("button.btn-danger").addClass('d-none');
                        updateSummary('undo',transactionId);
                    },
                    
                    updateSummary = function(action,trnID){
                        postJSON( root_path + 'transaction/' + action, {
                            transactionId: trnID
                        }, function(data){
                            console.log(data);
                            jsHook.getElement('linkedBalanceVerified').html("$" + data.verifiedLinkedBalance);
                            $transactionRows.removeClass('last-verified');
                            $transactionRows.filter("[data-trn='" + data.lastVerifiedId + "']").addClass('last-verified');
                        });
                    };

                $editBtn.click(function(){
                    post(root_path + 'transaction/edit', {
                        transactionid:$(this).data('editTransaction'),
                        returnTo: 'transaction.verify'
                    });
                });

                $clearBtn.click( function() {
                    clear( getRow($(this)) );
                });

                $undoBtn.click( function() {
                    undo( getRow($(this)) );
                });
                
                $transactionRows.swipe(function(e,touch){
                    var $tr = $(this)
                        screenWidth = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
                    
                    if(screenWidth < 768){
                        switch(touch.direction){
                            case 'right':
                                clear($tr); break;
                            case 'left':
                                undo($tr);  break;
                        }
                    }
                    

                });

            });
        </script>

    </cfoutput>