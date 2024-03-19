# Import libraries
library(terra)

# Set working directory to folder holding all spectral-recovery tool results
setwd("C:/Users/birchmel/Documents/Analysis/")


# find_max_R4R5 function --------------------------------------------------


# Define a function to find maximum of R4 and R5 values, produce new raster, and save to file
find_max_R4R5 <- function(folder_path, metric, layer_no, index) {
  # Define R4 and R5 folder paths
  yr5_folder <- paste0(folder_path, "/OG5/")
  yr4_folder <- paste0(folder_path, "/OG4/")
  # Read in R5 and R4 rasters
  yr5_raster <- rast(paste0(yr5_folder, metric, "_reference.tif"))
  yr4_raster <- rast(paste0(yr4_folder, metric, "_reference.tif"))
  # Subset necessary layers (for sr tool - layers are indices)
  yr5_layer <- yr5_raster[[layer_no]]
  yr4_layer <- yr4_raster[[layer_no]]
  # Produce new max value raster
  max_value_raster <- max(c(yr5_layer, yr4_layer), na.rm = TRUE)
  # Write max value raster to file
  dir_path <- paste0(folder_path, '/MaxR4R5')
  dir.create(dir_path)
  save_path <- paste0(dir_path, '/', metric, '_', index, '_maxR4R5.tif')
  writeRaster(max_value_raster, save_path)
  
  return(max_value_raster)
}


# User inputs: metrics, indices, folder name/path -------------------------


# Define metrics - R80P, dNBR, and YrYr all rely on a timestep=5 or timestep=4
metrics <- c('R80P', 'dNBR', 'YrYr')
# Define indices calculated using spectral-recovery tool, in order of the tool's calculations (same order as sr.compute_indices)
indices <- c('NBR', 'NDVI', 'GNDVI', 'NDMI')
# Define name of folder holding tool results
folder_path <- 'Section5_ToolResults'



# Use function and process tool results -----------------------------------

# Process and create max value rasters using find_max_R4R5 function
for (i in 1:length(metrics)) { # for each metric
  metric <- metrics[i]
  for (j in 1:length(indices)) { # for each index
    index <- indices[j]
    layer_no <- j
    find_max_R4R5(folder_path, # find max R4R5 and save to file
                  metric,
                  layer_no,
                  index)
  }
  
}

# Process tool results - you can add one more external loop to cycle through multiple restoration areas
# This requires a list of directories and cycling through, 
# setting folder_path to different areas and their corresponding tool results,
# before going through metrics and indices for each area


# Example - What happens in nested INTERNAL loop --------------------------

# max_value <- find_max_R4R5(folder_path = 'Section3_ToolResults',
#                                              metric = 'R80P',
#                                              layer_no = 1, 
#                                             index = 'NBR')
# 
# max_value <- find_max_R4R5(folder_path = 'Section3_ToolResults',
#                                       metric = 'R80P',
#                                       layer_no = 2, 
#                                       index = 'NDVI')
# 
# max_value <- find_max_R4R5(folder_path = 'Section3_ToolResults',
#                                       metric = 'R80P',
#                                       layer_no = 3, 
#                                       index = 'GNDVI')
# 
# max_value <- find_max_R4R5(folder_path = 'Section3_ToolResults',
#                                       metric = 'R80P',
#                                       layer_no = 4, 
#                                       index = 'NDMI')

