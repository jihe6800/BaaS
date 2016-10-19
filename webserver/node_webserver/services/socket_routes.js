const zeroRpcClient = require('./zerorpc').zeroRpcClient;
const request = require('request');
const bash_commands = require('./bash_commands/bash_commands.js')

function req_benchmark(num_tasks, num_solvers, callback1, callback2) {
    const test_data = {
        solver: {
            cos: {
                problem_1: {
                    error: 0,
                    time: 0,
                },
                problem_2: {
                    error: 0,
                    time: 0,
                },
                problem_3: {
                    error: 0,
                    time: 0,
                },
                problem_4: {
                    error: 0,
                    time: 0,
                },
                problem_5: {
                    error: 0,
                    time: 0,
                },
                problem_6: {
                    error: 0,
                    time: 0,
                },
            },
            fd: {
                problem_1: {
                    error: 0,
                    time: 0,
                },
                problem_2: {
                    error: 0,
                    time: 0,
                },
                problem_3: {
                    error: 0,
                    time: 0,
                },
                problem_4: {
                    error: 0,
                    time: 0,
                },
                problem_5: {
                    error: 0,
                    time: 0,
                },
                problem_6: {
                    error: 0,
                    time: 0,
                },
            },
        }
    }

    let count_finished = 0;
    let final_result;
    // Check how many celery workers that are running
    var begin=Date.now();
    let worker = 0;
    for(let i = 0; i < num_tasks; i++) {
        //zeroRpcClient.invoke("req_benchmark", i, num_tasks, num_solvers, test_data, function(error, res) {
        zeroRpcClient.invoke("req_benchmark", 3, function(error, res) {
            final_result = count_finished === 0 ? res : final_result;
            count_finished++;
            callback1(count_finished);
            /*for (var key in res) {
                if (res.hasOwnProperty(key)) {
                    final_result[key] = final_result[key] + res[key];
                }
            }*/
            if(count_finished === parseInt(num_tasks)) {
                var end=Date.now();
                var timeSpent=(end-begin)/1000+"secs";
                callback2(final_result, timeSpent, num_tasks);
            }
        });
    }
}


exports.req_benchmark = req_benchmark;
