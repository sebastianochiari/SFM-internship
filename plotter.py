import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math

data = pd.read_csv("real_video_trajectory/eth_hotel_edited.csv", sep=";", header=None)

x = np.empty((1,10), dtype=float)
y = np.empty((1,10), dtype=float)

start = 0
columns = 10


for tmp in range(start, columns):
    i = tmp - start
    x[0,i] = data.iloc[2,i]
    y[0,i] = data.iloc[3,i]

# plt.scatter(x,y)
# plt.show()

radius = 2

for tmp in range(start, columns):
    i = tmp - start
    X = x[0,i]
    Y = y[0,i]

    counter = 0

    for tmp2 in range (start, columns):
        j = tmp2 - start
        if i != j:
            tmpX = x[0,j]
            tmpY = y[0,j]

            # compute euclidean distance
            euclidean_distance = math.sqrt( (tmpX-X)**2 + (tmpY-Y)**2 )

            if euclidean_distance <= float(radius):
                counter += 1

            # print('Euclidean distance between (', X, ',', Y, ') and (', tmpX, ',', tmpY, ') is ', euclidean_distance)
    
    print('For (', X, ',', Y, ') there are ', counter, ' neighbours under ', radius, 'm of distance')