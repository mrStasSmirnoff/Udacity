
# coding: utf-8

# In[1]:


#!/usr/bin/python 

""" 
    Skeleton code for k-means clustering mini-project.
"""
import pickle
import numpy
import matplotlib.pyplot as plt
import sys
sys.path.append("../tools/")
from feature_format import featureFormat, targetFeatureSplit


def Draw(pred, features, poi, mark_poi=False, name="image.png", f1_name="feature 1", f2_name="feature 2"):
    """ some plotting code designed to help you visualize your clusters """

    ### plot each cluster with a different color--add more colors for
    ### drawing more than five clusters
    colors = ["b", "c", "k", "m", "g"]
    for ii, pp in enumerate(pred):
        plt.scatter(features[ii][0], features[ii][1], color = colors[pred[ii]])

    ### if you like, place red stars over points that are POIs (just for funsies)
    if mark_poi:
        for ii, pp in enumerate(pred):
            if poi[ii]:
                plt.scatter(features[ii][0], features[ii][1], color="r", marker="*")
    plt.xlabel(f1_name)
    plt.ylabel(f2_name)
    plt.savefig(name)
    plt.show()


# In[11]:


### load in the dict of dicts containing all the data on each person in the dataset
data_dict = pickle.load( open("../final_project/final_project_dataset.pkl", "r") )
### there's an outlier--remove it! 
data_dict.pop("TOTAL", 0)
#print(data_dict)

### the input features we want to use 
### can be any key in the person-level dictionary (salary, director_fees, etc.) 
feature_1 = "salary"
feature_2 = "exercised_stock_options"
feature_3 = "total_payments"
poi  = "poi"
features_list = [poi, feature_1, feature_2]
data = featureFormat(data_dict, features_list )
poi, finance_features = targetFeatureSplit( data )


features = np.array(finance_features)
stock_features = features[:, 1]
stock_features.sort()
print('maximum value in stock features %f' % (stock_features[-1]))
sal_features = features[:, 0]
sal_features.sort()
print('maximum value in salary features %f' % (sal_features[-1])) 



from sklearn.preprocessing import MinMaxScaler

scl = MinMaxScaler()

finance_features = scl.fit_transform(finance_features)

# Now all features are betwwen 0 and 1
print(finance_features)

features_test = np.array([[200000., 1000000.]])
print scl.transform(features_test)

#print(poi)
#print(finance_features)


# In[3]:


def compute_min_max_values(dictionary,feature_name):
    
    # Initialize any arbitrary value from a data to be min and max (reference points)
    # Ping me pls if you know better inititialization strategy
    
    feature_value_min = 1e7
    feature_value_max = 0
    
    for k in dictionary:
        
        feature_value = data_dict[k][feature_name]
        
        if feature_value != 'NaN':
            
            if feature_value < feature_value_min:
                feature_value_min = feature_value
                
            if feature_value > feature_value_max:
                feature_value_max = feature_value

    print("Minimum:", feature_value_min)
    print("Maximum:", feature_value_max)


# In[4]:


compute_min_max_values(data_dict,'salary')
compute_min_max_values(data_dict,'exercised_stock_options')


# In[5]:


### in the "clustering with 3 features" part of the mini-project,
### you'll want to change this line to 
### for f1, f2, _ in finance_features:
### (as it's currently written, the line below METTS MARKassumes 2 features)
for f1, f2 in finance_features:
    plt.scatter( f1, f2 )
plt.show()

### cluster here; create predictions of the cluster labels
### for the data and store them to a list called pred
from sklearn.cluster import KMeans
import numpy as np

kmeans = KMeans(n_clusters=2, random_state=0)
pred = kmeans.fit(finance_features).predict(finance_features)

### rename the "name" parameter when you change the number of features
### so that the figure gets saved to a different file
try:
    Draw(pred, finance_features, poi, mark_poi=False, name="clusters.pdf", f1_name=feature_1, f2_name=feature_2)
except NameError:
    print "no predictions object named pred found, no clusters to plot"


# In[ ]:


# Now we do the same but with scaling 

