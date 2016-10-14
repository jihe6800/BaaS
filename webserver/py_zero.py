import zerorpc
from proj.tasks import getCountFile
import json

class HelloRPC(object):
    def req_benchmark(self, num_workers):
        print num_workers
        result = getBenchmark.delay(num_workers)
        result = result.get(timeout=40)
        return result

s = zerorpc.Server(HelloRPC())
s.bind("tcp://0.0.0.0:4242")
s.run()
