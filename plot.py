#to plot the curve
import numpy as np
import matplotlib.pyplot as plt

#b,z,x,y from running polyfit-tone.py

f=np.poly1d(z)
x_new=np.linspace(x[0],x[-1],50)
y_new=f(x_new)
plt.plot(x,y,'o',x_new,y_new)
plt.xlim([x[0]-0.001,x[-1]+0.001])
plt.show()	