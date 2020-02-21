#! /usr/local/bin/python3

# SMOOTHED-CROWDEDNESS.PY SCRIPT
# script to smoothe the crowdedness based on a moving customizable window
# @sebastianochiari

print('START SMOOTHED-CROWDEDNESS.PY SCRIPT')

print('loading python modules')

# load pandas library as pd
import pandas as pd

# function to compute the smoothed-crowdedness
def computeSmoothCrowdedness(r):
    # set radius e smooth radius
    radius = r

    if radius == 1:
        loc_crowd = 5
        loc_smooth = 8
    elif radius == 2:
        loc_crowd = 6
        loc_smooth = 9
    elif radius == 5:
        loc_crowd = 7
        loc_smooth = 10


    for x in range(offset_value,columns - offset_value):
        
        # saving th crowdedness from the frame I'm looking
        media = data.iloc[loc_crowd,x]
        media_divisor = 1

        for j in range(1,offset_value+1):
            offset = x + j
            if data.iloc[0,x] == data.iloc[0,offset]:
                media = media + data.iloc[loc_crowd,offset]
                media_divisor = media_divisor + 1
            offset = x - j
            if data.iloc[0,x] == data.iloc[0,offset]:
                media = media + data.iloc[loc_crowd,offset]
                media_divisor = media_divisor + 1
        
        media = float(media / media_divisor)
        data.iloc[loc_smooth, x] = int(round(media))

    # edit the left out values
    x = 0
    media = data.iloc[loc_crowd, x]
    media_divisor = 1
    for j in range(1, offset_value+1):
        offset = x + j
        if data.iloc[0,x] == data.iloc[0,offset]:
            media = media + data.iloc[loc_crowd,offset]
            media_divisor = media_divisor + 1
    media = float(media / media_divisor)
    data.iloc[loc_smooth, x] = int(round(media))

    x = 1
    media = data.iloc[loc_crowd, x]
    media_divisor = 1
    for j in range(1, offset_value+1):
        offset = x + j
        if data.iloc[0,x] == data.iloc[0,offset]:
            media = media + data.iloc[loc_crowd,offset]
            media_divisor = media_divisor + 1
        offset = x - j
        if j <= x:
            if data.iloc[0,x] == data.iloc[0,offset]:
                media = media + data.iloc[loc_crowd,offset]
                media_divisor = media_divisor + 1

    media = float(media / media_divisor)
    data.iloc[loc_smooth, x] = int(round(media))

    x = columns - 2
    media = data.iloc[loc_crowd, x]
    media_divisor = 1
    for j in range(1, offset_value+1):
        offset = x + j
        if j == 1:
            if data.iloc[0,x] == data.iloc[0,offset]:
                media = media + data.iloc[loc_crowd,offset]
                media_divisor = media_divisor + 1
        offset = x - j
        if data.iloc[0,x] == data.iloc[0,offset]:
            media = media + data.iloc[loc_crowd,offset]
            media_divisor = media_divisor + 1

    media = float(media / media_divisor)
    data.iloc[loc_smooth, x] = int(round(media))

    x = columns - 1
    media = data.iloc[loc_crowd, x]
    media_divisor = 1
    for j in range(1, offset_value+1):
        offset = x - j
        if data.iloc[0,x] == data.iloc[0,offset]:
            media = media + data.iloc[loc_crowd,offset]
            media_divisor = media_divisor + 1
    media = float(media / media_divisor)
    data.iloc[loc_smooth, x] = int(round(media))

# importing dataset
file = "crowded_real_video_trajectory/ucy_zara02.csv"
data = pd.read_csv(file, sep=",", header=None)

# transpose dataset
df_transposed = data.transpose()

# sort the dataset by ID
df_transposed.columns = ['frame', 'id', 'x', 'y', 'g', 'r1', 'r2', 'r5']

columnsTitles=['id', 'frame', 'x', 'y', 'g', 'r1', 'r2', 'r5', 'sr1', 'sr2', 'sr5']
df_transposed = df_transposed.reindex(columns=columnsTitles)

df_transposed = df_transposed.sort_values(by=['id', 'frame'])
df_transposed = df_transposed.reset_index(drop=True)

data = df_transposed.transpose()

# print(data)

# set the smoothing window
smoothing_window = 5
offset_value = int(smoothing_window/2)

# retrieve the number of columns from the dataframe
columns = (data.shape)[1]

print('computing smooth-crowdedness radius 1')
computeSmoothCrowdedness(1)

print('computing smooth-crowdedness radius 2')
computeSmoothCrowdedness(2)

print('computing smooth-crowdedness radius 5')
computeSmoothCrowdedness(5)

# reset the matrix to its original form-factor (frames in the first row and ordered by frame)
df_transposed = data.transpose()

columnsTitles=['frame', 'id', 'x', 'y', 'g', 'r1', 'r2', 'r5', 'sr1', 'sr2', 'sr5']
df_transposed = df_transposed.reindex(columns=columnsTitles)

df_transposed = df_transposed.sort_values(by=['frame', 'id'])
df_transposed = df_transposed.reset_index(drop=True)

data = df_transposed.transpose()

data.to_csv("smoothed_crowdedness_datasets/smooth-crowded-ucy_zara02.csv", sep=',', header=False, index=False)