import subprocess
print "start"
test = subprocess.check_output(['bash', 'script.sh'])
print test
print "end"
