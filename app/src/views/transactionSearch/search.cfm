<cfoutput>
	<cfset local.elementIds = {
		searchTab: "searchTab" & local.templateId,
		resultsTab: "resultsTab" & local.templateId,
		resultsDiv: "resultsDiv" & local.templateId
	}>

	<h4 class="mb-4"><i class="fa fa-search"></i> Search Checkbook Transactions</h4>

	<ul class="nav nav-tabs">
		<li class="nav-item">
			<a class="nav-link active" data-toggle="tab" href="###local.elementIds.searchTab#">Search</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" data-toggle="tab" href="###local.elementIds.resultsDiv#" id="#local.elementIds.resultsTab#">Results</a>
		</li>
		<!---
		<li class="nav-item">
			<span class="nav-link  #matchDisplay(getItem(),'edit','active','disabled')#">Edit</span>
		</li>
	--->
	</ul>
	<div class="tab-content">
		<div class="tab-pane fade show active" id="#local.elementIds.searchTab#" role="tabpanel" aria-labelledby="home-tab">
			#view("transactionSearch/_searchForm",{
				elementIds: local.elementIds
			})#
		</div>
		<div class="tab-pane fade"  id="#local.elementIds.resultsDiv#" role="tabpanel" aria-labelledby="profile-tab">
			<span class="text-muted">(use the form to submit your search results)</span>
		</div>
		<div class="tab-pane fade" id="edit" role="tabpanel" aria-labelledby="contact-tab">...</div>
	</div>

	<script>
		viewScripts.add( function(){
			$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
				$($.fn.dataTable.tables(true)).DataTable()
					.columns.adjust()
					.responsive.recalc();
			});
		});
	</script>

</cfoutput>