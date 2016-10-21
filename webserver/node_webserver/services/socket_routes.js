const zeroRpcClient = require('./zerorpc').zeroRpcClient;
const request = require('request');
const bash_commands = require('./bash_commands/bash_commands.js')

var fs = require('fs');


function req_benchmark(num_tasks, num_solvers, callback1, callback2) {
    let count_finished = 0;
    let final_result = {};
    var worker_times = require('./worker_json.json');
    var begin=Date.now();
    
        console.log('sent tasks');
        zeroRpcClient.invoke("req_benchmark", num_tasks, num_solvers, function(error, res) {
       // zeroRpcClient.invoke("req_benchmark", 3, function(error, res) {
//            final_result = count_finished === 0 ? res : final_result;
 //           count_finished++;
  //          callback1(count_finished);              
	    if(!error) {
            final_result = res[0];
}
            for(var i = 1; i < res.length; i++) {

                for (var key in res[i]) {
                if (res[i].hasOwnProperty(key)) {
                    for(var key2 in res[i][key]) {
                       final_result[key][key2] += res[i][key][key2];
                }
            }
            }
        }
          //  if(count_finished === parseInt(num_tasks)) {
                var end=Date.now();
		var timeSpentFloat = (end-begin)/1000;
                var timeSpent=(end-begin)/1000+"secs";

console.log(worker_times.workers);
		worker_times.workers["w" + num_tasks.toString()] = timeSpentFloat;	

fs.writeFile("./services/worker_json.json", JSON.stringify(worker_times), function(err) {
    if(err) {
        return console.log(err);
    }

    console.log("The file was saved!");
}); 
                callback2(final_result, timeSpent, worker_times);
           // }
        });
}


exports.req_benchmark = req_benchmark;
