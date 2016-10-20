import json
import sys
sys.path.insert(0, '/home/ubuntu/BaaS/cloud_init_test/add-userdata')
from instance_userdata import contextualizeVM
from test_celery.celery import app


def dynamicSpawn(numberOfTasks):

    #Inspect all nodes
    i = app.control.inspect()

    
    #Return all workers with a list of tasks associated with each
    activeWorkers = i.active()

    keys = i.stats().keys()
    print keys
    idleNodes = 0

    #Find the number of idle nodes.
    for key in keys:
        if activeWorkers[key] == []:
            idleNodes += 1
    
    VMsToSpawn = numberOfTasks - idleNodes
    print "VM:s to spawn: " + str(VMsToSpawn)
    if(VMsToSpawn <= 0):
        print "There are already enough workers active."
        return

    for VMs in range(1, VMsToSpawn+1, 1):
        spawnVM(keys, VMs)
	print VMs

    desired_vms = len(keys) + VMsToSpawn 
    actual_vms = len(keys)
    while actual_vms < desired_vms:
    	i = app.control.inspect()

	#Return all workers with a list of tasks associated with each
    	activeWorkers = i.active()

    	keys = i.stats().keys()
	actual_vms = len(keys)

    return
            
def spawnVM(keys, n):
    workerID = "group2_worker" + str(len(keys)+n)
    print "Deploying new VM with ID: " + workerID
    contextualizeVM(workerID)


#
# THIS FUNCTIONALITY IS CRUCIAL FOR ELASTICITY BUT WILL ONLY BE INCLUDED IF TIME ALLOW IT FOR THIS PROJECT.
#
def terminateVM():
    workerID = "group2_worker" + str(len(workerIDs))
    del workerIDs[workerID]
    #terminate VM (EXTERNAL FUNCTION)
    print workerIDs
