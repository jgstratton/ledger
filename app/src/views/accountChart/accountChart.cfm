<cfparam name="rc.viewModel" required="true">

<cfoutput>
    <canvas id="canvas_#local.templateId#"></canvas>

    <script>
        viewScripts.add( function(){

            var data =  #rc.viewModel.getChartData()#;
            var color = Chart.helpers.color;

            for (var i=0; i < data.datasets.length; i++) {
                var dataset = data.datasets[i];
                var c = color(chartUtil.getRandomColor());
                dataset.backgroundColor = c.rgbString();
                dataset.borderColor = c.rgbString();
                dataset.fill = false;
            }

            var config = {
                type: 'line',
                data: data,
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
                                    fontColor: '##FF0000'
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
            };

            window.onload = function() {
                var ctx = document.getElementById('canvas_#local.templateId#').getContext('2d');
                window.myLine = new Chart(ctx, config);
            };

        });
    </script>
</cfoutput>
