import pandas as pd
import matplotlib.pyplot as plt
import math

file1 = "1st linear regression/ucy_zara01/radius = 1/ucy_zara01_param-radius1.csv"
file2 = "1st linear regression/ucy_zara01/radius = 2/ucy_zara01_param-radius2.csv"
file3 = "1st linear regression/ucy_zara01/radius = 5/ucy_zara01_param-radius5.csv"

# import the csv dataset
df_radius1 = pd.read_csv(file1, sep=",", header=None)
df_radius2 = pd.read_csv(file2, sep=",", header=None)
df_radius5 = pd.read_csv(file3, sep=",", header=None)

# x axis values
x1 = [0, 1, 2, 3, 4]
x2 = [0, 1, 2, 3, 4, 5, 6, 7]
x5 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

### DESIRED SPEED GRAPHIC ###
des_r1 = df_radius1[df_radius1.columns[0]]
des_r2 = df_radius2[df_radius2.columns[0]]
des_r5 = df_radius5[df_radius5.columns[0]]

plt.plot(x1, des_r1, label = "radius = 1")
plt.plot(x2, des_r2, label = "radius = 2")
plt.plot(x5, des_r5, label = "radius = 5")

plt.title("desired speed comparison - ucy_univ")
# naming the x axis
plt.xlabel('crowdedness') 
# naming the y axis 
plt.ylabel('desired speed (m/s)') 
plt.legend()
plt.show()

### F1 GRAPHIC ###
f1_r1 = df_radius1[df_radius1.columns[1]]
f1_r2 = df_radius2[df_radius2.columns[1]]
f1_r5 = df_radius5[df_radius5.columns[1]]

plt.plot(x1, f1_r1, label = "radius = 1")
plt.plot(x2, f1_r2, label = "radius = 2")
plt.plot(x5, f1_r5, label = "radius = 5")

plt.title("F1 comparison - ucy_univ")
# naming the x axis 
plt.xlabel('crowdedness') 
# naming the y axis 
plt.ylabel('f1 (N)')
plt.legend()
plt.show()

### F2 GRAPHIC ###
f2_r1 = df_radius1[df_radius1.columns[2]]
f2_r2 = df_radius2[df_radius2.columns[2]]
f2_r5 = df_radius5[df_radius5.columns[2]]

plt.plot(x1, f2_r1, label = "radius = 1")
plt.plot(x2, f2_r2, label = "radius = 2")
plt.plot(x5, f2_r5, label = "radius = 5")

plt.title("F2 comparison - ucy_univ")
# naming the x axis 
plt.xlabel('crowdedness') 
# naming the y axis 
plt.ylabel('f2 (N)')
plt.legend()
plt.show()

### F3 GRAPHIC ###
f3_r1 = df_radius1[df_radius1.columns[3]]
f3_r2 = df_radius2[df_radius2.columns[3]]
f3_r5 = df_radius5[df_radius5.columns[3]]

plt.plot(x1, f3_r1, label = "radius = 1")
plt.plot(x2, f3_r2, label = "radius = 2")
plt.plot(x5, f3_r5, label = "radius = 5")

plt.title("F3 comparison - ucy_univ")
# naming the x axis 
plt.xlabel('crowdedness') 
# naming the y axis 
plt.ylabel('f3 (N)')
plt.legend()
plt.show()

### FORCES RADIUS 1 ###
plt.plot(x1, f1_r1, label = "f1")
plt.plot(x1, f2_r1, label = "f2")
plt.plot(x1, f3_r1, label = "f3")

plt.title('comparison between forces - radius = 1')
plt.xlabel('crowdedness')
plt.ylabel('N')
plt.legend()
plt.show()

### FORCES RADIUS 2 ###
plt.plot(x2, f1_r2, label = "f1")
plt.plot(x2, f2_r2, label = "f2")
plt.plot(x2, f3_r2, label = "f3")

plt.title('comparison between forces - radius = 2')
plt.xlabel('crowdedness')
plt.ylabel('N')
plt.legend()
plt.show()

### FORCES RADIUS 5 ###
plt.plot(x5, f1_r5, label = "f1")
plt.plot(x5, f2_r5, label = "f2")
plt.plot(x5, f3_r5, label = "f3")

plt.title('comparison between forces - radius = 5')
plt.xlabel('crowdedness')
plt.ylabel('N')
plt.legend()
plt.show()