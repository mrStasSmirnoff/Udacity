
# coding: utf-8

# In[1]:


#!/usr/bin/python

import pickle
import sys
import matplotlib.pyplot
sys.path.append("../tools/")
from feature_format import featureFormat, targetFeatureSplit


# In[11]:


### read in data dictionary, convert to numpy array

data_dict = pickle.load( open("../final_project/final_project_dataset.pkl", "r") )
features = ["salary", "bonus"]
data = featureFormat(data_dict, features)


for k in data_dict:
    if (data_dict[k]['bonus'] > 0.8e8 and data_dict[k]['bonus'] != 'NaN') and        (data_dict[k]['salary'] > 1e7 and data_dict[k]['salary'] != 'NaN'):
        print k


# In[12]:


for point in data:
    salary = point[0]
    bonus = point[1]
    matplotlib.pyplot.scatter( salary, bonus )
   
matplotlib.pyplot.xlabel("salary")
matplotlib.pyplot.ylabel("bonus")
matplotlib.pyplot.show()


# In[13]:


data_dict.pop('TOTAL', 0)
features = ["salary", "bonus"]
data = featureFormat(data_dict, features)

for point in data:
    salary = point[0]
    bonus = point[1]
    matplotlib.pyplot.scatter( salary, bonus )
   
matplotlib.pyplot.xlabel("salary")
matplotlib.pyplot.ylabel("bonus")
matplotlib.pyplot.show()


# In[17]:


for k in data_dict:
    if (data_dict[k]['bonus'] > 6e5 and data_dict[k]['bonus'] != 'NaN') and        (data_dict[k]['salary'] > 1e6 and data_dict[k]['salary'] != 'NaN'):
        print k

