from __future__ import absolute_import

from proj.celery import app 
from oct2

import json
import re

@app.task
def getBenchmark (num_workers):


    jsonData = fetchPreprocessFile(path)
    counter = {
        'han': 0,
        'hon': 0,
        'den': 0,
        'det': 0,
        'denna': 0,
        'denne': 0,
        'hen': 0
        }
    for (attribute, value) in counter.items():
        counter[attribute] = countOccurence(attribute, jsonData) 
    return counter 
