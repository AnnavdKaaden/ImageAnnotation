####################################################################################
# This function calculates the true image area, based on the distance between two  #
# laster dots in the image.                                                        #
#                                                                                  #
#                                                                                  #
# Input required into the function are 1) the colour for the laser label, which is #
# an RGB triplet, e.g. [10, 0, 255].                                               #
# 2) The file name, e.g. "Dive12_Layer1_Label.tif",                                #
# 3) the file type, either "png" or "tiff"                                         #
# and 4) the true distance between the laser dots in meters, e.g. 0.1 m (=10 cm).  #
# Ignore warnings with tiff images.                                                #
#                                                                                  #
# A van der Kaaden, June 2019.                                                     #
####################################################################################

ImageArea <- function(Laserlabel, Filename, Filetype, Distance)
{
  # The png package is required to read in png images. Install by running:
  # install.packages('png',,'http://www.rforge.net/')
  if (Filetype == "png") {
    require(png)
    # Read in image
    img <- round(255*readPNG(Filename))
    # Delete the last column with alpha-data
    img <- img[,,-4]
    # Get the image dimensions
    DimI <- dim(img)
    # Reshape
    img <- matrix(img, ncol=3)
    } else {
  # The rtiff package is required to read in tiff images. Install by running:
  # install.packages('rtiff')
    require(rtiff)
    # Read in image
    img <- readTiff(Filename, pixmap = FALSE)
    # Get the image dimensions
    DimI <- dim(img[[1]])
    # Reshape
    img <- round( matrix( unlist(img), ncol=3))
    }
  
  # Identify all the pixels belonging to the laser dots
  Laserpixels <- apply(img, 1, identical, Laserlabel)
  # Reshape to image size
  Laserpixels <- matrix(Laserpixels, nrow = DimI[1], ncol = DimI[2])
  # Get the coordinates for the laserpixels
  idx <- which(Laserpixels, arr.ind = TRUE)
  # Create empty list for all distances
  Distances <- c()
  # Calculate all the Euclidean distances between pixels
  for (i in 1:dim(idx)[1]) {
    d <- max(sqrt( (idx[i,1]-idx[,1])^2 + (idx[i,2]-idx[,2])^2))
    Distances <- c(Distances, d)
  }
  
  # Maximum distances is
  MaxDist <- max(Distances)
  # The image scale is
  Scale <- Distance/MaxDist
  # True image size in m2 is
  ImSize <- DimI[1]*Scale*DimI[2]*Scale
  
  return(ImSize)
}