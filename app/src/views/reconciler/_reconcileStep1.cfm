<cfparam name="local.csvDataInputId" required="true">

<cfoutput>
	#includeStylesheet('reconcile.css')#
	#includeScript('csvReader.js')#
	#includeScript('tableUtil.js')#
</cfoutput>

<div class="row">
	<div class="col-6">
		<p>
			The csv must have the following columns in order to reconcile the transactions against the account:
			<ul>
				<li>ID</li>
				<li>Transaction Date</li>
				<li>Description</li>
				<li>Amount</li>
				<li>Category</li>
			</ul>
		</p>
	</div>
	<div id="fileResults" class="col-6">
		
	</div>
</div>
	
<button class="btn btn-sm btn-primary" id="btnTrigger">
	Upload CSV File
</button>
<input type="file" id="btnUpload" value="Upload CSV File" hidden>

<div class="preview-box-wrap">
	<div id="filePreview" class="preview-box">
	</div>
</div>



<script>
	viewScripts.add( function(){
		var csvData = {};
		var $csvInput = $("#<cfoutput>#local.csvDataInputId#</cfoutput>");
		 
		$("#btnTrigger").click(function(){
			$('#btnUpload').trigger('click');
		})

		var csvReader = new CsvReader({
			buttonSelector: '#btnUpload',
			afterFileRead: function(){
				csvData = csvReader.getData();
				var $table = tableUtil.buildHtmlTable({
					data: csvData.data,
					headers: csvData.headers,
					class: 'table table-bordered table-sm preview-table'	
				});
				$("#filePreview").html($table);
				validateUpload();
			}
		});
		csvReader.initialize();

		var validateUpload = function() {
			var results = {
				errors: []
			};
			if (csvData.headers.length != 5) {
				results.errors.push('Invalid number of columns');
			}
			displayUploadResults(results);
			$csvInput.val( results.errors.length ? '' : JSON.stringify(csvData));
		}

		var displayUploadResults = function(results) {
			if (results.errors.length) {
				$("#fileResults").html(`
					<div class='alert alert-warning'>
						Please correct the following errors in your upload:
						<ul>
							${results.errors.map(function(item){
								return `<li>${item}</li>`;
							}).join("")}
						</ul>
					</div>
				`);
				return;
			}
			$("#fileResults").html(`
				<div class='alert alert-success'>
					<i class="fa fa-check"></i> Upload Successful
				</div>
			`);
		}
	});
</script>