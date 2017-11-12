#################################
##Example of data interpolation
#Last time used October 2017
#by Andrei Kurbatov
#RICE Time scale Interpolatrion for tephra layers
#required signal package
########load depth age time scale file 1
require(signal)
#change to working directory
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)


#Make it TRUE for PDF file generation
#DO not forget add at the end dev(off)
plotToPDF = TRUE
outputName="RICE_tephraAges"
################
dataFile ="RICE_TS.csv"
data_title="RICE core unpublished data"
############################
pdfFileName=paste("./",outputName,".pdf",sep="")
#####
#sample depths
tephraDepths=c(165.02, 345.44, 391.71, 422.375, 508.78, 622.89,729.595)
#sample IDs
tephraNames=c("antt15", "antt9", "antt13", "antt11","antt266", "antt267", "antt265")
#Adjust plot size by changing parameters on the next line
if(plotToPDF){pdf(pdfFileName, width=11, height=9)}
#Install and Load package signal see help
#Add points from time scale
#read time scale data file 
###Set 1
testconn <- file(dataFile, open="r")
csize <- 10000
nolines <- 0
 while((readnlines <- length(readLines(testconn,csize))) >0 ) Nlines<- nolines+readnlines
close(testconn)
#

depthagefile<-read.table(dataFile,skip=0,sep=",", na.strings = "-99", fill=TRUE, header = TRUE, nrow=Nlines)
print(depthagefile)

print("NO errors")
plot(depthagefile$DepthM,depthagefile$AgeCE, xlab="Depth m", ylab="Age C.E.", col="green",pch=20, main=data_title,sub="")

#Set  calculations
xp <- depthagefile$DepthM
yp <- depthagefile$AgeCE
xf <- tephraDepths
extrap <- TRUE
#lin  <- interp1(xp, yp, xf, 'linear', extrap = extrap)
#use spline function for interpolation
spl  <- interp1(xp, yp, xf, 'spline', extrap = extrap)
points(xf, spl, col = "red", pch=22)
#print calculated ages
calcAge=round(spl, digits=1)
print(calcAge)
text(xf,spl,paste(tephraNames," ",calcAge,"C.E.", sep=" "),pos=4)



#turn off PDF file
if(plotToPDF){dev.off()
# next line will open pdf file in Mac OSX Comment it for other OS's
	system(paste("open", pdfFileName))
}
