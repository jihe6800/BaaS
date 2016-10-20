const serverSocket = require('./../webserver.js').io;
const socketRoutes = require('./socket_routes.js');

function startServerSocket() {
    serverSocket.on('connection', (clientSocket) => {
        console.log("A client connected");
        clientSocket.emit('welcome', "Hello there client");

        /**
         * Socket Routes
         */
        
        clientSocket.on('req_benchmark', (num_tasks, num_solvers) => {
            socketRoutes.req_benchmark(num_tasks, num_solvers,
                (count_finished) => {
                clientSocket.emit('res_benchmark_partial', count_finished);
            }, (final_result, timeSpent) => {
                    clientSocket.emit('res_benchmark_final', final_result, timeSpent, num_tasks);
            });
        });
    });
}

exports.startServerSocket = startServerSocket;
