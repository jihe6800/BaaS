$(document).ready(function() {

    /**
     * WEBSOCKET
     */
    
    var socket = io.connect('http://localhost:5000');

    var tot_tasks = 0;
    // Setup button to send request
    $('.req_benchmark').on('click', () => {
        d3.select('svg').selectAll("*").remove();
        let num_tasks = $('input[name=tasks]:checked').val();
        tot_tasks = num_tasks;
        let num_solvers = 3;
        animateFunc(0);
        socket.emit('req_benchmark', num_tasks, num_solvers); 
    });

    socket.on('res_benchmark_partial', function (data) {
        console.log(data);
        animateFunc(data);
    //    loadGraph(data);
    })

    socket.on('res_benchmark_final', function (final_result, timeSpent, num_tasks) {
        console.log(final_result);
        console.log(timeSpent);
        console.log(num_tasks);
        addExecutionTime(timeSpent, num_tasks);
        //    loadGraph(data);
    })
    /**
     * Progressbar
     *
     */
    var $topLoader = $("#topLoader").percentageLoader({
        width: 256, height: 256, progress: 0.5, onProgressUpdate: function (val) {
            this.setValue(Math.round(val * 100.0) + 'kj');
        }
    });

    var topLoaderRunning = false;
    
    /* Some browsers may load in assets asynchronously. If you are using the percentage
     * loader as soon as you create it (i.e. within the same execution block) you may want to
     * wrap it in the below `ready` function to ensure its correct operation
     */

    var finished_tasks = 0;
    var animateFunc = function (finished_tasks) {
        $topLoader.percentageLoader({progress: finished_tasks / tot_tasks});
        $topLoader.percentageLoader({value: (finished_tasks.toString() + '/' + tot_tasks + ' finished_tasks')});

        if (finished_tasks < tot_tasks) {
            //setTimeout(animateFunc, 250);
        } else {
            topLoaderRunning = false;
        }
    };
    $topLoader.percentageLoader({onready: function () {
        $("#animateButton").click(function () {
            if (topLoaderRunning) {
                return;
            }
            topLoaderRunning = true;


            //setTimeout(animateFunc, 25);
        });

    }});
});


function addExecutionTime(timeSpent, config) {
    let date = new Date();
    let pElement = $('<p>', { 
        text: `Benchmark result: ${config.num_tweet_chunks} tweet chunks, ${config.num_workers} workers, ${config.concurrency} num concurrency: ${timeSpent}   (${date})`
    });
   $('.execution-time').append(pElement);
}

function loadGraph(data) {
    var x_axis = [];
    var y_axis = [];
    var new_data = [];
    i = 0;
    for (var key in data) {
        if (data.hasOwnProperty(key)) {
            x_axis.push(key);
            y_axis.push(data[key]);
            new_data[i] = {"letter": key, "frequency": data[key]};
            i++;
        }
    }
    data2 = {x_axis, y_axis}
    console.log(x_axis);
    console.log(y_axis);


    var svg = d3.select("svg"),
        margin = {top: 20, right: 20, bottom: 30, left: 40},
        width = +svg.attr("width") - margin.left - margin.right,
        height = +svg.attr("height") - margin.top - margin.bottom;

    var x = d3.scaleBand().rangeRound([0, width]).padding(0.1),
        y = d3.scaleLinear().rangeRound([height, 0]);

    var g = svg.append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    x.domain(x_axis.map(function (d) {
        return d;
    }));
    y.domain([0, d3.max(new_data, function (d) {
        console.log(d);
        return d.frequency;
    })]);

    g.append("g")
        .attr("class", "axis axis--x")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x));

    g.append("g")
        .attr("class", "axis axis--y")
        .call(d3.axisLeft(y).ticks())
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", "0.71em")
        .attr("text-anchor", "end")
        .text("Frequency");

    g.selectAll(".bar")
        .data(new_data)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function (d) {
            return x(d.letter);
        })
        .attr("y", function (d) {
            console.log(d.frequency);
            return y(d.frequency);
        })
        .attr("width", x.bandwidth())
        .attr("height", function (d) {
            return height - y(d.frequency);
        });
}
