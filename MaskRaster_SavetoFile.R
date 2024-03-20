# Import libraries
library(terra)

# Set working directory to folder holding all spectral-recovery tool results
setwd("C:/Users/birchmel/Documents/Analysis/")


# Define masking function -------------------------------------------------

# By folder
landcover_mask <- function(folder, metric, index, mask_raster, save_file=FALSE){ #if save_file==TRUE, masked raster will be written to file
  # Identify folder path (containing rasters)
  folder_path <- paste0(folder, '/MaxR4R5/') 
  # Read in raster, remove _reference if needed - indicates the recovery target method
  raster <- rast(paste0(folder_path, metric, '_', index, '_maxR4R5.tif'))
  # Resample to ensure raster alignment and crop mask to raster extent
  mask_new <- resample(mask_raster, raster, method="near")
  # Mask raster
  masked <- mask(raster, mask_new, maskvalues=1, updatevalue=NA)
  
  if (save_file){
    dir_path <- paste0(folder, "/MaskedRasters")
    dir.create(dir_path)
    save_path <- paste0(dir_path, '/', metric, '_', index, '_masked.tif')
    writeRaster(masked, save_path)
  } 
  
  # Return masked raster
  return(masked)
  
}

# By file (made for Y2R) 
landcover_mask_file <- function(filepath, mask_raster){ #if save_file==TRUE, masked raster will be written to file
  # Read in raster, remove _reference if needed - indicates the recovery target method
  raster <- rast(paste0(filepath))
  # Resample to ensure raster alignment and crop mask to raster extent
  mask_new <- resample(mask_raster, raster, method="near")
  # Mask raster
  masked <- mask(raster, mask_new, maskvalues=1, updatevalue=NA)

  # Return masked raster
  return(masked)
  
}

# User inputs necessary for single function run -------------------------------------

# Define name of folder holding tool results, i.e., the tool run
folder <- 'Section3_ToolResults'
# Define metric
metric <- 'R80P'
# Define index
index <- 'NBR'
# Read in master rask
mask_raster <- rast("C:/Users/birchmel/Documents/Analysis/Data/PreprocessedData/LandCover/LandCoverMask.tif")
# Reclassify raster
m <- c(0, 0, 0,
       1, 12, 1)
rcl_matrix <- matrix(m, ncol = 3, byrow = TRUE)
mask_raster <- classify(mask_raster, rcl_matrix, include.lowest=TRUE)


# User inputs necessary for loop: metrics, indices, folder name/path, mask raster -------------------------

# Define name of folder holding tool results, i.e., the tool run
folder <- 'Section3_ToolResults'
# Define metrics
metrics <- c('R80P', 'dNBR', 'YrYr')
# Define indices
indices <- c('NBR', 'NDVI', 'GNDVI', 'NDMI')
# Read in master rask
mask_raster <- rast("C:/Users/birchmel/Documents/Analysis/Data/PreprocessedData/LandCover/LandCoverMask.tif")
# Reclassify raster
m <- c(0, 0, 0,
       1, 12, 1)
rcl_matrix <- matrix(m, ncol = 3, byrow = TRUE)
mask_raster <- classify(mask_raster, rcl_matrix, include.lowest=TRUE)


# Example run: single execution ------------------------------------------------------------

masked_raster_output <- landcover_mask(folder, 'R80P', 'NBR', mask_raster, save_file = TRUE)

masked_raster_output <- landcover_mask_file(paste0(folder, '/OG5/Y2R_reference.tif'),
                                            mask_raster)
writeRaster(masked_raster_output, paste0(folder, "/MaskedRasters/Y2R_masked.tif"))

# Example run: for loop ---------------------------------------------------

# Masks all metric/index combinations in 'folder' using the same mask_raster
# Before running, define folder and mask_raster

# Process and mask rasters, and save them to file
for (i in 1:length(metrics)) { # for each metric
  metric <- metrics[i]
  for (j in 1:length(indices)) { # for each index
    index <- indices[j]
    landcover_mask(folder,
                   metric,
                   index,
                   mask_raster,
                   save_file = TRUE)
  }
  
}


