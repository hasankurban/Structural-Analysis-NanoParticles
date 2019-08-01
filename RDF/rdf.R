rdf<- function(dataFile, dr=0.2){
  require("ggplot2")
  print("The data files are read by the following order:")
  setwd("../data")
  filelist = list.files(pattern = ".txt")
  print(filelist)
  datalist = lapply(filelist, function(x)read.table(x, header=F))
  setwd("../RDF/")
  plot_list = list()
  for (a in 1:length(datalist)){
  data <- as.data.frame(datalist[a])
  # order data based on the factor variable
  orderedData <- data[order(data[,1]),] 
  # center the data, mean normalization
  orderedData[,2:dim(orderedData)[2]] <- scale(orderedData[,2:dim(orderedData)[2]])
  # atom number = length.data
  length.data = dim(orderedData)[1]
  # number of H and Cu atams = frequncies
  frequncies <- as.data.frame(table(orderedData[,1]))
  # indexes to rotate between elements, Cu and H in the loop
  temp1 <- 1; temp2 <-frequncies[1,2] 
  # calculate each point's distance from the center (0,0,0)
  row.distances <-as.data.frame(as.matrix((sqrt(apply(orderedData[,2:4]^2,1,sum)))))    # elements and distances are together
  data.distances <-cbind(as.data.frame(orderedData[,1]), row.distances)
  #order data.distances based on the elements
  data.distances<- data.distances[order(data.distances[,1]),]
  # rename columns
  names(data.distances) = c("element", "dist")
  result.data.last = c() 
  for(k in 1: nlevels(orderedData[,1])) { 
  # slice the data for each elements
  cut.data.distances <-data.distances[temp1:temp2,]
  # choose r, we choose it from distances 
  r =cut.data.distances[,2]
 ########################################################################### 
  # temporary vectores for storing data
  result.data = c()  
        for(i in 1:length(r)){
            # find the number of data points in the shell = local.points.count
            local.points.count = sum(cut.data.distances[,2] >= r[i] & cut.data.distances[,2] <= (r[i]+dr) , na.rm=TRUE)
            # ikinci secenek (r[i] +dr)^3
            volume.shell =(frequncies[k,2]) /(4/3 * pi * (r[i])^3)
            #ikinci secenek frequncies[k,2] yerine length.data yi koy
            # local.density = rdf
            local.density <- local.points.count/(frequncies[k,2] * 4 * pi * r[i]^2 * dr * volume.shell)
            result.data[i] = local.density
        }
    result.data.last <-  c(result.data.last,result.data)
    temp1 <- temp1 + frequncies[k,2]
    temp2 <- temp2 + frequncies[k+1,2]
  }  
    result.data.last <- result.data.last *1000
    result.data.last = as.data.frame(cbind(data.distances, result.data.last))
    names(result.data.last) <- c("Element","r", "rdf")
     
############################### PLOT: SMOOTHING ####################################    
    figure <- ggplot(data=result.data.last, aes(x=r, y=rdf, colour=Element)) + labs(y = "RDF")+
    stat_smooth(span =0.5,se=F) + theme(legend.position="bottom") +
      scale_y_continuous(limit = c(0,max(result.data.last$rdf)))+
      theme_bw() + theme( panel.grid.major = element_blank(),
                          panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position = c(0.15, 0.9))+
      theme(legend.title=element_blank())
      #suppressMessages(print(figure))
      filename= figure
      ggsave(figure, file=paste0("RDF_", a,".tiff"))
  }
}