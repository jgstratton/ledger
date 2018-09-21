<cfoutput>

    #view("transaction/_tabs")#
    #view("transaction/_errors")#
    #view("transaction/_form")#


    <!---

           
   

   
<br>


<h6 class="small text-muted">Recent Transactions</h6>
    
<table class="table">
    
 
    <thead>
        <tr>
            <th style="cursor: pointer;">Date</th>
            <th>Description</th>
            <th class="d-none d-md-table-cell">Category</th>
            <th class="d-none d-md-table-cell">Note</th>
            <th style="text-align:right">Amount</th>
            <th>&nbsp;</th>
        </tr>

    </thead>


        <?php

        while($row = $accounttransactions->fetch(PDO::FETCH_ASSOC)) {
            $TranDate=$row["phpEntryDate"];
            $TranID=$row["TransactionID"];
            $TranTitle=$row["EntryTitle"];
            $TranCat=$row["CategoryDescription"];
            $TranAmount=Number_format($row["Amount"],2, '.', '');
            $TranNote=$row["Note"];
            
            $TranStyle = "";
            if($TranAmount < 0){
                $TranAmount = number_format($TranAmount * -1.00,2, '.', '');
                $TranStyle = "color:red";
            }
            
            $rowStyle = '';
            if(isset($editTRN) && $editTRN == $TranID){
                $rowStyle = "bg-warning";
            } else if(isset($_SESSION['HighlightTrans']) && $_SESSION['HighlightTrans'] == $TranID){
                $rowStyle = "bg-success transition-ease";
            }
            ?>
            <tr class="<?= $rowStyle ?>">
                <td><?= $fn->date('m/d/Y',$TranDate) ?></td>
                <td><?= $TranTitle?></td>
                <td class="d-none d-md-table-cell"><?= $TranCat ?></td>
                <td class="d-none d-md-table-cell"><?= $TranNote ?></td>
                <td style="<?= $TranStyle ?>" align="right">$<?= $TranAmount ?>&nbsp;&nbsp;</td>
                <td>
                    <?php if( in_array($_POST['action'], ['insert','new']) ) { ?>
                    <button type="submit" class="btn btn-link" data-edit-trans="<?= $TranID ?>">
                        <i class="fa fa-pencil"></i>
                    </button>
                    <?php } ?>
                </td>
            </tr>
        <?php } //end while loop ?>
	</table>

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