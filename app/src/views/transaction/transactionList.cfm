<cfoutput>

    <div id="#local.templateId#" class="center-content">
        <div class="sm-stretch">
            <table class="table table-sm">
                <col style="width:20px">
                <thead>
                    <tr>
                        <th></th>
                        <th>Date</th>
                        <th>Description</th>
                        <th class="d-none d-md-table-cell">Category</th>
                        <th class="d-none d-md-table-cell">Note</th>
                        <th style="text-align:right">Amount</th>
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
                        <td>
                            <a href="##" data-edit-transaction="#local.transaction.id#" data-is-transfer="#(len(local.transaction.transferType) gt 0)#">
                                #local.transaction.Name#
                            </a>
                        </td>
                        <td class="d-none d-md-table-cell">
                            #local.transaction.Category_Name#
                        </td>
                        <td class="d-none d-md-table-cell">#local.transaction.Note#</td>
                        <td class="#local.transStyle#" align="right">#moneyFormat(abs(local.transaction.signedAmount))#</td>
                    </tr>

                </cfloop>

            </table>
        </div>
    </div>

<script>
    viewScripts.add( function(){
        var viewId = '#local.templateId#',
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
                returnTo: 'transaction.transactionList',
                accountid: '#rc.accountId#'
            });
        });
        

    });
</script>
</cfoutput>