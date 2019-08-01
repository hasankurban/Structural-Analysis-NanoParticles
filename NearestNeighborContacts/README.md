# How to run Nearest Neighbor Contacts program:

1. Download NearestNeighborContacts.R and create a folder and put the file in the folder.
2. In the same folder create another folder and name it "data" and put all data data sets in there.
3. Open the NearestNeighborContacts.R program and make sure that setwd which set the working directory is correctly settled (Lines 15 and 17). 
4. source("NearestNeighborContacts.R")
5. nearest.neighbor.contacts("elements.txt", "nFile.txt")


## Files:

Create elements.txt and nFile.txt files as described below:

* elements.txt: Known theoritical values. Example of the file is given below:

                                         N-N , O-O,  Zn-Zn, N-O, N-Zn, O-Zn

                                        1.098, 1.208, 4.19, 1.154,    ,  

If the value is not known, use blank insted. The file must alphabettically be ordered based on the variable names.

* nFile.txt: the  x-axis values that you are interested in, i.e., Tempareture, size, N content (%). The file must be numeracally ordered.

                                      Example nFile.txt file:

                                0,100,200,300,400,500,600,700,800,900,1000
 


## Notes:

The program reads all the .txt files and calculates nearest neighbor contacts for each element. Our program currently supports only .txt files.
