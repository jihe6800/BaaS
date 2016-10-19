from __future__ import absolute_import
from local_celery.celery import app
import time
from oct2py import octave
import pprint
octave.addpath('/home/dinotrainer/progs/applied_cloud/BaaS/BENCHOP')

@app.task
def getResultBench(worker,num_workers,num_solvers):
    print "got task"
    res=octave.Table_task(worker,num_workers,num_solvers)
    print res
    fake_res = [1,2,3,4,5]
    return fake_res 


