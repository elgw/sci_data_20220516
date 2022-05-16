# sci_data_20220516

## Requirements:
 - [MATLAB R2020b](https://se.mathworks.com/products/matlab.html)
 - [DOTTER Apr. 2022](https://www.github.com/elgw/dotter/)
 - [deconwolf v0.0.1](https://github.com/elgw/deconwolf)
 - [radiantkit](https://github.com/ggirelli/radiantkit)

## How to reproduce the results:
 - Create a folder, place the nd2 files there and convert them to
   tif with radiantkit.
 - Deconvolve the dapi channel using 60 iterations with deconwolf.
 - Edit the path to the images in **data_definition.m**
 - Run **nuclei_segmentation.m** for semi-automatic segmentation.
 - Run **nuclei_statistics.m** to extract integral nuclei intensities per nuclei and channel to **nuclei_statistics_raw_48slice.tsv**
 - Run **plot_nuclei_statistics.m** to plot the data and save as images in the subfolder **nuclei_statistics_raw_48slice.tsv_plots/**.
