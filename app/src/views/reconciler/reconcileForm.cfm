<cfoutput>
	#includeStylesheet('reconcile.css')#
	#includeScript('tableUtil.js')#

	<h4 class="mb-4"><i class="fas fa-fw fa-clipboard-check"></i> Reconcile Account with External Transaction File</h4>

	<div class="card">
		<div class="card-header">
			Step 1: Upload File for Comparison
		</div>
		<div class="card-body">
			<input type="hidden" id="csvData">
			<cfoutput>
				#view('reconciler/_reconcileStep1', {
					csvDataInputId: 'csvData'
				})#
			</cfoutput>
		</div>
	</div>
	<br>
	<div class="card">
		<div class="card-header">
		Step 2: Search for checkbook transactions
		</div>
		<div class="card-body">
			<form id="searchTransactions" method="post" style="max-width:600px" class="mb-5">  
				<input type="hidden" name="includeLinked" value="true">
				<input type="hidden" name="excludeInternalTransfers" value="true">
				<div class="row">
					<label class="col-3 col-form-label">Accounts:</label>
					<div class="col-9">
						#view('controls/userAccounts', {
							accountsInput: rc.viewModel.getAccounts(),
							parentAccountsOnly: true
						})#
					</div>
				</div>
				<div class="row">
					<label class="col-3 col-form-label">Date Range:</label>
					<div class="col-9">
						#view('controls/dateRange', {
							startDateInput: rc.viewModel.getStartDate(),
							endDateInput: rc.viewModel.getEndDate()
						})#
					</div>
				</div>
				<div class="row">
					<div class="col-9 offset-sm-3">
						<button class="btn btn-sm btn-primary">Search Transactions</button>
					</div>
				</div>
			</form>
			
			<div class="preview-box-wrap">
				<div id="searchPreview" class="preview-box"></div>
			</div>
		</div>
	</div>
</cfoutput>
<br>

<div class="card">
	<div class="card-header">
	  Step 3: Reconcile!!!
	</div>
	<div class="card-body">
		<button id="btnReconcile" type="button" class="btn btn-primary">Process</button>
		<div id="reconcileResults">

		</div>
	</div>
</div>

<script>
	viewScripts.add(function(){
		
		$("#btnReconcile").click(function(){
			var formData = formUtil.objectifyForm($("#searchTransactions"));
			formData[csvData] = $("#csvData").val();
			$.ajax({
				url: routerUtil.buildUrl('reconciler.results'),
				data: formData,
				method: 'post'
			}).done(function(results){
				$("#reconcileResults").html(results);
			});
		});

		$("#searchTransactions").submit(function(e){
			e.preventDefault();
			$.ajax({
				url: routerUtil.buildUrl('transactionSearch.getSearchResultsData'),
				type: "POST",
				dataType: "json",
				data: $("#searchTransactions").serialize()
			})
			.done(function(response){
				var $table = tableUtil.buildHtmlTable({
					data: response.transactions,
					dataType: 'object',
					class: 'table table-bordered table-sm preview-table',
					headerMap: {
						'date':'Transaction Data',
						'name' : 'Description',
						'category': 'Category',
						'amount': 'Amount'
					}
				});
				$("#searchPreview").html($table);
			});
		});
		
	});
</script>