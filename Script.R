###########################################################
###examples of RBG colour codes 
###########################################################
#red laser [255,0,0]
#live coral [255,255,0]
#dead framework [255,175,0]
#rubble [171,133,46]
#rocks [0,0,0]
#fine sediment [255,215,143]

###########################################################
###load functions and set work directory first
###########################################################
# step 1 Source the ImageArea and PercentCover functions 
# step 2 set working directory to folder with input .PNG files
input_dir<-setwd("E:/project/Images")
#############################################################
### test 1 image first. Here the scale = 0.1 m)
#############################################################
#scale of image based on space between labeled laser dots
Area<-ImageArea(c(255,0,0),"image1.png","png",0.1)
Area
#percentage cover of live, dead, rubble
percent<-PercentCover(t( matrix( c(255, 255, 0, 255, 175, 0,171,133,46), ncol=3, nrow=3)),"image1.png","png")
percent 

#create data frame with file name and scale embedded in .csv
filename<-data.frame("image1.png")
names(filename)<-c("filename")
names(Area)<-c("scale")
names(percent)<-c("live","dead", "rubble")
percent.final<-cbind(filename, percent, Area)
percent.final

################################################################
##loop for all files in folder
################################################################

# import a list of all files
input_files <- list.files(input_dir,pattern= "[.]png")
length(input_files)

# loop for reading total amount of input files (here 44) and writing the output
for(i in 1:44){
  df0 <- ((input_files[i]))
  # functions
  Area<-ImageArea(c(255,0,0),df0[i],"png",0.1) ## I think the problem is with imbedding df0 to refer to the images in the folder
  Percent.res<-PercentCover(t( matrix( c(255, 255, 0, 255, 175, 0, 171,133,46), ncol=3, nrow=3)),df0[i],"png")
  # add in filename
  filename<-data.frame(df0[i])
  names(filename)<-c("filename")
  names(Percent.res)<-c("live","dead", "rubble")
  percent.final<-cbind(filename, percent, Area)
  percent.final
  #export data
  write.csv(percent.final, file = file.path(input_dir, paste0("output", i))) 
}



#############################################################
###combine all .csv files into one .csv data document
#############################################################

file_list <- list.files(input_dir,pattern= "[.]csv")
data <- 
  do.call("rbind", 
          lapply(file_list, 
                 function(x) 
                   read.csv(paste(input_dir, x, sep=''), 
                            stringsAsFactors = FALSE)))


