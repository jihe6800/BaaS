import zerorpc
from local_celery.tasks import getResultBench
import json

class HelloRPC(object):
    
    def req_benchmark(self, num_workers, num_solvers): 
        print "Number of tasks: " + str(num_workers) + " | Number of solvers: " + str(num_solvers)
        result = [None] * 6
        for i in range (int(num_workers)):
            print "sending this to octave: " + str((i+1)) + " " + str(num_workers) + " " + str(num_solvers)
            result[i] = getResultBench.delay(int(i+1), int(num_workers), int(num_solvers)) 
            print "sent away work to worker: " + str(i+1)
        for i in range (int(num_workers)):
            print "waiting on worker: " + str(i+1)
            result[i] = result[i].get(timeout=4000)
        print "DONE"
        return result

s = zerorpc.Server(HelloRPC())
s.bind("tcp://0.0.0.0:4242")
print "zerorpc running"
s.run()
