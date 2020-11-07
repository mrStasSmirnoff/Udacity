#!/usr/bin/python


# coding: utf-8

# In[2]:

""" 
    Starter code for exploring the Enron dataset (emails + finances);
    loads up the dataset (pickled dict of dicts).

    The dataset has the form:
    enron_data["LASTNAME FIRSTNAME MIDDLEINITIAL"] = { features_dict }

    {features_dict} is a dictionary of features associated with that person.
    You should explore features_dict as part of the mini-project,
    but here's an example to get you started:

    enron_data["SKILLING JEFFREY K"]["bonus"] = 5600000
    
"""

import pickle
import pandas as pd

enron_data = pickle.load(open("../final_project/final_project_dataset.pkl", "r"))


# In[15]:


enron_data.values()


# In[3]:


# Find the number of persons in a dataset (# keys)

print(len(enron_data.keys()))


# In[4]:


# Find the number of features of each key (# values)

len(enron_data.values()[1])


# In[5]:


# Find the amount of persons of interest

poi= 0
name_list = []
emails = []

for i in range(len(enron_data.values())):
    
    if enron_data.values()[i]['poi'] == True:
        
        poi += 1
        
        name_list.append(enron_data.keys()[i])
        
        emails.append(enron_data.values()[i]['email_address'])
        
    
print('Number of person of interest: %d ' % poi)
print("List of the names of thses POI :", name_list)
print("Corresponding emails :", emails)


# In[6]:


# It also can be done in the following way

poi= 0
name_list = []
emails = []

for i in enron_data:
    
    if enron_data[i]['poi'] == 1:
        
        poi += 1
        
        #print(enron_data[i])
        
        
    
print('Number of person of interest: %d ' % poi)


# In[7]:


# Find the amount of POI from the .txt file

data = pd.read_csv('../final_project/poi_names.txt',sep=',',skiprows = 1,header=None)
print('Number of person of interest: %d ' % len(data))


# In[13]:


# What is the total value of the stock belonging to James Prentice?

print('The total value of the stock belonging to James Prentice:',  enron_data['PRENTICE JAMES']['total_stock_value'])


# In[17]:


# How many email messages do we have from Wesley Colwell to persons of interest?

print('The amount of email messages do we have from Wesley Colwell to persons of interest', enron_data['COLWELL WESLEY']['from_this_person_to_poi'])


# In[18]:


# What’s the value of stock options exercised by Jeffrey K Skilling?

print('The value of stock options exercised by Jeffrey K Skilling', 
      enron_data['SKILLING JEFFREY K']['exercised_stock_options']
)


# In[27]:


# Of these three individuals (Lay, Skilling and Fastow), 
# who took home the most money (largest value of “total_payments” feature)?

top_management = ['SKILLING JEFFREY K','LAY KENNETH L','FASTOW ANDREW S']
value = 0

for name in top_management:
    
    total_payments = enron_data[name]['total_payments']
    
    print(name, total_payments)
    
    if total_payments > value:
        value  = total_payments
        
print(value)
    


# In[38]:


# How many folks in this dataset have a quantified salary? 
# What about a known email address?

people = 0
counter_salary = 0
counter_email = 0
counter_total_payments_NaN = 0
counter_poi_payments_NaN = 0

for name in enron_data:
    
    people = people + 1
    
    person_name = enron_data[name]
    
    if enron_data[name]['salary'] != 'NaN':
        
        counter_salary += 1
        
    if enron_data[name]['email_address'] != 'NaN':
        
        counter_email += 1
        
    if enron_data[name]['total_payments'] == 'NaN':
        
        counter_total_payments_NaN += 1
        
    
    if person_name['poi'] and person_name['total_payments'] == 'NaN':
        
        counter_poi_payments_NaN +=1
        
        
print('The amount of folks in this dataset who have a quantified salary', counter_salary)
print('The amount of folks in this dataset who have an email address', counter_email)
print('Number of people having NaN total payments',counter_total_payments_NaN)
print('Percent people without total payments:', float(people - counter_total_payments_NaN)/float(people))
print('Number of POIs with NaN total payments:', counter_poi_payments_NaN)


# In[40]:


# What is the new number of people of the dataset? What is the new number of folks 
# with “NaN” for total payments?

print(len(enron_data.keys())+10)
print(counter_total_payments_NaN+10)


