from oct2py import octave
import pprint
import time
octave.addpath('/home/ubuntu/BaaS/BENCHOP')



def getResultBenchie():
    #res=octave.Table_task(worker,num_workers,num_solvers)
    start=time.time()
    #result1 = getResultBench.delay(1,6,3)
    res=octave.Table_task(1,6,2)
    print 'Task result1: ', res
    print time.time()-start
    start=time.time()
    #result2 = getResultBench.delay(2,6,3)
    res=octave.Table_task(2,6,2)
    print 'Task result2: ', res
    print time.time()-start
    start=time.time()
    #result3 = getResultBench.delay(3,6,3)
    res=octave.Table_task(3,6,2)
    print 'Task result3: ', res
    print time.time()-start
    start=time.time()
    #result4 = getResultBench.delay(4,6,3)
    res=octave.Table_task(4,6,2)
    print 'Task result4: ', res
    print time.time()-start
    start=time.time()
    res=octave.Table_task(5,6,2)
    #result5 = getResultBench.delay(5,6,3)
    print 'Task result5: ', res
    print time.time()-start
    start=time.time()
    res=octave.Table_task(4,6,2)
    #result6 = getResultBench.delay(6,6,3)
    print 'Task result6: ', res
    print time.time()-start
    #print 'Task result1: ', result1.get(timeout=40)
    #print 'Task result2: ', result2.get(timeout=40)
    #print 'Task result3: ', result3.get(timeout=40)
    #print 'Task result4: ', result4.get(timeout=40)
    #print 'Task result5: ', result5.get(timeout=40)
    #print 'Task result6: ', result6.get(timeout=40)

getResultBenchie()
