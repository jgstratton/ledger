<cfoutput>

    #view("transaction/_tabs")#
    #view("transaction/_errors")#
    #view("transaction/_form")#

    <cfset local.viewID = "view" & randrange(1,10000000)>

    <div id="#local.viewId#">

        <h6 class="small text-muted">Recent Transactions</h6>

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
            post(root_path + 'transaction/edit', {
                transactionid:$(this).data('editTransaction'),
                returnPage: 'new'
            });
        });
        

    });
</script>

<!---

<?php require( 'includes/Site_Layout_End.php');?>
    <script>
        $("#Description").focus();      
        
        $("[data-btn-cancel]").click(function(){
            post('TRN_100.php');
        })
        
        $("[data-delete-trans]").click(function(){
            var $deleteTRN = $(this).attr('data-delete-trans');
            jConfirm('Are you sure you want to delete this entry?', function(){
                post('TRN_105.php',{action: 'delete', deleteTRN: $deleteTRN});
            });
        })
        Delete = function(frmID){
                if(confirm("Are you sure you want to delete this transaction?")){
                    $("#" + frmID).submit();
                }
        };
  
        
        
    </script>
    


--->
</cfoutput>