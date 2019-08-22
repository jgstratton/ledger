<cfparam name="rc.viewModel" required="true">
<cfoutput>
    <h4 class="mb-4"><i class="fa fa-line-chart"></i> Account Balance</h4>

    <form id="accountChartForm" method="post" style="max-width:600px" class="mb-5">     
        <div class="row">
            <label class="col-3 col-form-label">Trailing Average:</label>
            <div class="col-9">
                <cfset input = rc.viewModel.getTrailingAverage()>
                <select name="#input.getName()#" class="form-control form-control-sm">
                    <cfloop array="#input.getOptions()#" item="option">
                        <option value="#option.value#" #matchSelect(option.value, input.getValue())#>
                            #option.text#
                        </option>
                    </cfloop>
                </select>   
            </div>
        </div>   
        <div class="row">
            <label class="col-3 col-form-label">Density:</label>
            <div class="col-9">
                <cfset input = rc.viewModel.getDensity()>
                <select name="#input.getName()#" class="form-control form-control-sm">
                    <cfloop array="#input.getOptions()#" item="option">
                        <option value="#option.value#" #matchSelect(option.value, input.getValue())#>
                            #option.text#
                        </option>
                    </cfloop>
                </select>   
            </div>
        </div> 
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
       
        var chart = new Chart($canvas, {
            type: 'line',
            data: {},
            options: {
                responsive: true,
                title: {
                    display: true,
                    text: 'Account Balance History'
                },
                scales: {
                    xAxes: [{
                        type: 'time',
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: 'Date'
                        },
                        ticks: {
                            major: {
                                fontStyle: 'bold',
                                fontColor: '#FF0000'
                            }
                        }
                        
                    }],
                    yAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: 'Account Balance'
                        },
                        ticks: {
                            callback: function(label, index, labels) {
                                return '$' + dateUtil.numberWithCommas(label);
                            }
                        }
                    }]
                }
            }
        });

        $form.submit(function(e){
            getChartData();
            return false;
        });

        $multiSelects.multipleSelect();
        
        function getChartData() {
            var formData = $form.serialize();
            $.ajax({
                url: routerUtil.buildUrl('accountChart.getChartData'),
                type: "POST",
                dataType: "json",
                data:formData
            })
            .done(function(chartData){
                setDatasetColors(chartData);
                chart.data = chartData;
                chart.update();
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

        getChartData();
    });
</script>
