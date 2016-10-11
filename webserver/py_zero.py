import zerorpc
from proj.tasks import getCountFile
import json

class HelloRPC(object):
    def req_parse_tweets(self, data_name):
        path = "./proj/twitter_data/" + data_name
        print data_name
        print path
        result = getCountFile.delay(path)
        result = result.get(timeout=40)
        return result

s = zerorpc.Server(HelloRPC())
s.bind("tcp://0.0.0.0:4242")
s.run()
