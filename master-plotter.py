import pandas as pd
import matplotlib.pyplot as plt
import math

dataset = "ucy_zara01"
parameter = 3

crowd_radius1 = "crowdedness/{}/{}-param-radius1.csv".format(dataset, dataset)
crowd_radius2 = "crowdedness/{}/{}-param-radius2.csv".format(dataset, dataset)
crowd_radius5 = "crowdedness/{}/{}-param-radius5.csv".format(dataset, dataset)

smooth_radius1 = "smoothed_crowdedness/{}/{}-param-radius1.csv".format(dataset, dataset)
smooth_radius2 = "smoothed_crowdedness/{}/{}-param-radius2.csv".format(dataset, dataset)
smooth_radius5 = "smoothed_crowdedness/{}/{}-param-radius5.csv".format(dataset, dataset)

standard = "crowdedness/{}/{}-param-standard.csv".format(dataset, dataset)

# import the csv dataset
df_crowd_radius1 = pd.read_csv(crowd_radius1, sep=",", header=None)
df_crowd_radius2 = pd.read_csv(crowd_radius2, sep=",", header=None)
df_crowd_radius5 = pd.read_csv(crowd_radius5, sep=",", header=None)

df_smoothcrowd_radius1 = pd.read_csv(smooth_radius1, sep=",", header=None)
df_smoothcrowd_radius2 = pd.read_csv(smooth_radius2, sep=",", header=None)
df_smoothcrowd_radius5 = pd.read_csv(smooth_radius5, sep=",", header=None)

df_standard = pd.read_csv(standard, sep=",", header=None)

# x axis values
x1 = [0, 1, 2]
x2 = [0, 1, 2, 3]
x5 = [0, 2, 4, 6, 8]

### DESIRED SPEED GRAPHIC ###
f3_crowd_r1 = df_crowd_radius1[df_crowd_radius1.columns[parameter]]
f3_crowd_r2 = df_crowd_radius2[df_crowd_radius2.columns[parameter]]
f3_crowd_r5 = df_crowd_radius5[df_crowd_radius5.columns[parameter]]

f3_smooth_r1 = df_smoothcrowd_radius1[df_smoothcrowd_radius1.columns[parameter]]
f3_smooth_r2 = df_smoothcrowd_radius2[df_smoothcrowd_radius2.columns[parameter]]
f3_smooth_r5 = df_smoothcrowd_radius5[df_smoothcrowd_radius5.columns[parameter]]

f3_standard = df_standard[df_standard.columns[parameter]]

plt.plot(x1, f3_crowd_r1, label = "crowdedness, radius = 1", linewidth = 2)
plt.plot(x2, f3_crowd_r2, label = "crowdedness, radius = 2", linewidth = 2)
plt.plot(x5, f3_crowd_r5, label = "crowdedness, radius = 5", linewidth = 2)

plt.plot(x1, f3_smooth_r1, label = "smooth, radius = 1", linewidth = 2)
plt.plot(x2, f3_smooth_r2, label = "smooth, radius = 2", linewidth = 2)
plt.plot(x5, f3_smooth_r5, label = "smooth, radius = 5", linewidth = 2)

plt.hlines(f3_standard, 0, 8, linewidth = 2, label = "standard")

axes = plt.gca()
axes.set_xlim([-1,9])

plt.title("f3 comparison - {}".format(dataset))
# naming the x axis
plt.xlabel('crowdedness')
# naming the y axis 
plt.ylabel('f3 (N)') 
plt.legend()
plt.show()