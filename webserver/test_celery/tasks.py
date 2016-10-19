from __future__ import absolute_import
from test_celery.celery import app
import time
from oct2py import octave
import pprint
octave.addpath('/Users/majaengvall/Documents/Cloud computing/Project/BaaS/BENCHOP/')


@app.task
def getResultBench(worker,num_workers,num_solvers):
    res=octave.Table_task(worker,num_workers,num_solvers)
    print res
    return res 


