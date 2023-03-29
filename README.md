# Analysis of cow embryos
  
## Synopsis

This ImageJ tool enables systematic image analyses to evaluate mammalian embryos produced in vitro (or in vivo). The tool is developed to detect nuclei, lipids and apoptotic cells (using TUNEL) in produced blastocysts. It identifies and assesses the volume of separate objects (nuclei/lipids) and overlap between fluorophores (i.e., TUNEL + nuclei stain). This allow investigation of endpoints such as: 

- Cell count in blastocysts (amount of nuclei)
- Lipid droplet count in blastocysts (amount of lipid droplets) 
- Lipid droplet volume (average lipid droplet volume and estimation of total lipid volume in each embryo)

## Tool explanation

In the original Per Object Ellipsefit (POE), a threshold is set to optimize the ellipse fit of an object, given that it fulfils the input criteria (minimum and maximum diameter). The segmentation method has been developed as a 2D version but is also available in 3D. A drawback with this method arise when brighter objects are touching darker objects. The threshold might then be optimized for the brighter object and may therefore not include the darker object at all. To overcome this challenge, an iterative version of the POE was developed. After the segmentation, the resulting mask are kept as a “seed” (containing the segmented objects but eroded two pixels). After this, the segmented objects are masked from the raw image by turning all identified voxels in objects black. The segmentation will then be repeated on the raw image and the mask will be merged with the previously segmented objects while the “seed” is merged with the previous “seed” image. These steps will be repeated until no more objects are segmented. The objects in the resulting merged mask can then be separated using the 3D Watershed Split function in ImageJ (the combined mask: input, the combined “seed”: seed). The nuclei and the lipids are then segmented by applying a global grey-level threshold based on object size (SizeIntervalPrecision_) and subsequent watershed function (3D Watershed split function). 

Object number and specifics (volume, position) are collected. Objects identified in two channels (such as an apoptotic nucleus which will be labelled both as a nucleus and apoptotic) can be identified to separately detect nuclei positive for apoptotic label. 


<p align="center">
  <img width="500" height="500" src="https://user-images.githubusercontent.com/43760657/204838109-891b0b43-cb86-49fe-8702-178441cd7746.svg">
  
  <i> Figure 1. Example image showing a day 8 bovine blastocyst stained with flourophores to detect nuclei (blue channel) and lipids (green channel). A: Nuclei channel of a single confocal plane, B: lipid channel, single confocal plane, C: 3D stack created with all z-planes merged and D: output image from using the presented code (analysis3D_IterativePOEplusrestPercentile_MaskNuclei_190722_PFHXS.ijm). Image adapted from https://doi.org/10.1016/j.reprotox.2022.02.004 </i>
</p>

## Requirements and Installation

The macros and plugins needed for the code is provided in the current repository (Plugins folder) or referred to the original webpage. We recommend using Fiji for ImageJ with an addition of BioFormats for handling the confocal imaging. The following list provide details on macros needed and the code provided in the repository.

|Component|Available at|Description|
|---------|------------|-----------|
|Fiji     |http://Imagej.ner/software/Fiji/downloads|ImageJ, many useful plugins included
|PerObjectEllipsefit 3D_ (ImageJ)|http://cb.uu.se/~petter/downloads/POE|Adaptive per object thresholding
|SizeIntervalPrecision_|https://www.cb.uu.se/~petter/downloads/SIP/|
|BioFormats_plugin-6.5.1|https://www.openmicroscopy.org/bio-formats/|http://Imagej.net/formats/bio-formats
|3D ImageJ Suite|https://imagej.net/plugins/3d-imagej-suite/
|_3DLabelObjects_.class|GitHub repository (CLASS-file)|
|_3DLabelMaxVal_.class|GitHub repository (CLASS-file)|
|FrequencyNoBkg_.jar|GitHub repository|
|analysis3D_IterativePOEplusrestPercentile_MaskNuclei_190722_PFHXS.ijm|GitHub repository (IJM-file)|Code for cell count/size analysis
|analysis3D_SIP_IterativePOE_Apoptosis_.ijm|GitHub repository (IJM-file)|Code for fluorophores overlapping.

To install the tool, download FIJI and the required macros/plugins listed above. Next, open FIJI and install the plugins using <i> Plugins > Install </i> in the Toolbar and restart FIJI.

## Running the tool

Drag and drop the macro from the Scripts folder that will be used to the Fiji window [*.ijm-file, se above]. Insert relevant information into the dialog box. You will be asked to provide “selected image regular expression” (.*czi is prewritten, but change to .* or .*tiff depending on file format). Target voxel size (x,y) is based on the size of the images (see image setting when capturing the images). Target voxel size (z) is the distance between each section (for example 2, if 2 µm distance between z-scans are used). You will also be asked to provide minimum and maximum diameter of nuclei and lipid droplets. A standard setting is provided, but this may be changed upon validation. Provide information on input (raw images) and output (result documents and images) folder and run the macro using the group of embryos selected for validation. 

![Ida1](https://user-images.githubusercontent.com/43760657/204838153-c3d3feba-1581-4556-b7b8-a09e0ddfcce5.svg)

When the analysis is finished the code have generated 2-3 (depending on nuclei and/or lipids) excel-sheets with information on the objects recognized by the macro in addition to the output image which will present which objects is recognised as lipids/nuclei/apoptotic nuclei. Manually validate the images and ensure optimal segmentation of nuclei and lipid separately. Change maximum and minimum diameter as requested. There is a challenge to detect lipid droplets adherent to each other and therefore the lipid droplet size has to be adjusted to account for this in the best possible way. The aim is to find the most optimal threshold, as lipid droplets vary in size and shape, big lipid droplets can be underestimated and small lipid droplets may be clustered together. The results from the settings can be published along with the results from the analyses.

  
 ## Publications

<i>
  
Hallberg, I. Persson, S, Olovsson, M., Moberg, M., Ranefall, P., Laskowski, D., Damdimopoulou, P., Sirard, MA., Rüegg, J., Sjunnesson, YCB., (2022) ”Bovine oocyte exposure to perfluorohexane sulfonate (PFHxS) induces phenotypic, transcriptomic, and DNA methylation changes in resulting embryos in vitro”, Reproductive Toxicology, Volume 109, 19-30, ISSN 0890-6238, https://doi.org/10.1016/j.reprotox.2022.02.004.
  
Hallberg, I., Persson, S., Olovsson., M., Sirard, MA., Damdimopoulou, P., Rüegg, J., Sjunnesson, YCB. (2021). “Perfluorooctane sulfonate (PFOS) exposure of bovine oocytes affects early embryonic development at human-relevant levels in an in vitro model”. Toxicology. 464. Dec 2021. 153028. https://doi.org/10.1016/j.tox.2021.153028 

Leqlercq A., Sjunnesson, Y. & Hallberg, I., ”Occurrence of late-apoptotic symptoms in porcine ex vivo-fertilized embryos upon exposure of oocytes to perfluoroalkyl substances (PFASs) under the conditions of in vitro meiotic maturation”, https://doi.org/10.1371/journal.pone.0279551.
  
</i>
  
## Acknowledgements
  
This project has support from the Nils Lagerlöfs fund (KSLA GFS2021-0031) and the BioImage Informatics Facility ([YlvaSjunnesson2017-1](https://biifsweden.github.io/projects/2017/01/19/YlvaSjunnesson2017-1/)), a unit of the National Bioinformatics Infrastructure Sweden NBIS, with funding from SciLifeLab, National Microscopy Infrastructure NMI (VR-RFI 2019-00217), and the Chan-Zuckerberg Initiative.

## License
To be added if made public.
