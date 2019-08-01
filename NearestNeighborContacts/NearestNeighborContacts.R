nearest.neighbor.contacts <- function(elementFile,nFile) {
  suppressMessages(library(tidyr))
  require(ggplot2)
  require(tidyr)
  require(dplyr)
  require(reshape2)
#elementsFile: Theoritical bond numbers for comparison,NAs slots must be blank in the data
  elements <- read.table(elementFile,sep =",",header=T,comment.char = "", check.names = FALSE,fill=TRUE)
  temp1000 = dim(elements)[2]
  temp1000.data = elements
#nFile is the x-axis values that we are interested in, i.e., Temparature, size
  nFile <- t(as.matrix(read.table("nFile.txt",sep=",")))
  #read all the .txt files
  print("The data files are read by the following order:")
  setwd("../data")
  filelist = list.files(pattern = ".txt")
  print(filelist)
  datalist = lapply(filelist, function(x)read.table(x, header=F))
  setwd("../nearestNumberContacts/")
  total.count.frame <- matrix(nrow=1, ncol=dim(elements)[2])
  for (a in 1:length(datalist))
  {
    elements <- read.table(elementFile,sep =",",header=T,comment.char = "", check.names = FALSE,fill=TRUE)
    elements <-  1.2 * elements 
    data <- as.data.frame(datalist[a])
    orderedData <- data[order(data[,1]),] # order data based on the factor variable
    # mean normalization
    orderedData[,2:dim(orderedData)[2]] <- scale(orderedData[,2:dim(orderedData)[2]])
    dimension.data= dim(orderedData)[2]
    frequncies <- as.data.frame(table(orderedData[,1])) # frequencies of each element
    elementNumber = nlevels(data[,1])
    elementasFactors = levels(data[,1])
    #################################################################################################################
    #HANDLING SHORT ELEMENTS LIST, example:in one file we have N,O,Zu, short element list is missing one of them
    if((elementNumber +combn(elementNumber,2)) < dim(elements)[2]){
      short.names = c()
      for(i in 1:elementNumber){
        temp =  paste(elementasFactors[i],elementasFactors[i],sep = "-")
        short.names = append(short.names,temp)
      }
      combine.names = matrix(ncol=elementNumber,nrow =elementNumber)
      for(i in 1:elementNumber){
        for(j in 1:elementNumber){
          if(i>=j) next
          combine.names[i,j] = paste(levels(data[,1])[i],levels(data[,1])[j],sep = "-")
        }
      }
      combine.names = na.omit(c(combine.names))
      short.names = append(short.names,combine.names)
      elements = elements[,short.names]
    }
    #################################################################################################################
    #calculating count of nearest neighbor contacts between the same elements
    temp1 <- 1; temp2 <-frequncies[1,2] 
    temp.same.count = c()
    for(k in 1:nlevels(data[,1])){
      if (is.na(elements[1,k]) ==TRUE ) {
        temp1 <- temp1 + frequncies[k,2]
        temp2 <- temp2 + frequncies[k+1,2]
        temp.same.count = append(temp.same.count,NA)
        next
      }
      newData <-orderedData[temp1:temp2,]
      #pairwise distances in a data frame
      newData.distance <-  as.data.frame(as.matrix(dist(as.matrix(newData[,2:dimension.data]), method = "euclidean", diag = TRUE,
                                                        upper = TRUE, p = 2)))
      count.element <- as.matrix((table(newData.distance <= elements[1,k])["TRUE"]-frequncies[k,2])/2)[1]
      temp.same.count = append(temp.same.count,count.element)
      temp1 <- temp1 + frequncies[k,2]
      temp2 <- temp2 + frequncies[k+1,2]
    }
    #################################################################################################################
#calculating count of nearest neighbor contacts between different elements
    # detect indexes for subsamples
    temp.diffent.count = c()
    if (dim(combn(elementNumber,2))[2] > 1 ){
    find.data <-  data.frame(matrix(NA, nrow = 1, ncol = 2))
    temp3 =1 
    temp4 = frequncies[1,2]
    h =0
    for (l in 1:elementNumber){
        find.data[l,] = as.matrix(c(temp3,temp4), ncol=2)
        temp3 = temp4 +1
        temp4 = temp4 + frequncies[l+1,2]
    }
    for(i in 1:dim(combn(elementNumber,2))[2]){
      for(j in 2:dim(combn(elementNumber,2))[2]){
        if (i>=j) next
        if (is.na(elements[1,(elementNumber+h+1)]) ==TRUE) {
          temp.diffent.count = append(temp.diffent.count, NA)
          next
        }
        h = h+1
        final.data <- rbind(orderedData[find.data[i,1]:find.data[i,2],],
                            orderedData[find.data[j,1]:find.data[j,2],])
        newData.distance <-  as.data.frame(as.matrix(dist(as.matrix(final.data[,2:dimension.data]), method = "euclidean", diag = TRUE,
                                                          upper = TRUE, p = 2)))
        count= 0
        for(v in (frequncies[i,2]+1):dim(newData.distance)[1]){
          for(z in 1:(frequncies[i,2])){
            if((newData.distance[v,z] <= elements[1,elementNumber+h]) == TRUE){
              count = count+1
            }
          }
        }
        temp.diffent.count = append(temp.diffent.count,count)
      }
    }
    }
    else{
      if (is.na(elements[1,elementNumber+1] == TRUE)){
        temp.diffent.count = append(temp.diffent.count, NA)
      }
      else {
      newData.distance <-  as.data.frame(as.matrix(dist(as.matrix(orderedData[,2:dimension.data]), method = "euclidean", diag = TRUE,
                                                          upper = TRUE, p = 2)))
      count = 0
      for(i in (frequncies[1,2]+1):dim(data)[1]){
        for(j in 1:(frequncies[1,2])){
          if((newData.distance[i,j] <= elements[1,3]) == TRUE){
            count = count +1
          }
        }
      }
      temp.diffent.count = append(temp.diffent.count,count)
      }
    }
    temp.count = t(as.matrix(append(temp.same.count, temp.diffent.count)))
    if (length(temp.count) < temp1000){
      for (p in 1:(temp1000-length(temp.count))){
        temp.count = append(temp.count,NA)
      }
      temp.count = t(as.matrix(temp.count))
      temp.index = c()
      for ( r in 1:length(short.names))
      {
        temp.index = append(temp.index, grep(short.names[r], colnames(temp1000.data)))
      }
      real.data <- temp.count[,1:length(short.names)]
      for (o in 1: length(short.names)){
        temp.count[,temp.index[o]]<- real.data[o]
      }
      temp.count[, -temp.index] <- NA
    }
#################################################################################################################
    total.count.frame <- rbind( total.count.frame, temp.count)
  }
  #remove the NA row 
  total.count.frame <- total.count.frame[2:dim(total.count.frame)[1],]
  #add total column
  total.count.frame <- cbind( total.count.frame, as.matrix(rowSums(total.count.frame,na.rm = TRUE)))
  # add nFile
  total.count.frame =  cbind(nFile,total.count.frame)
#################################################################################################################
# assign the column names
  names = "n"
  noMissingNames = colnames(elements)
  for(i in 1:length(noMissingNames)){
    names = append(names,noMissingNames[i])
  }
  names = append(names,"Total")
  total.count.frame <- as.data.frame(total.count.frame)
  names(total.count.frame) = names
  # remove columns if all is missing
  total.count.frame =   total.count.frame[,colSums(is.na(total.count.frame))<nrow( total.count.frame)]
  write.table(total.count.frame, "NNdata.txt",sep=",",row.names = FALSE)
  print(total.count.frame)
############################################### FIGURE  ###############################################
# Here plot we plot one categorical variabel against several continous variables for comparison
  for(i in 2:dim(total.count.frame)[2]){
    total.count.frame[,i] <- log2(total.count.frame[i])  
  }
  total.count.frame= total.count.frame  %>% gather(variable, value, -n) 
  figure <- ggplot(data=total.count.frame, aes(x=n, y=value, group = variable, colour = variable)) +
  geom_line() + geom_point( size=4, shape=21, fill="white")  +ylab("Log of number of bonds")+ xlab("Temperature (K)")+
  theme_bw() + theme(legend.title=element_blank(), panel.grid.major = element_blank(),
                                                      panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position = c(0.85, 0.3))
 print(figure)
 ggsave("NNcontactsFigure.tiff",figure)

}
