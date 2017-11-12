#################################
##Example of data interpolation
#Last time used October  2017
#by Andrei Kurbatov
#calculateSampleAges using interpolatrion from age/depth model
#required signal package
########load depth age time scale file 1
require(signal)
#change to working directory
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

################MAKE CHANGES HERE
outputName="WAIS_sampleAges"
##################
#Change to Age Model file in CSV format
#
#
# Age column name must be YearBP
# The depth column name must be Depth
#
#
#
#
ageModel ="WD2014_26Aug2014.csv"
##################
samplesDepth ="WAIS_samplesDepths.csv"
# The depth column name must be labeled Depth
data_title="WDC-06 ice core"
#Make it TRUE for PDF file generation
plotToPDF = TRUE
############################ DO NOT CHANGE BELOW THIS LINE
pdfFileName=paste("./",outputName,".pdf",sep="")
csvSamplesAges=paste("./",outputName,".csv",sep="")
#####

#Adjust plot size by changing parameters on the next line
if(plotToPDF){pdf(pdfFileName, width=11, height=9)}
################################################################## 
#read time scale data file 
#Set 1
#calculate number of lines
testconn <- file(ageModel, open="r")
csize <- 10000
nolines <- 0
 while((readnlines <- length(readLines(testconn,csize))) >0 ) Nlines<- nolines+readnlines
close(testconn)
# END calculate number of lines

depthagefile<-read.table(ageModel,skip=0,sep=",", na.strings = "-99", fill=TRUE, header = TRUE, nrow=Nlines)
print("NO errors in reading age model file")
########################## end read time scale data file 
################################################################## 
#read samples depth data file 
#Set 2
#calculate number of lines
testconn1 <- file(samplesDepth, open="r")
csize <- 10000
nolines <- 0
 while((readnlines <- length(readLines(testconn1,csize))) >0 ) Nlines1<- nolines+readnlines
close(testconn1)
# END calculate number of lines

sDepths <-read.table(samplesDepth,skip=0,sep=",", na.strings = "-99", fill=TRUE, header = TRUE, nrow=Nlines1)
print("NO errors in reading sample depths model file")
########################## end read time scale data file

plot(depthagefile$Depth,depthagefile$YearBP, xlab="Depth m", ylab="Age ", col="green",pch=20, main=data_title,sub="")

#Set  calculations
xp <- depthagefile$Depth
yp <- depthagefile$YearBP
print(sDepths)
xf <- sDepths$Depth
extrap <- TRUE
#################################
#use spline function for interpolation
spl  <- interp1(xp, yp, xf, 'spline', extrap = extrap)
points(xf, spl, col = "red", pch=22)
######################################OUTPUT sample ages
print("Calculated Ages")
print(spl)
# Write CSV in R
write.table(spl, file = csvSamplesAges,row.names=FALSE, na="",col.names="AgeYr", sep=",")

######################################
#turn off PDF file
if(plotToPDF){dev.off()
# next line will open pdf file in Mac OSX Comment it for other OS's
	system(paste("open", pdfFileName))
}
