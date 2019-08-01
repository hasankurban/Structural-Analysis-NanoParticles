# How to run Nearest Neighbor Contacts program:

* source("NearestNeighborContacts.R")
* nearest.neighbor.contacts("elements.txt", "nFile.txt")


## Files (What is need to run it):

* The directory where all different geometrical data files located should be updated in the code.

* elements.txt: Known theoritical values. Example of the file is given below:

N-N , O-O, Zn-Zn,N-O,N-Zn,O-Zn

1.098, 1.208,4.19,1.154,    ,  

If the value is not known, use blank insted. The file must alphabettically be ordered based on the variable names.

* nFile.txt: the  x-axis values that you are interested in, i.e., Tempareture, size, N content (%).

Example nFile.txt file:

0,100,200,300,400,500,600,700,800,900,1000
 
The file must be numeracally ordered

## Notes:

The programs reads all the .txt files and calculates nearest neighbor contacts for each element.
