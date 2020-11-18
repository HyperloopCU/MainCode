"""
Solve for vector potential produced by alternating magnetic array using the equation
  div((1/mu)*del(A)) - curl(M) = 0
where M is the magnetization field and B = curl(A)
"""
from fenics import *
from mshr import *
import matplotlib.pyplot as plt

l=5 #length of each magnet (x dimension)
w=1 #width of each magnet (y dimension)
h=1 #height of each magnet (z dimension)
num_mags=10 #num of magnets in array
space=0.1 #spacing between magnets (along x dimension)

domain = Rectangle(Point(-num_mags*l,-w),Point(num_mags*l,w))
 #make list of x coordinates of magnets in term of magnet dimensions
xcoords = [-num_mags*l/2 + (l+space)*ii for ii in range(0,num_mags+1)]
#break up into alternating north and south magnets
northx = xcoords[::2]
southx = xcoords[1::2]

#make shapes for
mags_n = [Rectangle(Point(xcoord,-w/2),Point(xcoord+l,w/2)) for xcoord in northx]
mags_s = [Rectangle(Point(xcoord,-w/2),Point(xcoord+l,w/2)) for xcoord in southx]

for (kk, mag) in enumerate(mags_n):
    domain.set_subdomain(kk+1,mag)

for (ll, mag) in enumerate(mags_s):
    domain.set_subdomain(ll+len(mags_n)+1,mag)

mesh = generate_mesh(domain,64)
plot(mesh)
plt.show()
