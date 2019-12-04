<cfoutput>
	<div class="table-wrap" style="display:none">
		<div class="data-table"></div>
		<table class="table" style="width:100%">
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
					columns:[
						{ data: 'date' },
						{ data: "name" },
						{ data: "account" },
						{ data: "note" },
						{ data: "category" },
						{ data: "amount" },
					],
					columnDefs: [
						{ defaultContent: "-", targets: "_all" },
						{ type: "date", targets: 0 },
						{ responsivePriority: 1, targets: 0 },
						{ responsivePriority: 3, targets: 1 },
						{ responsivePriority: 2, targets: -1 },
						{ 
							targets: -1,
							className: "text-right", 
							responsivePriority: 2,
							render:  function ( data, type, row, meta ) {
								return formatUtil.htmlFormatMoney(data, true);
							}
						},
					]
				});

				this.loadData = function(searchParams) {

					$.ajax({
						url: routerUtil.buildUrl('transactionSearch.getSearchResultsData'),
						type: "POST",
						dataType: "json",
						data: searchParams
					})
					.done(function(response){
						self.dataTable.clear();
						self.dataTable.rows.add(response.transactions);
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