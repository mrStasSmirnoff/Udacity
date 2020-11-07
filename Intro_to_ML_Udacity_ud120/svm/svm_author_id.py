#!/usr/bin/python

""" 
    This is the code to accompany the Lesson 2 (SVM) mini-project.

    Use a SVM to identify emails from the Enron corpus by their authors:    
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

print(features_train.shape)
print(features_test.shape)

clf = SVC(kernel='linear')
t0 = time()
clf.fit(features_train,labels_train)
print "training time:", round(time()-t0, 3), "s"

t1 = time()
pred = clf.predict(features_test)
print "predict time:", round(time()-t1, 3), "s"


t2 = time()
score = clf.score(features_test, labels_test)
print "scoring time:", round(time()-t2, 3), "s"
print(score)

# A Smaller Training Set

#features_train = features_train[:len(features_train)/100]
#labels_train = labels_train[:len(labels_train)/100]

# Now lets take RBF kernel and compare the training time

clf = SVC(kernel='rbf',C =10000,gamma = 1e-3)
t3 = time()
clf.fit(features_train,labels_train)
print "training time:", round(time()-t3, 3), "s"


t4 = time()
pred = clf.predict(features_test)
print "predict time:", round(time()-t4, 3), "s"

t5 = time()
score = clf.score(features_test, labels_test)
print "scoring time:", round(time()-t5, 3), "s"
print(score)


print "10th element: ", pred[10], \
      "\n26th element: ", pred[26], \
      "\n50th element: ", pred[50]

# The number of predictions equal to class 1 == 'Chris'
print """The number  predicted to be in the "Chris": """, sum(pred == 1)

