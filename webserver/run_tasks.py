import zerorpc
from local_celery.tasks import getResultBench
import json

class HelloRPC(object):
    def req_benchmark(self, worker, num_workers, num_solvers):
        print num_workers
        result = getResultBench.delay(1,2,3)
        result = result.get(timeout=4000)
        return result

s = zerorpc.Server(HelloRPC())
s.bind("tcp://0.0.0.0:4242")
print "zerorpc running"
s.run()
