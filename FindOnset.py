import numpy


    
def indices(a, func):
    return [i for (i, val) in enumerate(a) if func(val)]

def findOnset(x):
    temp = x[0:800]
    mean_temp = numpy.mean(temp)
    std_temp = numpy.std(temp)    
    mov = indices(x, lambda t: t <= mean_temp-3*std_temp )
    onset = mov[0]
    return onset
    
print findOnset([1 for x in xrange(10000)])

    
