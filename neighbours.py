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
# 
from scipy.interpolate import UnivariateSpline

def neighbours(file, radius, color):

    """This function returns the density of pedestrian around each pID into each frame, by a given radius"""
    
    print(file)

    ### PARAMETERS SETTING ###

    # import the csv dataset
    data = pd.read_csv(file, sep=",", header=None)

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

    # build numpy array to collect all the neighbours
    neighbours = np.zeros((1, int(columns)), dtype=int)

    ### COMPUTE DENSITY ###

    # compute density per each couple(pID,frame)
    for x in range(0, columns):
        # retrieve all the column useful information
        frame = data.iloc[0,x]
        pID = data.iloc[1,x]
        
        X = data.iloc[2,x]
        Y = data.iloc[3,x]

        rangeFrame = int(frame) - 1

        ranger = startEnd[rangeFrame,1] + 1
        starter = startEnd[rangeFrame,0]

        # print('Starter: ', starter)
        # print('Range: ' , ranger)

        # cycle into the same dataframe to find neighbours
        for j in range(starter, ranger):

            # retrieve frame and ID
            tmpPID = data.iloc[1,j]
            
            # same frame but different pedestrianID
            if pID != tmpPID :
                # retrieve position into the frame
                tmpX = data.iloc[2,j]
                tmpY = data.iloc[3,j]

                euclideian_distance = math.sqrt( (tmpX-X)**2 + (tmpY-Y)**2 )

                if euclideian_distance <= float(radius):
                    neighbours[0,x] += 1

    # sort the numpy array in ascending order (not necessary)
    neighbours.sort(axis = 1)

    # build a dictionary from the neighbours numpy array
    unique, counts = np.unique(neighbours, return_counts=True)
    a = dict(zip(unique, counts))

    # write to file operation
    # with open('density_histograms/ucy_zara02-RADIUS_5.txt', 'w') as f:
    #     print(a, file=f)

    #### BUILD HISTOGRAM ####

    # x = list(a.keys())
    # y = list(a.values())

    # spl = UnivariateSpline(x, y)
    
    # plt.plot(x, spl(x), color, ms=5)

    # build the histogram
    # plt.bar(list(a.keys()), a.values(), color='g')
    # plt.gca().set(title="Crowd density per ID with radius = 5")
    # plt.gca().set(xlabel='# of close pedestrian')
    # plt.gca().set(ylabel='# frame')

    return a

def pattern(file, c1, c2, c3):
    radius = 1
    neighbours(file, radius, c1)

    radius = 2
    neighbours(file, radius, c2)

    radius = 5
    neighbours(file, radius, c3)

def big_graphic(radius, color):

    from collections import Counter
    
    tmp1 = neighbours("real_video_trajectory/eth_hotel.csv", radius, 'b')
    tmp2 = neighbours("real_video_trajectory/eth_univ.csv", radius, 'b')
    tmp3 = neighbours("real_video_trajectory/ucy_univ.csv", radius, 'b')
    tmp4 = neighbours("real_video_trajectory/ucy_zara01.csv", radius, 'b')
    tmp5 = neighbours("real_video_trajectory/ucy_zara02.csv", radius, 'b')

    final = dict(Counter(tmp1) + Counter(tmp2) + Counter(tmp3) + Counter(tmp4) + Counter(tmp5))
    
    print_graphic_from_dictonary(final,radius,color)

def print_graphic_from_dictonary(dictionary, radius, color):
    #### BUILD HISTOGRAM ####

    x = list(dictionary.keys())
    y = list(dictionary.values())

    spl = UnivariateSpline(x, y)
    
    plt.plot(x, spl(x), color, ms=5)

    # build the histogram
    # plt.bar(list(a.keys()), a.values(), color='g')
    # plt.gca().set(title="Overall crowd density per (pID, frame) with radius = {}".format(radius))
    # plt.gca().set(xlabel='# of close pedestrian')
    # plt.gca().set(ylabel='# frame')

# file = "real_video_trajectory/eth_hotel.csv"
# pattern(file, '#97BFCC', '#438499', '#D6FFF3')

# file = "real_video_trajectory/eth_univ.csv"
# pattern(file, '#78CC64', '#CC97A5', '#FF9E96')

# file = "real_video_trajectory/ucy_univ.csv"
# pattern(file, '#6497CC', '#FF8AE4', '#CC8812')

# file = "real_video_trajectory/ucy_zara01.csv"
# pattern(file, 'r', 'g', 'b')

# file = "real_video_trajectory/ucy_zara02.csv"
# pattern(file, '#A62317', '#B31084', '#2C5CA8')

# plt.show()

big_graphic(1, 'r')
big_graphic(2, 'b')
big_graphic(5, 'g')

plt.gca().set(title="Overall crowd density per (pID, frame)")
plt.gca().set(xlabel='# of close pedestrian')
plt.gca().set(ylabel='# frame')

plt.show()