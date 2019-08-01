# @Hasan Kurban, July 2019
# For questions, contact hakurban@gmail.com
# Function that calculates the order parameter (R) 
order.parameter <- function(nFile){
  suppressMessages(library(tidyr))
  require(ggplot2)
  require(tidyr)
  require(dplyr)
  require(reshape2)
  #nFile is the x-axis values that we are interested in, i.e., Temparature, size
  nFile <- t(as.matrix(read.table("nFile.txt",sep=",")))
  setwd("../data")
  filelist = list.files(pattern = ".txt")
  print(filelist)
  datalist = lapply(filelist, function(x)read.table(x, header=F))
  print("The data files are read by the following order:")
  setwd("../orderParameter/")
  tempData = as.data.frame(datalist[1])
  elementNumber <- nlevels(tempData[,1]) # number of factor levels
  total.count.frame<- matrix(nrow=1, ncol=(nlevels(tempData[,1])))
  for (a in 1:length(datalist)){
  data <- as.data.frame(datalist[a])
  orderedData <- data[order(data[,1]),] # order data based on the factor variable
  orderedData[,2:dim(orderedData)[2]] <- scale(orderedData[,2:dim(orderedData)[2]])
  #matrix to put on the final values
  # frequencies of the categorical variable
  freq <- as.data.frame(table(orderedData[,1]))[,2]
  temp =1 # for indexing in the loop
  temp2 = freq[1] # for indexing in the loop
  final.result <- matrix(nrow=1, ncol=nlevels(data[,1]))
  for (i in 1:elementNumber){
    all.sum <- as.matrix(sqrt(apply(orderedData[,2:dim(orderedData)[2]]^2,1,sum)))
    final.result[1,i] <- sum(all.sum[temp:temp2,1])/freq[i]
    temp = freq[i] +1
    temp2 = freq[i] +freq[i+1]  
  }
  total.count.frame <- rbind(total.count.frame, final.result)
  }
  #remove the NA row 
  total.count.frame <- total.count.frame[2:dim(total.count.frame)[1],]
  #add nFile
  total.count.frame =  as.data.frame(cbind(nFile,total.count.frame))
  names = "n"
  for (j in 1:elementNumber){
  names = append(names, levels(data[,j]))
  }
  names(total.count.frame) = names
  print(total.count.frame)
  
  data = total.count.frame
################################ FIGURE #################################
  data= data %>% gather(variable, value, -n) 
  figure <- ggplot(data=data, aes(x=n, y=value, group = variable, colour = variable)) +
    geom_line() + geom_point( size=4, shape=21, fill="white")  +ylab("R")+ xlab("Temperature (K)")+
    theme_bw() + theme(legend.title=element_blank(), panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position = c(0.85, 0.5))
  print(figure)
  ggsave("orderParameterFigure.tiff",figure)
}