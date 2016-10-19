import subprocess
input_A = "1"
input_B = "3"
input_C = "3"

command = 'bash script.sh ' + input_A + ' ' + input_B + ' ' + input_C
print command
print "start"
test = subprocess.check_output(command, shell=True)
print "end"

start_index = test.find("START_OUTPUT")

print test[start_index:]
