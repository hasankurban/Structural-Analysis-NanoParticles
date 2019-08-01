# How to run Radial Distribution Function (RDF) program:

1. Download rdf folder
2. In the same folder create another folder and name it "data" and put all data data sets in there.
3. Open the rdf.R program and make sure that setwd which set the working directory is correctly settled (Lines 4 and 8). 
4. source("rdf.R")
5. rdf()

## Notes: 

- default dr value is 0.2 and can be changes if needed.
- The program reads all the .txt files and plots a rdf figure for each data set and save the plots to the same directory


