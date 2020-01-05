<cfoutput>
	#includeStylesheet('reconcile.css')#
</cfoutput>

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
	<form id="spendingReportForm" method="post" style="max-width:600px" class="mb-5">  

	</form>
</div>
<br>

<div class="card">
	<div class="card-header">
	  Step 3: Reconcile!!!
	</div>
	<div class="card-body">
		<button id="btnReconcile" type="button" class="btn btn-primary">Process</button>
	</div>
</div>

<script>
	viewScripts.add(function(){
		
		$("#btnReconcile").click(function(){
			var formData = {
				accounts: '1'
			}; //$form.serialize();
			$.ajax({
				url: routerUtil.buildUrl('reconciler.reconcile'),
				data: formData
			}).done(function(results){
				console.log(results);
			});
		});
		
	});
</script>