#! /usr/local/bin/python3

# EXTRACTOR.PY SCRIPT
# script to format the dataset from Alessandro Corbetta, TU/e
# in order to be correctly loaded from the SFM algorithm
# @sebastianochiari

# load pandas library as pd
import numpy as np
import pandas as pd

# read data from file "data.txt" ("right-to-left.ssv" + "left-to-right.ssv" from the dataset)
df = pd.read_csv('data.txt', sep=" ", header=None)
df.columns = ["Pid", "Rstep", "X", "Y", "X_SG", "Y_SG", "U_SG", "V_SG"]

# swap the Pid and Rstep columns in order to fit the SFM algorithm requirements for text formatting
columnsTitles = ["Rstep", "Pid", "X", "Y", "X_SG", "Y_SG", "U_SG", "V_SG"]
df = df.reindex(columns = columnsTitles)

# delete the useless columns from the dataset for the two different outputs
columns = ["X_SG", "Y_SG", "U_SG", "V_SG"]
# new dataframe with the Cartesian coordinates
cartesianDF = df.drop(columns, axis=1)

# new datafram with the Cartesian coordinates after Savinksy-Golay smoothing
columns = ["X", "Y", "U_SG", "V_SG"]
smoothedDF = df.drop(columns, axis=1)

# checkpoint
# print(cartesianDF)
# print(smoothedDF)

# add the Group column (assigned '0' value to all the entries)
cartesianDF['Group'] = pd.Series(0, index=cartesianDF.index)
smoothedDF['Group'] = pd.Series(0, index=smoothedDF.index)

# checkpoint
# print(cartesianDF)
# print(smoothedDF)

# final export to csv file format for the SFM algorithm
# sep = ' ' è per mantenere la formattazione dei dati correttamente
# index=False elimina l'esportazione del csv della colonna aggiuntiva con gli index del dataframe
# header=None fa sì che non vengano riportati i nomi delle colonne
cartesianDF.to_csv(r'cartesianDataset.csv', sep=' ', index=False, header=None)
smoothedDF.to_csv(r'smoothedDataset.csv', sep=' ', index=False, header=None)


