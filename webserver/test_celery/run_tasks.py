from .tasks import getResultBench
import time

if __name__ == '__main__':
    result = getResultBench.delay(1,2,3)
    print 'Task result: ', result.get(timeout=40)
