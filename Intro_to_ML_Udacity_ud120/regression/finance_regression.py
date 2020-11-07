
# coding: utf-8

# In[ ]:


"""
    Starter code for the regression mini-project.
    
    Loads up/formats a modified version of the dataset
    (why modified?  we've removed some trouble points
    that you'll find yourself in the outliers mini-project).

    Draws a little scatterplot of the training/testing data

    You fill in the regression code where indicated:
"""    


import sys
import pickle
sys.path.append('/upb/users/s/ssmirnov/profiles/unix/imt/Courses_and_Preparation/Intro_to_Machine_Learning_Udacity/Intro_to_ML_-Udacity_ud120-/tools/')
from feature_format import featureFormat, targetFeatureSplit


# In[ ]:


dictionary = pickle.load( open("../final_project/final_project_dataset_modified.pkl", "r") )


# In[ ]:


### list the features you want to look at--first item in the 
### list will be the "target" feature

features_list = ["bonus", "salary"]
data = featureFormat( dictionary, features_list, remove_any_zeroes=True)
target, features = targetFeatureSplit(data)
print(data.shape)


# In[ ]:


### training-testing split needed in regression, just like classification
from sklearn.cross_validation import train_test_split
feature_train, feature_test, target_train, target_test = train_test_split(features, target, test_size=0.5, random_state=42)
train_color = "b"
test_color = "r"


# In[ ]:


### Your regression goes here!
### Please name it reg, so that the plotting code below picks it up and 
### plots it correctly. Don't forget to change the test_color above from "b" to
### "r" to differentiate training points from test points.

from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score

reg = linear_model.LinearRegression()
reg.fit(feature_train,target_train)
pred = reg.predict(feature_test)

# The Slope
print('Slope:',reg.coef_[0])

# The Intersect
print('Intersect ',reg.intercept_)

train_score = reg.score(feature_train, target_train)
test_score = reg.score(feature_test, target_test)
print ('Regression score of test data %f' % test_score)


# In[ ]:


### draw the scatterplot, with color-coded training and testing points
import matplotlib.pyplot as plt

for feature, target in zip(feature_test, target_test):
    plt.scatter(feature, target, color=test_color) 
for feature, target in zip(feature_train, target_train):
    plt.scatter(feature, target, color=train_color) 

### labels for the legend
plt.scatter(feature_test[0], target_test[0], color=test_color, label="test")
plt.scatter(feature_test[0], target_test[0], color=train_color, label="train")


# In[ ]:


### draw the regression line, once it's coded
try:
    plt.plot(feature_test, reg.predict(feature_test) )
except NameError:
    pass

#reg.fit(feature_test, target_test)
#plt.plot(feature_train, reg.predict(feature_train), color="b") 
# The Slope
#print('Slope:',reg.coef_[0])

plt.xlabel(features_list[1])
plt.ylabel(features_list[0])
plt.legend()
plt.show()

