<cfoutput>

    #view("transaction/_tabs")#
    #view("transaction/_transactionForm")#

    <cfset local.viewID = "view" & randrange(1,10000000)>

    <div id="#local.viewId#">

        <h6 class="small text-muted sm-pad">Recent Transactions</h6>

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
                <cfif local.transaction.getSignedAmount() lt 0>
                    <cfset local.transStyle = 'text-danger'>
                </cfif>

                <cfset local.rowClass = ''>
                <cfif StructKeyExists(rc,"lastTransactionId") and local.transaction.getid() eq rc.lastTransactionid>
                    <cfset local.rowClass = "temp-highlight-row table-success transition-ease">
                </cfif>

                <tr class="#local.rowClass#">
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
                        <button type="submit" class="btn btn-link" data-edit-transaction="#local.transaction.getid()#" data-is-transfer="#local.transaction.isTransfer()#">
                            <i class="fa fa-pencil"></i>
                        </button>
                    </td>
                </tr>

            </cfloop>

        </table>
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