from oct2py import octave
octave.addpath('/home/ubuntu/BaaS/BENCHOP')
res=octave.Table_task(1, 2, 3)


print res
print len(res)
print len(res[0])