from __future__ import absolute_import 
import json
import celery
#import sys
#sys.path.insert(0, '/home/ubuntu/BaaS/webserver/local_celery')
#from BaaS.webserver.local_celery.tasks import app
from celery import app
#from app.control import inspect


def dynamicSpawn(numberOfTasks):
    with open('workerIDs.json') as json_data:
        existingWorkers = json.load(json_data)
    
    #Inspect all nodes
    i = app.control.inspect()

    print '********** INSPECT **********'
    print i
    print '*****************************'
    #Return the number of active workers
    activeWorkers = i.active()

    print '********** INSPECT.ACTIVE() **********'
    print i.stats()
    print '**************************************'
    
    if(activeWorkers == None):
        numberOfActiveWorkers = 0
    else:
        numberOfActiveWorkers = len(i.active())
        
    idleNodes = len(existingWorkers) - numberOfActiveWorkers
    VMsToSpawn = numberOfTasks - idleNodes

    #Just to avoid negative numbers
    if(VMsToSpawn < 0):
        VMsToSpawn = 0
    
    for VMs in range(VMsToSpawn):
        existingWorkers = spawnVM(existingWorkers)

    #Save the current VMs with workers to the JSON file on the master node.
    with open('workerIDs.json', 'w') as json_data:
        json.dump(existingWorkers, json_data)

            
def spawnVM(existingWorkers):
    workerID = "group2_worker" + str(len(existingWorkers)+1)
    existingWorkers[workerID] = True
    #REAL LAUNCH VM
    return existingWorkers

#
# THIS FUNCTIONALITY IS CRUCIAL FOR ELASTICITY BUT WILL ONLY BE INCLUDED IN TIME ALLOW IT FOR THIS PROJECT.
#
def terminateVM():
    workerID = "group2_worker" + str(len(workerIDs))
    del workerIDs[workerID]
    #terminate VM (EXTERNAL FUNCTION)
    print workerIDs
