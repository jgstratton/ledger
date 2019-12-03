<cfoutput>
	<div class="table-wrap" style="display:none">
		<table class="table">
			<col style="width:20px">
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
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>         
					<td class="text-right"></td>
				</tr>
			</tbody>
		</table>
	</div>

	<script>
		viewScripts.add( function(){
			window.TransactionList = function(settings){
				var self = this;

				const defaultSettings = {
					parentSelector: 'body',
					url: '',
					searchData: {}
				};

				for (var prop in defaultSettings) {
					this[prop] = settings.hasOwnProperty(prop) ? settings[prop] : defaultSettings[prop];
				}

				this.$tableWrap = $(this.parentSelector).find(".table-wrap");

				//initialize
				this.dataTable = $(this.parentSelector).find('table').DataTable({
					searching: false,
					paging:true,
					responsive: true,
					columnDefs: [
						{ responsivePriority: 1, targets: 0 },
						{ responsivePriority: 2, targets: -1 },
						{ responsivePriority: 3, targets: 1 }
					]
				});

				this.loadData = function(searchParams) {

					$.ajax({
						url: routerUtil.buildUrl('transactionSearch.getSearchResultsData'),
						type: "POST",
						dataType: "json",
						data: searchParams
					})
					.done(function(transactionData){
						self.dataTable.clear();
						self.dataTable.rows.add(transactionData);
						self.dataTable.draw();
						self.$tableWrap.show();  
					})
					.fail(function(a, b){
						$("body").append(a.responseText);
					});
					
				}
			};
		}, 'transaction._list');
	</script>
</cfoutput>