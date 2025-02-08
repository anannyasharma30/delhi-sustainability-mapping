# Mapping the Sustainability of Delhi: PM2.5 Analysis and Green Spaces Mapping

This project explores the sustainability of Delhi by analyzing PM2.5 levels and mapping green spaces in the city. The code generates visualizations of PM2.5 levels across districts of Delhi and also maps green spaces, traffic-related locations, and pollution-related data.

## Prerequisites

Make sure to have the following R packages installed before running the script:

```r
install.packages(c("tidyverse", "ggplot2", "ggthemes", "ggrepel", "sf", "viridis", "gridExtra"))
```

## Required Datasets

The datasets used in this project can be downloaded from the provided Google Drive folder:

[Google Drive Folder: Datasets](https://drive.google.com/drive/folders/1wqA9hOGnhr6hR8IHWyJktYvLH1f3cLqB?usp=sharing)

Please download the datasets and store them in the appropriate directories on your local machine. Once downloaded, replace the file paths in the code accordingly.

The required datasets are:
- `subdistrict.shp` (Shapefile for Delhi subdistrict boundaries)
- `pm25_pc11dist.csv` (PM2.5 data for each district)
- `state_key.csv` (Key for state identification in the dataset)
- `traffic_delhi_clipped.shp` (Traffic data for Delhi)
- `landuse_delhi_clippedpm25.shp` (Green space data for Delhi)

## Instructions for Running the Script

1. Download the required datasets from the Google Drive link above.
2. Save them to your local machine in the specified file paths.
3. Open the script in RStudio and modify the file paths to point to the location where you saved the datasets.
4. Run the code step-by-step to generate the visualizations.

## Code Walkthrough

### 1. Loading Libraries
The following R packages are loaded to facilitate data manipulation, visualization, and mapping:

```r
library(tidyverse)  # For data manipulation
library(ggplot2)    # For data visualization
library(ggthemes)   # For additional ggplot themes
library(ggrepel)    # For labeling in plots
library(sf)         # For spatial data handling
library(viridis)    # For color scales
```

### 2. Data Loading and Preprocessing

```r
district_shp <- st_read("/path/to/subdistrict.shp")
pm25_shrug_pc_11_district <- read.csv("/path/to/pm25_pc11dist.csv")
state_keys <- read.csv("/path/to/state_key.csv")
```

- The data is loaded into R as spatial objects (`sf` format) or data frames (`csv`).
- The datasets are then merged to combine PM2.5 data with the geographic shapes.

### 3. Filtering Data

The script filters the data for the **NCT of Delhi**:

```r
delhi_pm25 <- delhi_pm25 %>% filter(state_name == "nct of delhi")
district_shp <- district_shp %>% filter(pc11_s_id == "07")
```

### 4. Mapping PM2.5 Data

The script generates three maps showing the **mean**, **maximum**, and **minimum** PM2.5 levels in Delhi's districts:

```r
# Mean PM 2.5
delhi_shp_pm25_mean <- ggplot(delhi_district_shp) + 
  geom_sf(aes(fill = pm25_mean)) + theme_map() + scale_fill_viridis()

# Max PM 2.5
delhi_shp_pm25_max <- ggplot(delhi_district_shp) + 
  geom_sf(aes(fill = pm25_max)) + theme_map() + scale_fill_viridis()

# Min PM 2.5
delhi_shp_pm25_min <- ggplot(delhi_district_shp) + 
  geom_sf(aes(fill = pm25_min)) + theme_map() + scale_fill_viridis()
```

These maps help visualize the distribution of PM2.5 pollution levels across Delhi districts.

### 5. Saving the Output Shapefiles

The final spatial datasets are saved as new shapefiles:

```r
st_write(delhi_district_shp, "/path/to/delhi_pm25.shp", encoding = "UTF-8")
st_write(traffic_delhi, "/path/to/traffic_delhi.shp", encoding = "UTF-8")
st_write(delhi_green, "/path/to/delhi_greenspaces.shp", encoding = "UTF-8")
```

These outputs are stored for further analysis or mapping in GIS software.

### 6. Mapping Traffic and Green Spaces

The script also maps locations related to **traffic** and **green spaces** in Delhi:

- **Traffic-related locations** are filtered and visualized, showing fuel stations and traffic signals.
- **Green spaces** such as parks, forests, and nature reserves are plotted.

### 7. Plotting All Maps Together

The three PM2.5 maps are arranged into a single grid layout for easy comparison:

```r
grid.arrange(delhi_shp_pm25_max, delhi_shp_pm25_mean, delhi_shp_pm25_min, ncol = 3)
```

## Notes

- Ensure that the file paths are correctly set to where you have saved the datasets.
- The maps are visualized using the **viridis** color scale for improved accessibility and interpretation.
- This script generates spatial visualizations that can be useful for understanding pollution levels in various districts of Delhi.
