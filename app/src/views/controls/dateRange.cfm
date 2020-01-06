<cfparam name="local.startDateInput" required="true">
<cfparam name="local.endDateInput" required="true">

<cfoutput>
	<input
		id="dateInput#local.templateid#"
		type="text" 
		value="" 
		class="form-control form-control-sm" 
		data-daterange 
		data-input-start="#local.startDateInput.getName()#"
		data-input-end="#local.endDateInput.getName()#">
	<input 
		type="hidden" 
		name="#local.startDateInput.getName()#" 
		value="#local.startDateInput.getFormattedValue()#" 
		class="form-control form-control-sm">
	<input 
		type="hidden" 
		name="#local.endDateInput.getName()#" 
		value="#local.endDateInput.getFormattedValue()#" 
		class="form-control form-control-sm">

	<script>
		(function(){
			var $input = $("##dateInput#local.templateid#");
			var $inputStart = $("[name='" + $(this).data('inputStart') + "']");
			var $inputEnd = $("[name='" + $(this).data('inputEnd') + "']");

			$input.daterangepicker({
				startDate: $inputStart.val(),
				endDate: $inputEnd.val(),
				ranges: {
					'Last 30 Days': [moment().subtract(29, 'days'), moment()],
					'1 Year': [moment().subtract(365, 'days'), moment()],
					'3 Years': [moment().subtract(365*3, 'days'), moment()],
					'5 Years': [moment().subtract(365*5, 'days'), moment()],
					'10 Years': [moment().subtract(365*10, 'days'), moment()]
				}
			}).on('apply.daterangepicker', function(event, picker) {
				$inputStart.val(picker.startDate.format('MM/DD/YYYY'));
				$inputEnd.val(picker.endDate.format('MM/DD/YYYY'));
			});
		})();
		
	</script>
</cfoutput>
