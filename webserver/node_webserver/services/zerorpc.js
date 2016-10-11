const zerorpc = require('zerorpc');
let client = new zerorpc.Client();
function startZerorpc() {
    client.connect('tcp://127.0.0.1:4242');
}

exports.startZerorpc = startZerorpc;
exports.zeroRpcClient = client;
