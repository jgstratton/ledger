<cfoutput>
	#includeStylesheet('reconcile.css')#
	#includeScript('csvReader.js')#
	#includeScript('tableUtil.js')#
</cfoutput>

<h4 class="mb-4"><i class="fas fa-fw fa-clipboard-check"></i> Reconcile Account with External Transaction File</h4>

<div class="card">
	<div class="card-header">
		Step 1: Upload File for Comparison
	  </div>
	  <div class="card-body">
		  <p>
			  The csv must have the following columns in order to reconcile the transactions against the account:
			  <ul>
				  <li>Transaction Date</li>
				  <li>Description</li>
				  <li>Category</li>
				  <li>Amount</li>
			  </ul>
		  </p>
		  <button class="btn btn-sm btn-primary" id="btnTrigger">
			  Upload CSV File
		  </button>
		  <input type="file" id="btnUpload" value="Upload CSV File" hidden>
		  <div id="preview">

		  </div>
	  </div>
</div>
<br>
<div class="card">
	<div class="card-header">
	  Step 2: Search for checkbook transactions
	</div>

</div>
<br>

<div class="card">
	<div class="card-header">
	  Step 3: Reconcile!!!
	</div>
	Reconcile button here.
</div>

<script>
	viewScripts.add( function(){
		var ledger2 = [];

		$("#btnTrigger").click(function(){
			$('#btnUpload').trigger('click');
		})

		var csvReader = new CsvReader({
			buttonSelector: '#btnUpload',
			afterFileRead: function(){
				$results = tableUtil.buildHtmlTable({
					data: csvReader.getData().data,
					headers: csvReader.getData().headings,	
				});
				$("#preview").append($results);
			}
		});
		csvReader.initialize();

		var buil = function() {

		}
	});
</script>