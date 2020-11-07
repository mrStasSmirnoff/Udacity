#!/usr/bin/python


def outlierCleaner(predictions, ages, net_worths):
    """
        Clean away the 10% of points that have the largest
        residual errors (difference between the prediction
        and the actual net worth).

        Return a list of tuples named cleaned_data where 
        each tuple is of the form (age, net_worth, error).
    """
    
    cleaned_data = []

    ### your code goes here
    
    error = np.empty(len(predictions))
    
    for i in range(len(predictions)):
        
        error[i] = abs(predictions[i] - net_worths[i])
    
    error = np.sort(error,axis=0)
    #error.sort()
    
    index = int(0.9 * len(predictions))
    
    error_cleared = error[:index]
    
    for j in range(len(predictions)):
        
        error = abs(predictions[j] - net_worths[j])
        
        if error in error_cleared:
            
            cleaned_data.append([ages[j], net_worths[j], error])
        
        
    return cleaned_data
