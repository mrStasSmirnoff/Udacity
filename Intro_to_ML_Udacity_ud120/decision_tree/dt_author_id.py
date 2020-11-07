#!/usr/bin/python

""" 
    This is the code to accompany the Lesson 3 (decision tree) mini-project.

    Use a Decision Tree to identify emails from the Enron corpus by author:    
    Sara has label 0
    Chris has label 1
"""
    
import sys
from time import time
sys.path.append("../tools/")
from email_preprocess import preprocess


### features_train and features_test are the features for the training
### and testing datasets, respectively
### labels_train and labels_test are the corresponding item labels
features_train, features_test, labels_train, labels_test = preprocess()





# coding: utf-8

# In[3]:


#!/usr/bin/python

""" 
    This is the code to accompany the Lesson 3 (decision tree) mini-project.

    Use a Decision Tree to identify emails from the Enron corpus by author:    
    Sara has label 0
    Chris has label 1
"""
    
import sys
from time import time
sys.path.append('/upb/users/s/ssmirnov/profiles/unix/imt/Courses_and_Preparation/Intro_to_Machine_Learning_Udacity/Intro_to_ML_-Udacity_ud120-/tools/')
from email_preprocess import preprocess
from sklearn import tree

### features_train and features_test are the features for the training
### and testing datasets, respectively
### labels_train and labels_test are the corresponding item labels
features_train, features_test, labels_train, labels_test = preprocess()


# In[5]:


[samples_train_size,features_train_size] = features_train.shape
print(samples_train,features_train_size)


# In[6]:


clf = tree.DecisionTreeClassifier(min_samples_split = 40)
clf.fit(features_train, labels_train)
score = clf.score(features_test,labels_test)


# In[7]:


print(score)




