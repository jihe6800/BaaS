from oct2py import octave
octave.addpath('/Users/majaengvall/Documents/Cloud computing/Project/BaaS/BENCHOP/')



@app.task
def getResultBench (worker,num_workers,num_solvers):
    res=octave.Table_task(worker,num_workers,num_solvers)
    print res
    counter = {
        'han': 0,
        'hon': 0,
        'den': 0,
        'det': 0,
        'denna': 0,
        'denne': 0,
        'hen': 0
        }

    test_data = {
        'solver': {
            'cos': {
                'problem_1': {
                    'error': 0,
                    'time': 0,
                },
                'problem_2': {
                    'error': 0,
                    'time': 0,
                },
                'problem_3': {
                    'error': 0,
                    'time': 0,
                },
                'problem_4': {
                    'error': 0,
                    'time': 0,
                },
                'problem_5': {
                    'error': 0,
                    'time': 0,
                },
                'problem_6': {
                    'error': 0,
                    'time': 0,
                },
            },
            'fd': {
                'problem_1': {
                    'error': 0,
                    'time': 0,
                },
                'problem_1': {
                    'error': 0,
                    'time': 0,
                }
            },
        }
    }
    for (attribute, value) in counter.items():
        counter[attribute] = countOccurence(attribute, jsonData) 
    return counter 
#octave.eval("Table_task(1, 2, 3)")
