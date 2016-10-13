const zeroRpcClient = require('./zerorpc').zeroRpcClient;
const request = require('request');
const bash_commands = require('./bash_commands/bash_commands.js')

function socketHandler(eventType, data, callback1, callback2) {
    switch (eventType) {
        case "req_becnhmark":
            return req_parse_tweets(eventType, data, callback1, callback2);
            break;
        default:
            return std_response(eventType, data);
    }
}

function std_response(eventType, data) {
    console.log(`Client sent event: ${eventType}, with data: ${data}`);
    let response = `Hello ${data.name}!`;
    return response;
}

function req_benchmark(eventType, data, callback1, callback2) {
    console.log(`Client sent event: ${eventType}`);
    let count_finished = 0;
    let final_result;

    // Check how many celery workers that are running

    var begin=Date.now();
    zeroRpcClient.invoke("req_benchmark", data.num_workers, function(error, res) {
        final_result = count_finished === 0 ? res : final_result;
        count_finished++;
        callback1(count_finished);
        for (var key in res) {
            if (res.hasOwnProperty(key)) {
                final_result[key] = final_result[key] + res[key];
            }
        }
        if(count_finished === parseInt(data.num_workers)) {
            var end=Date.now();
            var timeSpent=(end-begin)/1000+"secs";
            callback2(final_result, timeSpent, data);
        }
    });
}


exports.socketHandler = socketHandler;
