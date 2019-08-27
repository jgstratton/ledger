<cfoutput>

    #view("transaction/_tabs")#
    <!---
    #view("transaction/_transactionForm")#
    --->
    <cfset local.viewID = "view" & randrange(1,10000000)>

    <div id="#local.viewId#" class="center-content">

        <h6 class="small text-muted">Recent Transactions</h6>

        <div class="sm-stretch">
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
                        <th>&nbsp;</th>
                    </tr>
            
                </thead>

                <cfloop array="#rc.transactions#" item="local.transaction">

                    <cfset local.transStyle = ''>
                    <cfif local.transaction.signedAmount lt 0>
                        <cfset local.transStyle = 'text-danger'>
                    </cfif>

                    <cfset local.rowClass = ''>
                    <cfif StructKeyExists(rc,"lastTransactionId") and local.transaction.id eq rc.lastTransactionid>
                        <cfset local.rowClass = "temp-highlight-row table-success transition-ease">
                    </cfif>

                    <tr class="#local.rowClass#">
                        <td>
                            <cfif len(local.transaction.transferType) gt 0>
                                <i class="fa fa-fw fa-exchange" title="transfer #local.transaction.transferType# #local.transaction.linkedAccountName#"></i>
                            </cfif>
                        </td>
                        <td>#dayFormat(local.transaction.TransactionDate)#</td>
                        <td>#local.transaction.Name#</td>
                        <td class="d-none d-md-table-cell">
                            #local.transaction.Category_Name#
                        </td>
                        <td class="d-none d-md-table-cell">#local.transaction.Note#</td>
                        <td class="#local.transStyle#" align="right">#moneyFormat(abs(local.transaction.signedAmount))#</td>
                        <td>
                            <button type="submit" class="btn btn-link" data-edit-transaction="#local.transaction.id#" data-is-transfer="#(len(local.transaction.transferType) gt 0)#">
                                <i class="fa fa-pencil"></i>
                            </button>
                        </td>
                    </tr>

                </cfloop>

            </table>
        </div>
    </div>

<script>
    viewScripts.add( function(){
        var viewId = '#local.viewId#',
            $viewDiv = $("##" + viewId),
            $editBtn = $viewDiv.find("[data-edit-transaction]");

        $editBtn.click(function(){
            var $this = $(this),
                postUrl = '#buildurl("transaction.edit")#';
            
            if ( $this.data('isTransfer') ){
                postUrl = '#buildurl("transfer.edit")#';
            }
            post(postUrl, {
                transactionid:$(this).data('editTransaction'),
                returnTo: 'transaction.newTransaction',
                accountid: '#rc.accountId#'
            });
        });
        

    });
</script>
</cfoutput>