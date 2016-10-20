import zerorpc
from local_celery.tasks import getResultBench
import json

class HelloRPC(object):
    def req_benchmark(self, worker, num_workers, num_solvers):
         
        print "Worker number: " + str(worker) + " | Number of tasks: " + str(num_workers) + " | Number of solvers: " + str(num_solvers)
        result = getResultBench.delay(int(worker), int(num_workers), int(num_solvers))
        result = result.get(timeout=4000)
        return result

s = zerorpc.Server(HelloRPC())
s.bind("tcp://0.0.0.0:4242")
print "zerorpc running"
s.run()
