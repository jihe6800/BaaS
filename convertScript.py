#def convertToJSON(): 

test_data = [[1,2,1,2,1,2,1,2,1,2,1,2], [3,4,5,6,7,8,9,1,1,2,1,2], [1,2,1,2,1,2,1,2,1,2,1,2]]
plotVariables = {'COS error': None, 'FD_AD error': None, 'FD_NU error' : None, 'COS time' : None, 'FD_AD time' : None, 'FD_NU time' : None}

#Labels that will be used when plotting the values.
labels = ['European standard', 'American standard', 'Barrier standard', 'European challenging', 'American challenging', 'Barrier challenging']

for num in range(len(test_data)):
    jsonTime = {'European standard' : None, 'American standard' : None, 'Barrier standard' : None, 'European challenging' : None, 'American challenging' : None, 'Barrier challenging' : None}
    jsonError = {'European standard' : None, 'American standard' : None, 'Barrier standard' : None, 'European challenging' : None, 'American challenging' : None, 'Barrier challenging' : None}
    
    counterTime = 0
    counterError = 0
    for pos in range(len(test_data[num])):
       if(pos%2 == 0):
           jsonTime[labels[counterTime]] = test_data[num][pos]
           counterTime += 1
       else:
           jsonError[labels[counterError]] = test_data[num][pos] 
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

print plotVariables
#if "__name__" == "__main__":
#    convertToJSON()
