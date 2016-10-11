const zeroRpcClient = require('./zerorpc').zeroRpcClient;
const request = require('request');
const bash_commands = require('./bash_commands/bash_commands.js')

function socketHandler(eventType, data, callback1, callback2) {
   switch (eventType) {
       case "req_parse_tweets":
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

function req_parse_tweets(eventType, data, callback1, callback2) {
    console.log(`Client sent event: ${eventType}`);
    let count_finished = 0;
    let final_result;
    request('http://130.238.29.253:8080/swift/v1/john_ass3_files/', function (error, response, body) {
        if (!error && response.statusCode == 200) {
            let tweet_name_array = body.split(/\r?\n/);
            bash_commands.start_celery_workers(data.num_workers, data.concurrency, () => {
            for(let i = 0; i < data.num_tweet_chunks; i++) {
                    var begin=Date.now();
                    zeroRpcClient.invoke("req_parse_tweets", tweet_name_array[i], function(error, res) {
                        final_result = count_finished === 0 ? res : final_result;
                        count_finished++;
                        callback1(count_finished);
                        for (var key in res) {
                            if (res.hasOwnProperty(key)) {
                                final_result[key] = final_result[key] + res[key];
                            }
                        }
                        if(count_finished === parseInt(data.num_tweet_chunks)) {
                            var end=Date.now();
                            var timeSpent=(end-begin)/1000+"secs";
                            bash_commands.stop_celery_workers(() => {
                                callback2(final_result, timeSpent, data);
                            });
                        }
                });
            }
            });
        }
    })

}


exports.socketHandler = socketHandler;
