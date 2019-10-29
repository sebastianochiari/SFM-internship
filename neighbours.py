#! /usr/local/bin/python3

# NEIGHBOURS.PY SCRIPT
# script to compute the density each frame per id
# radius customizable parameter
# @sebastianochiari

print('START NEIGHBOURS.PY SCRIPT')

print('loading python modules')

# load numpy library as np
import numpy as np
# load pandas library as pd
import pandas as pd
# load matplotlib library as plt
import matplotlib.pyplot as plt
# load math library
import math

# import the csv dataset
data = pd.read_csv("real_video_trajectory/ucy_zara02.csv", sep=",", header=None)

# set the radius
radius = 5

# retrieve the number of columns from the dataframe
columns = (data.shape)[1]

# retrieve the number of frame from the dataset
num_frame = data.iloc[0,columns - 1]

# retrieve start point and end point for each frame into the dataset 
startEnd = np.zeros((int(num_frame), 2), dtype=int)
startEnd[0,0] = 0
tmp1 = int(num_frame) - 1
tmp2 = int(columns) - 1
startEnd[tmp1, 1] = tmp2

check = 0

for x in range(1, columns):
    if data.iloc[0,x] != data.iloc[0,(x-1)]:
        end = x - 1
        frame = data.iloc[0, (x-1)] - 1
        startEnd[int(frame), 1] = end
        if data.iloc[0,x] != num_frame:
            start = x
            frame = data.iloc[0, x] - 1
            startEnd[int(frame), 0] = start
        if data.iloc[0,x] == num_frame and check == 0:
            start = x
            frame = data.iloc[0, x] - 1
            startEnd[int(frame), 0] = start
            check = 1

# print(startEnd)

# build numpy array to collect all the neighbours
neighbours = np.zeros((1, int(columns)), dtype=int)

# SCRIPT CORE
# compute density per each couple(pID,frame)
for x in range(0, columns):
    # retrieve all the column useful information
    frame = data.iloc[0,x]
    pID = data.iloc[1,x]
    
    X = data.iloc[2,x]
    Y = data.iloc[3,x]
    
    Xmax = float(X) + radius
    Xmin = float(X) - radius
    
    Ymax = float(Y) + radius
    Ymin = float(Y) - radius

    # print('Looking for ID ', pID, ' in frame ', X)
    # print('Timestamp: ', x, 'di ', columns)

    # print('\n')

    rangeFrame = int(frame) - 1

    ranger = startEnd[rangeFrame,1] + 1
    starter = startEnd[rangeFrame,0]

    # print('Starter: ', starter)
    # print('Range: ' , ranger)

    # cycle into the same dataframe to find neighbours
    for j in range(starter, ranger):

        # retrieve frame and ID
        tmpFrame = data.iloc[0,j]
        tmpPID = data.iloc[1,j]
        
        # same frame but different pedestrianID
        if pID != tmpPID :
            # retrieve position into the frame
            tmpX = data.iloc[2,j]
            tmpY = data.iloc[3,j]

            euclideian_distance = math.sqrt( (tmpX-X)**2 + (tmpY-Y)**2 )

            if euclideian_distance <= float(radius):
                neighbours[0,x] += 1

# export
# print(neighbours)


#### BUILD HISTOGRAM ####

# sort the numpy array in ascending order
neighbours.sort(axis = 1)
# print sorted array
# print(neighbours)

# build a dictionary from the neighbours numpy array
unique, counts = np.unique(neighbours, return_counts=True)
a = dict(zip(unique, counts))
with open('density_histograms/ucy_zara02-RADIUS_5.txt', 'w') as f:
    print(a, file=f)
print(a)

# build the histogram
plt.bar(list(a.keys()), a.values(), color='g')
plt.gca().set(title="Crowd density per ID with radius = 5")
plt.gca().set(xlabel='# of close pedestrian')
plt.gca().set(ylabel='# frame')

plt.show()