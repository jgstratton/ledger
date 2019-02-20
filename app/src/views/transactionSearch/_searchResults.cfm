<cfoutput>
    <table id="resultsTable#local.templateId#" class="display responsive nowrap" style="width:100%">
        <thead>
            <tr>
                <th>Date</th>
                <th>Description</th> 
                <th>Account</th>
                <th>Note</th>
                <th>Category</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
            <cfloop array="#rc.transactions#" index="transaction">                
                <tr>
                    <td>#dayFormat(transaction.getTransactionDate())#</td>
                    <td>#transaction.getName()#</td>
                    <td>#transaction.getAccount().getName()#</td>
                    <td>#transaction.getNote()#</td>
                    <td>#transaction.getCategory().getName()#</td>         
                    <td class="text-right">#htmlMoneyFormat(transaction.getSignedAmount())#</td>
                </tr>
            </cfloop>
        </tbody>
    </table>

    <script>
        viewScripts.add( function(){
            var $resultsTable = $("##resultsTable#local.templateId#");
            $resultsTable.DataTable({
                searching: false,
                paging:true,
                responsive: true,
                columnDefs: [
                    { responsivePriority: 1, targets: 0 },
                    { responsivePriority: 2, targets: -1 },
                    { responsivePriority: 3, targets: 1 }
                ]
            });
        });
    </script>
</cfoutput>