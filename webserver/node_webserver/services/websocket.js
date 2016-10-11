const serverSocket = require('./../webserver.js').io;
const socketRoutes = require('./socket_routes.js');

function startServerSocket() {
    serverSocket.on('connection', (clientSocket) => {
        console.log("A client connected");
        clientSocket.emit('welcome', "Hello there client");

        /**
         * Socket Routes
         */
        
        clientSocket.on('req_parse_tweets', (data) => {
            socketRoutes.socketHandler('req_parse_tweets', data,
                (count_finished) => {
                clientSocket.emit('res_parse_tweets_partial', count_finished);
            }, (final_result, timeSpent, config) => {
                    clientSocket.emit('res_parse_tweets_final', final_result, timeSpent, config);
            });
        });
    });
}

exports.startServerSocket = startServerSocket;
