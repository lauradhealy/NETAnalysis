# NET Analysis

This repo contains code for reproducing analyses of fluorescence image data contained in the papers
* Healy, L. D., Puy, C., Itakura, A., Chu, T., Robinson, D. K., Bylund, A., ... & McCarty, O. J. (2016). Colocalization of neutrophils, extracellular DNA and coagulation factors during NETosis: Development and utility of an immunofluorescence-based microscopy platform. Journal of immunological methods, 435, 77-84.
* Healy, L. D., Puy, C., Fernández, J. A., Mitrugno, A., Keshari, R. S., Taku, N. A., ... & Griffin, J. H. (2017). Activated protein C inhibits neutrophil extracellular trap formation in vitro and activation in vivo. Journal of Biological Chemistry, 292(21), 8616-8629.

In particular, `MATLAB_SignalAnalysis_4August2015.m` analyzse the relative imaged areas of slidebook images: CY3, FITC, and DAPI flouresence images.

The code is broken down into four sections: 

Section 1 defines the direcory location of the exported slidebook tiffs.

Section 2 looks at a specific image, and produces a greyscale and a jet (intensity) scale image of each of the three signals being analyzed (CY3, FITC, and DAPI). It also produces a thresholded image (in both greyscale and jet) and presents a calculation for both the area of the signal and as a percentage of the total image area. Lastly, it produces a figure containing images of how the signals overlap one another and a calcuation of the area of the total overlapping signal. The thresholding values can be adjusted manually to optimize analysis.

Section 3 takes the previously defined threshold values form Section 2 and applies them to each image in the directory, compiling them into a single array containing the name of each image, the area of each of the three signals, the percentage of total area of each of the three signals, and the total area of the overlapped signals.

Section 4 allows the user to choose a save name for this data and store the data as an excell file in the location of their choice. 
