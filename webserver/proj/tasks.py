from __future__ import absolute_import

from proj.celery import app 

import json
import re

def countOccurence( word, data ):
        print "counting file"
	counter = 0
	for tweet in data:
		if(re.search(word, tweet["text"], re.IGNORECASE) != None) : 
			counter = counter + 1
	return counter

def fetchPreprocessFile ( path ):
    data = file(path, "r").read().replace("\n\n", ", ")
    data = data[:-2]
    data = "[" + data + "]" 
    jsonData = json.loads(data)
    jsonData = filter(lambda x: not(x["retweeted"]), jsonData)
    return jsonData

@app.task
def add(x, y):
    return x + y


@app.task
def mul(x, y):
    return x * y


@app.task
def xsum(numbers):
    return sum(numbers)

@app.task
def getCountFile ( path ):
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
