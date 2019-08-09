
<cfoutput>
   
        <canvas id="canvas_#local.templateId#"></canvas>
    
<script>
viewScripts.add( function(){

    var data =  [
                    <cfloop array="#rc.chartData#" index="col">
                        {t: '#col.x#', y:#col.y#},
                    </cfloop>
                ];

    function newDate(days) {
        return moment().add(days, 'd').toDate();
    }

    function newDateString(days) {
        return moment().add(days, 'd').format();
    }

    var color = Chart.helpers.color;
    var c = color(chartUtil.getRandomColor());
    var config = {
        type: 'line',
        data: {
            datasets: [{
                label: 'Account Name',
                backgroundColor: c.rgbString(),
                borderColor: c.rgbString(),
                fill: false,
                data: data,
            }]
        },
        options: {
            responsive: true,
            title: {
                display: true,
                text: 'Chart.js Time Point Data'
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
