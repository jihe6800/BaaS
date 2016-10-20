from __future__ import absolute_import
from local_celery.celery import app
import time
from oct2py import octave
import pprint
octave.addpath('/home/dinotrainer/progs/applied_cloud/BaaS/BENCHOP')

@app.task
def getResultBench(worker,num_workers,num_solvers):
    res=octave.Table_task(worker,num_workers,num_solvers)
    
    plotVariables = {'COS error': None, 'FD_AD error': None, 'FD_NU error' : None, 'COS time' : None, 'FD_AD time' : None, 'FD_NU time' : None}

    labels = ['European standard', 'American standard', 'Barrier standard', 'European challenging', 'American challenging', 'Barrier challenging']

    for num in range(len(res)):
        jsonTime = {'European standard' : None, 'American standard' : None, 'Barrier standard' : None, 'European challenging' : None, 'American challenging' : None, 'Barrier challenging' : None}
        jsonError = {'European standard' : None, 'American standard' : None, 'Barrier standard' : None, 'European challenging' : None, 'American challenging' : None, 'Barrier challenging' : None}
        counterTime = 0
        counterError = 0
        for pos in range(len(res[num])):
            if(pos%2 == 0):
                jsonTime[labels[counterTime]] = res[num][pos]
                counterTime += 1
            else:
                jsonError[labels[counterError]] = res[num][pos]
                counterError += 1

        if(num == 0):
            plotVariables['COS time'] = jsonTime
            plotVariables['COS error'] = jsonError
        if(num == 1):
            plotVariables['FD_AD time'] = jsonTime
            plotVariables['FD_AD error'] = jsonError
        if(num == 2):
            plotVariables['FD_NU time'] = jsonTime
            plotVariables['FD_NU error'] = jsonError
    return plotVariables 