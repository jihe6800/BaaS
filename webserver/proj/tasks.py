from __future__ import absolute_import

from proj.celery import app 

import json
import re
import subprocess

@app.task
def getBenchmark (num_workers):

    input_A = "1"
    input_B = "3"
    input_C = "3"

    command = 'bash script.sh ' + input_A + ' ' + input_B + ' ' + input_C
    print "start"
    test = subprocess.check_output(command, shell=True)
    print "end"

    #start_index = test.find("START_OUTPUT")
    #test = test[start_index:]
    return  "hej"
