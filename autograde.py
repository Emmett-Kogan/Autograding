import sys # for command line arguements - getting csv filename
import pandas as pd # for reading/modifying input csv file
import numpy as np

# cmd arguements should be 1->csv filename, 2-> assignment name and id, 3->script output file

filename = sys.argv[1]
assignment = sys.argv[2]
script_output = sys.argv[3]



gb = pd.read_csv(filename)
gb = gb.set_index('ID')

f = open('review.txt', 'w')

with open(script_output,'r') as openfileobject:
    for line in openfileobject:
        if line == '\n':
            break
        parts=line.split('_')
        id = parts[1]
        other_id = parts[2]
        grade = parts[3].split(' ')[1]
        flag = parts[3].split(' ')[2][0]
        # update the grades in the csv file
        gb.loc[int(id), assignment] = grade
        # output flagged people to have their submission reviewed in the reviewed.txt file
        if flag == '1':
            f.write(gb.loc[int(id), 'Student'] + '\n')

# fix index
gb = gb.reset_index()

# swap order of columns back to orginal
temp = list(gb.columns)
temp[0], temp[1] = temp[1], temp[0]
gb = gb[temp]

# write back to post to canvas
gb.to_csv('modified.csv', index=False)
f.close()