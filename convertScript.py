#def convertToJSON(): 

test_data = [[1,2,1,2,1,2,1,2,1,2,1,2], [3,4,5,6,7,8,9,1,1,2,1,2], [1,2,1,2,1,2,1,2,1,2,1,2]]
plotVariables = {'COSerror': None, 'FD_ADerror': None, 'FD_NUerror' : None, 'COStime' : None, 'FD_ADtime' : None, 'FD_NUtime' : None}

for num in range(len(test_data)):
    jsonTime = {'problem1' : 0, 'problem2' : 0, 'problem3' : 0, 'problem4' : 0, 'problem5' : 0, 'problem6' : 0}
    jsonError = {'problem1' : 0, 'problem2' : 0, 'problem3' : 0, 'problem4' : 0, 'problem5' : 0, 'problem6' : 0}
    #print jsonTime['problem' + str()]
    counterTime = 1
    counterError = 1
    for pos in range(len(test_data[num])):
       if(pos%2 == 0):
           jsonTime['problem' + str(counterTime)] = test_data[num][pos]
           counterTime += 1
       else:
           jsonError['problem' + str(counterError)] = test_data[num][pos] 
           counterError += 1

    #plotVariables.append(jsonTime)
    #plotVariables.append(jsonError)
    if(num == 0):
        plotVariables['COStime'] = jsonTime
        plotVariables['COSerror'] = jsonError
    if(num == 1):
        plotVariables['FD_ADtime'] = jsonTime
        plotVariables['FD_ADerror'] = jsonError
    if(num == 2):
        plotVariables['FD_NUtime'] = jsonTime
        plotVariables['FD_NUerror'] = jsonError

print plotVariables
#if "__name__" == "__main__":
#    convertToJSON()
