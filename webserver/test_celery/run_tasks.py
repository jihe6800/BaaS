from .tasks import getResultBench
import time

if __name__ == '__main__':
    start=time.time()
    result1 = getResultBench.delay(1,6,2)
    print 'Task result1: ', result1.get(timeout=40)
    print time.time()-start
    start=time.time()
    result2 = getResultBench.delay(2,6,2)
    print 'Task result2: ', result2.get(timeout=40)
    print time.time()-start
    start=time.time()
    result3 = getResultBench.delay(3,6,2)
    print 'Task result3: ', result3.get(timeout=40)
    print time.time()-start
    start=time.time()
    result4 = getResultBench.delay(4,6,2)
    print 'Task result4: ', result4.get(timeout=75)
    print time.time()-start
    start=time.time()
    result5 = getResultBench.delay(5,6,2)
    print 'Task result5: ', result5.get(timeout=40)
    print time.time()-start
    start=time.time()
    result6 = getResultBench.delay(6,6,2)
    print 'Task result6: ', result6.get(timeout=40)
    print time.time()-start
    #print 'Task result1: ', result1.get(timeout=40)
    #print 'Task result2: ', result2.get(timeout=40)
    #print 'Task result3: ', result3.get(timeout=40)
    #print 'Task result4: ', result4.get(timeout=40)
    #print 'Task result5: ', result5.get(timeout=40)
    #print 'Task result6: ', result6.get(timeout=40)
