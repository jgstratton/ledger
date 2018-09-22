<cfoutput>

    #view("transaction/_tabs")#
    #view("transaction/_errors")#
    #view("transaction/_form")#

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
            <!---
$TranStyle = "";
                if($TranAmount < 0){
                    $TranAmount = number_format($TranAmount * -1.00,2, '.', '');
                    $TranStyle = "color:red";
                }

            --->

            <cfset local.rowClass = ''>
            <cfif StructKeyExists(rc,"lastTransactionId") and local.transaction.getid() eq rc.lastTransactionid>
                <cfset local.rowClass = "bg-success transition-ease">
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
                <td style="<?= $TranStyle ?>" align="right">#moneyFormat(local.transaction.getAmount())#</td>
                <td>
                    <button type="submit" class="btn btn-link" data-edit-trans="#rc.transaction.getid()#">
                        <i class="fa fa-pencil"></i>
                    </button>
                </td>
            </tr>

        </cfloop>

    </table>

    <!---

   
<br>


    <br>

</div>
    
<?php require( 'includes/Site_Layout_End.php');?>
    <script>
        $("#Description").focus();
        $("[data-datepicker]").datepicker();
        
        
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
  
        $("tr.bg-success").removeClass("bg-success");
        
    </script>
    


--->
</cfoutput>