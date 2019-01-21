<cfoutput>
    <div data-modal-wrapper></div>
    <div class="sm-pad">
        #view("includes/alerts")#
        <div class="text-right clearfix">
            <h3 class="pull-left">Manage Categories</h3>
            <button type="button "class="btn btn-sm btn-primary" data-new>
                <i class="fa fa-plus"></i> New Category
            </button>
        </div>
    </div>

    <div class="sm-pad">
        <p class="text-info">
            Manage the categories you use for your checkbook transactions.  The <i class="fa fa-plus fa-fw text-success"></i> indicates that the transaction will be adding money into your
            account, while the <i class="fa fa-minus fa-fw text-danger"></i> indicates it should be deducting from the account.
        </p>
    </div>
	
    <table class="table table-condensed">
        <thead>
            <tr>
                <th>Category</th>
                <th class="text-right">##transactions</th>
                <th class="text-right">Total Amount</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <cfloop array="#rc.viewModel.getCategories()#" item="category">
                <cfset local.disabledClass = category.isActive ? "" : 'text-disabled'>
                <tr class="#local.disabledClass#">
                    <td>
                        <cfif category.multiplier gt 0>
                            <i class="fa fa-plus fa-fw text-success #local.disabledClass#"></i>
                        <cfelse>
                            <i class="fa fa-minus fa-fw text-danger #local.disabledClass#"></i>
                        </cfif>
                        #category.name#
                    </td>
                    <td class="text-right">#category.transactionCount#</td>
                    <td class="text-right">#moneyFormat(category.totalAmount)#</td>
                    <td>
                        <button class="btn btn-link btn-sm" data-edit data-id="#category.id#">
                            <i class="fa fa-pencil"></i> edit
                        </button>
                    </td>
                </tr>
            </cfloop>
        </tbody>

    </table>
    
    

    <script>
        viewScripts.add( function(){
            var $viewDiv = $("###local.templateid#"),
                $newBtn = $viewDiv.find("[data-new]"),
                $editBtn = $viewDiv.find("[data-edit]"),
                $modalWrapper = $viewDiv.find("[data-modal-wrapper]"),
            
            populateAndShowModal = function(html, title){
                $modalWrapper.html(html);
                var $modal = $modalWrapper.find(".modal");
                $modal.find(".modal-title").html(title);
                $modal.modal('show');
            };

            $newBtn.click(function(){
                $.get("#buildurl('category.newCategoryModal')#", function(responseHtml) {
                    populateAndShowModal(responseHtml, "Add New Category");
                });
            });

            $editBtn.click(function(){
                var data = {
                    categoryid: $(this).data('id')
                };
                $.get("#buildurl('category.editCategoryModal')#", data, function(responseHtml) {
                    populateAndShowModal(responseHtml, "Edit Category");
                });
            });
        
        });
    </script>
</cfoutput>