#! /usr/local/bin/python3

# SMOOTHED-CROWDEDNESS.PY SCRIPT
# script to smoothe the crowdedness based on a moving customizable window
# @sebastianochiari

print('START SMOOTHED-CROWDEDNESS.PY SCRIPT')

print('loading python modules')

# load pandas library as pd
import pandas as pd

# importing dataset
file = "crowded_real_video_trajectory/eth_hotel.csv"
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

# set radius e smooth radius
radius = 5

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
    
    # mi salvo il valore di crowdedness del frame che sto analizzando
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
    data.iloc[loc_smooth, x] = media

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
data.iloc[loc_smooth, x] = media

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
data.iloc[loc_smooth, x] = media

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
data.iloc[loc_smooth, x] = media

x = columns - 1
media = data.iloc[loc_crowd, x]
media_divisor = 1
for j in range(1, offset_value+1):
    offset = x - j
    if data.iloc[0,x] == data.iloc[0,offset]:
        media = media + data.iloc[loc_crowd,offset]
        media_divisor = media_divisor + 1
media = float(media / media_divisor)
data.iloc[loc_smooth, x] = media

# print(data)

data.to_csv("smoothed_crowdedness_datasets/smooth-crowded-eth_hotel.csv", sep=',', header=False, index=False)