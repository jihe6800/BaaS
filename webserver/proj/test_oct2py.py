from oct2py import octave
octave.addpath('/Users/majaengvall/Documents/Cloud computing/Project/BaaS/BENCHOP/')
res=octave.Table_task(1, 2, 3)
#octave.call("Table_task.m",1,2,1)
#res=octave.eval("Table_task(1, 2, 1)")
#print res