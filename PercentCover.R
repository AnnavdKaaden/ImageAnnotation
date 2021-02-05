####################################################################################
# This function calculates the percentage that a certain class covers in a picture #
# ('Cover'). The class is previously defined by the user, it can be a species or a #
# group of species.                                                                #
#                                                                                  #
# Input required into the function are 1) the label colours, which are defined by  #
# 3-digit vectors. So, 'Labels' is a matrix of size nx3, where n is the number of  #
# labels. The type is RGB colours, ranging from 0 to 255 (provided that the image  #
# is png or tif). Example: if there are two labels with colours [255, 230, 28] and #
# [0, 28, 229] Labels = t( matrix( c(255, 230, 28, 0, 28, 229), ncol=2, nrow=3)).  #
#                                                                                  #
# 2) the file name, which is a character string. File type should be png or tif.   #
# Example: Filename = "ROV_Dive12_Layer18.tif"                                     #
# 3) Filetype is "png" or "tif". Ignore warnings with tiff.                        #
#                                                                                  #
# A van der Kaaden, June 2019.                                                     #
####################################################################################

PercentCover <- function(Labels, Filename, Filetype)
{
  # The png package is required to read in png images. Install by running:
  # install.packages('png',,'http://www.rforge.net/')
  if (Filetype == "png") { 
    require(png)
    # Read in image
    img <- round(255*readPNG(Filename))
    # Delete the last column with alpha-data
    img <- img[,,-4]
    # Get the dimensions of the image
    DimI <- dim(img)
    # Reshape
    img <- matrix(img, ncol = 3)
    } else {
  # The rtiff package is required to read in tiff images. Install by running:
  # install.packages('rtiff')
    require(rtiff)
    # Read in image
    img <- readTiff(Filename, pixmap = FALSE)
    # Get the dimension of the image
    DimI <- dim(img[[1]])
    # Reshape
    img <- round(matrix(unlist(img), ncol=3))
    }
  # Get the number of classes
  DimL <- dim(Labels)
  
  # Emtpy list with cover
  Cover <- c()
  
  # For all classes in 'Labels' do:
  for (i in 1:DimL[1]) {
  # Check whether the label colour is in the image
    Pixels_in_class <- apply(img, 1, identical, Labels[i,])
  # Calculate the percentage cover
    Percentage <- 100*(sum(Pixels_in_class, na.rm = TRUE)/(DimI[1]*DimI[2]))
    Cover <- c(Cover,Percentage)
  }
  return(Cover)
}