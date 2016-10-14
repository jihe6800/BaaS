var util = require('util')
var exec = require('child_process').exec;
var child;
// executes `pwd`

function start_python() {
    process.chdir(__dirname);
    process.chdir('./../../../');
    child = exec(`python py_test.py`, function (error, stdout, stderr) {
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        if (error !== null) {
            console.log('exec error: ' + error);
        }
    });
};

function start_celery_workers(num_workers, concurrency, callback) {
    process.chdir(__dirname);
    child = exec(`bash start_celery ${num_workers} ${concurrency}`, function (error, stdout, stderr) {
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        callback();
        if (error !== null) {
            console.log('exec error: ' + error);
        }
    });
};

function stop_celery_workers(callback) {
    child = exec("bash stop_celery", function (error, stdout, stderr) {
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        callback();
        if (error !== null) {
            console.log('exec error: ' + error);
        }
    });
};

exports.start_celery_workers = start_celery_workers;
exports.stop_celery_workers = stop_celery_workers;
exports.start_python = start_python;
