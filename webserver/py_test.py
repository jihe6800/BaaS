import zerorpc

class HelloRPC(object):
    def req_benchmark(self, worker, num_tasks, num_solvers, data):
        print worker
        print num_tasks
        print num_solvers
        print data
        return data

s = zerorpc.Server(HelloRPC())
s.bind("tcp://0.0.0.0:4242")
s.run()
