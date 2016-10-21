$(document).ready(function() {

    /**
     * WEBSOCKET
     */
    
    var socket = io.connect();

    var tot_tasks = 0;
    // Setup button to send request
    $('.req_benchmark').on('click', () => {
        d3.select('svg').selectAll("*").remove();
        let num_tasks = $('input[name=tasks]:checked').val();
        tot_tasks = num_tasks;
        let num_solvers = 2;
        animateFunc(0);
        socket.emit('req_benchmark', num_tasks, num_solvers); 
    });

    socket.on('res_benchmark_partial', function (data) {
        console.log(data);
        animateFunc(data);
    //    loadGraph(data);
    })

    socket.on('res_benchmark_final', function (final_result, timeSpent, num_tasks, worker_times) {
        console.log(final_result);
        console.log(timeSpent);
        console.log(num_tasks);
	console.log(worker_times);
        addExecutionTime(timeSpent, num_tasks);
        plotting_bar(final_result, "time");
        plotting_bar(final_result, "error");
	
	plotting_scatter(worker_times);
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

 function plotting_bar(object,type) {
  
  var COS_type = 'COS ' + type;
  var FDAD_type = 'FD_AD ' + type;
  var FDNU_type = 'FD_NU ' + type;

  var trace1 = {
  x: ['European standard', 'American standard', 'Barrier standard', 'European challenging', 'American challenging', 'Barrier challenging'], 
  y: [object[COS_type]['European standard'], object[COS_type]['American standard'], object[COS_type]['Barrier standard'], object[COS_type]['European challenging'], object[COS_type]['American challenging'], object[COS_type]['Barrier challenging']],
  type: 'bar',
  name: 'COS',
  marker: {
    color: 'rgb(49,130,189)',
    opacity: 0.7
  }
};

var trace2 = {
  x: ['European standard', 'American standard', 'Barrier standard', 'European challenging', 'American challenging', 'Barrier challenging'], 
  y: [object[FDAD_type]['European standard'], object[FDAD_type]['American standard'], object[FDAD_type]['Barrier standard'], object[FDAD_type]['European challenging'], object[FDAD_type]['American challenging'], object[FDAD_type]['Barrier challenging']],
  type: 'bar',
  name: 'FDNU',
  marker: {
    color: 'rgb(204,204,204)',
    opacity: 0.5
  }
};
/*
var trace3 = {
  x: ['European standard', 'American standard', 'Barrier standard', 'European challenging', 'American challenging', 'Barrier challenging'], 
  y: [object[FDNU_type]['European standard'], object[FDNU_type]['American standard'], object[FDNU_type]['Barrier standard'], object[FDNU_type]['European challenging'], object[FDNU_type]['American challenging'], object[FDNU_type]['Barrier challenging']],
  type: 'bar',
  name: 'FD-NU',
  marker: {
    color: 'rgb(116,173,209)',
    opacity: 0.5
  }
};
*/
var data = [trace1, trace2];

var layout = {
  title: type,
  barmode: 'group'
};

var divname='myDiv ' + type;
Plotly.newPlot(divname, data, layout);

  }

  function plotting_scatter(object) {

var trace1 = {
 		x: ['1', '2', '3', '6'],
  		y: [object['workers']['w1'], object['workers']['w2'], object['workers']['w3'], object['workers']['w6']],
  		type: 'scatter'
	};
	
var layout = {
  		title: '',
  		barmode: 'group',
  		xaxis: {
    		title: 'Number of workers'
  		},
  		yaxis: {
    		title: 'Time'
  		}
	};

	var data = [trace1];

	Plotly.newPlot('myDiv scatter', data, layout);

  }


