<cfparam name="rc.viewModel" required="true">
<cfoutput>
	<h4 class="mb-4"><i class="fa fa-line-chart"></i> Spending Report</h4>

	<form id="spendingReportForm" method="post" style="max-width:600px" class="mb-5">       
		<div class="row">
			<label class="col-3 col-form-label">Accounts:</label>
			<div class="col-9">
				<cfset input = rc.viewModel.getAccounts()>
				<select name="#input.getName()#" class="form-control form-control-sm" multiple="multiple" data-multiselect>
					<cfloop array="#input.getOptions()#" item="option">
						<option value="#option.value#" #matchSelect(option.value, input.getValue())#>
							#option.text#
						</option>
					</cfloop>
				</select>   
			</div>
		</div>
		<div class="row">
			<label class="col-3 col-form-label">Date Range:</label>
			<div class="col-9">
				<cfset startDateInput = rc.viewModel.getStartDate()>
				<cfset endDateInput = rc.viewModel.getEndDate()>
				<input 
					type="text" 
					value="" 
					class="form-control form-control-sm" 
					data-daterange 
					data-input-start="#startDateInput.getName()#"
					data-input-end="#endDateInput.getName()#">
				<input type="hidden" name="#startDateInput.getName()#" value="#startDateInput.getFormattedValue()#" class="form-control form-control-sm">
				<input type="hidden" name="#endDateInput.getName()#" value="#endDateInput.getFormattedValue()#" class="form-control form-control-sm">
			</div>
		</div>
		<div class="row">
			<div class="col-3"></div>
				<div class="col-4">
				<div class="form-check">
					<cfset input = rc.viewModel.getIncludeLinked()>
					<input class="form-check-input" type="checkbox" value="1" name="#input.getName()#">
					<label class="form-check-label" for="#input.getName()#">
						Include Linked
					</label>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-9 offset-3">
				<button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-check"></i> Update Chart</button>
			</div>
		</div>
	</form>
<canvas></canvas>

</cfoutput>

<script>
    viewScripts.add( function(){
        var templateId = '<cfoutput>#local.templateId#</cfoutput>';
        var $templateDiv = $("#" + templateId);
        var $canvas = $templateDiv.find('canvas');
        var $form = $templateDiv.find('form');
        var $multiSelects = $templateDiv.find("[data-multiselect]");
        var color = Chart.helpers.color;
        var $submitBtn = $form.find("button[type='submit']");

       

        $form.submit(function(e){
            startSpinner();
            getChartData();
            return false;
        });

        $multiSelects.multipleSelect();
        
        function getChartData() {
            var formData = $form.serialize();
            $.ajax({
                url: routerUtil.buildUrl('reports.getChartData'),
                type: "POST",
                dataType: "json",
                data:formData
            })
            .done(function(chartData){
                setDatasetColors(chartData);
                chart.data = chartData;
                chart.update();
                stopSpinner();     
            })
            .fail(function(a, b){
                $("body").append(a.responseText);
            });
        }

        function setDatasetColors(data) {
            for (var i=0; i < data.datasets.length; i++) {
                var dataset = data.datasets[i];
                var c = color(chartUtil.getRandomColor());
                dataset.backgroundColor = c.rgbString();
                dataset.borderColor = c.rgbString();
                dataset.fill = false;
            }
        }

        $("[data-daterange]").each(function(){
            var $inputStart = $("[name='" + $(this).data('inputStart') + "']");
            var $inputEnd = $("[name='" + $(this).data('inputEnd') + "']");

            $("[data-daterange]").daterangepicker({
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

        });

        function startSpinner() {
            $submitBtn.prop('disabled',true);
            $submitBtn.find('i').addClass('fa-spinner fa-spin').removeClass('fa-check');
        }

        function stopSpinner() {
            $submitBtn.prop('disabled',false);
            $submitBtn.find('i').removeClass('fa-spinner fa-spin').addClass('fa-check');
        }

        getChartData();
    });
</script>
