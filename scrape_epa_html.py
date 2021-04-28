#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 16 01:09:57 2021

@author: avery
"""

# code to scrape html tables from EPA website.

# import required modules
import requests
from bs4 import BeautifulSoup
import pandas as pd
import numpy as np

# make a GET request
req = requests.get('https://www.epa.gov/navajo-nation-uranium-cleanup/abandoned-mines-cleanup-site-screen-reports')

# read content of the server’s response
src = req.text

# parse response into an HTML tree
soup = BeautifulSoup(src, 'lxml')

# take a look
print(soup.prettify()[:3000])

# extract rows
rows = soup.find_all("tbody")
print(rows[0].prettify())

# evaluate rows
len(rows)
rows

# select only  'td' tags.
row = rows[0]
detailCells = row.select('td')

# evaluate 
len(detailCells)
detailCells[0]

# extract data
rowData = [cell.text for cell in detailCells]

# check em out
print(rowData[0]) # Mine alt Name
print(rowData[1]) # Description
print(rowData[2]) # Region
print(rowData[3]) # Chapter

# create empty object
mines = []

rows = soup.select('td')
len(rows)
rowData = [cell.text for cell in rows]

# for loop to iterate over objects
for row in rows:
    
    #detailCells = row.select('td')
    rowData = [cell.text for cell in rows]
    
    # Collect information
    alt_name = rowData[0]
    description = rowData[1]
    region = rowData[2]
    chapter = rowData[3]
    
    # Store in a tuple
    tup = (alt_name,description,region,chapter)
    
    # Append to list
    mines.append(tup)

# evaluate
len(mines)  

# structure into DataFrame
df_one = pd.DataFrame(np.array(rowData).reshape(476,4))
df_test = pd.DataFrame(mines,columns=('alt_name', 
                                      'description',
                                      'region', 
                                      'chapter'))

  
# output to .csv
df_one.to_csv("mine_output_test.csv") 
    
    
#~fin

