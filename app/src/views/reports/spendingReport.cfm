<cfparam name="rc.viewModel" required="true">
<cfoutput>
	<h4 class="mb-4"><i class="fas fa-file-contract"></i> Spending Report</h4>

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
				<button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-check"></i> Update Report</button>
			</div>
		</div>
	</form>
	<div class="row">
		<div class="col-6">
			<table id="spendingReportTable" class="table">
				<thead>
					<tr>
						<th>Category</th>
						<th>Transactions</th>
						<th class="text-right">Total</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		<div class="col-6">
			<canvas></canvas>
		</div>
	</div>

</cfoutput>

<script>
	viewScripts.add( function(){
		var templateId = '<cfoutput>#local.templateId#</cfoutput>';
		var $templateDiv = $("#" + templateId);
		var $reportTable = $templateDiv.find("#spendingReportTable");

		var $canvas = $templateDiv.find('canvas');
		var $form = $templateDiv.find('form');
		var $multiSelects = $templateDiv.find("[data-multiselect]");
		var color = Chart.helpers.color;
		var $submitBtn = $form.find("button[type='submit']");

		var chart = new Chart($canvas, {
			type: 'pie',
			data: {},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				title: {
					display: true,
					text: 'Spending Summary'
				},
				tooltips: {
					callbacks: {
						// this callback is used to create the tooltip label
						label: function(tooltipItem, data) {
							var amount = htmlFormatMoney(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]);
							var label = data.labels[tooltipItem.index];

							return label + ": " + amount;
						}
					}
				}
			}
		});
		
		$form.submit(function(e){
			startSpinner();
			getReportData();
			return false;
		});

		$multiSelects.multipleSelect();
		
		function getReportData() {
			var formData = $form.serialize();
			$.ajax({
				url: routerUtil.buildUrl('reports.getSpendingReportData'),
				type: "POST",
				dataType: "json",
				data:formData
			})
			.done(function(reportData){
				var chartData = getChartDataFromReportData(reportData);
				console.log(chartData);
				populateReport(reportData);
				setDatasetColors(chartData);
				chart.data = chartData;
				chart.update();
				stopSpinner();     
			})
			.fail(function(a, b){
				$("body").append(a.responseText);
			});
		}

		function populateReport(reportData) {
			var $tbody = $reportTable.find('tbody');
			$tbody.html('');
			for (var i=0; i<reportData.length; i++) {
				$tbody.append(`
					<tr>
						<td>${reportData[i].category_name}</td>
						<td>${reportData[i].recordCount}</td>
						<td class="text-right">${htmlFormatMoney(reportData[i].total)}</td>
					</tr>
				`);
			}
		}
		function getChartDataFromReportData(reportData) {
			var chartData = {
				'datasets' : [{data:[]}],
				'labels' : []
			};
			for (var i=0; i<reportData.length; i++) {
				chartData.datasets[0].data.push(reportData[i].total);
				chartData.labels.push(reportData[i].category_name);
			}
			console.log(chartData);
			return chartData;
		}

		function setDatasetColors(data) {
			var dataset = data.datasets[0];
			data.datasets[0].backgroundColor = [];
			for (var i=0; i < data.datasets[0].data.length; i++) {
				var c = color(chartUtil.getRandomColor());
				data.datasets[0].backgroundColor.push(c.rgbString());
				//dataset.borderColor = c.rgbString();
				//dataset.fill = false;
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

		getReportData();
	});
</script>
