# How to run Order Parameter program:

1. Download orderParameter folder
2. In the same folder create another folder and name it "data" and put all data data sets in there.
3. Open the orderParameter.R program and make sure that setwd which set the working directory is correctly settled (Lines 12 & 17). 
4. source("orderParameter.R")
5. order.parameter("nFile.txt")


## Files:

Create an nFile.txt file  as described below:

* nFile.txt: the  x-axis values that you are interested in, i.e., Tempareture, size, N content (%). The file must be numeracally ordered.

                                      Example nFile.txt file:

                                0,100,200,300,400,500,600,700,800,900,1000
 


## Notes:

The program reads all the .txt files itself  and calculates order parameters.  Our program currently supports only .txt files.
