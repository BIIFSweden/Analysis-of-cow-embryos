# YlvaSjunnesson2017-1 Analysis of cow embryos

# 1. Synopsis

This ImageJ tool enables systematic image analyses to evaluate mammalian embryos produced in vitro (or in vivo). The code is developed to detect nuclei, lipids and apoptotic cells (using TUNEL) in produced blastocysts. The code identifies and assess the volume of separate objects (nuclei/lipids) and overlap between fluorophores (i.e., TUNEL + nuclei stain). This allow investigation of endpoints such as: 

- Cell count in blastocysts (amount of nuclei)
- Lipid droplet count in blastocysts (amount of lipid droplets) 
- Lipid droplet volume (average lipid droplet volume and estimation of total lipid volume in each embryo)

# 3. Requirements

The macros and plugins needed for the code is provided in the current repository or referred to the original webpage. We recommend using Fiji for ImageJ with an addition of BioFormats for handling the confocal imaging. The following list provide details on macros needed and the code provided in the repository.

|Component|Available at|Description|
|---------|------------|-----------|
|Fiji     |http://Imagej.ner/software/Fiji/downloads|ImageJ, many useful plugins included
|PerObjectEllipsefit 3D_ (ImageJ)|http://cb.uu.se/~petter/downloads/POE|Adaptive per object thresholding
|SizeIntervalPrecision_|https://www.cb.uu.se/~petter/downloads/SIP/|
|BioFormats_plugin-6.5.1|https://www.openmicroscopy.org/bio-formats/|http://Imagej.net/formats/bio-formats
|_3DLabelObjects_.class|GitHub repository (CLASS-file)|
|_3DLabelMaxVal_.class|GitHub repository (CLASS-file)|
|analysis3D_IterativePOEplusrestPercentile_MaskNuclei_190722_PFHXS.ijm|GitHub repository (IJM-file)|Code for cell count/size analysis
|analysis3D_SIP_IterativePOE_Apoptosis_.ijm|GitHub repository (IJM-file)|Code for fluorophores overlapping.

# 4. Running the tool

Drag and drop the macro that will be used to the Fiji window [*.ijm-file, se above]. Insert relevant information into the dialog box. You will be asked to provide “selected image regular expression” (.*czi is prewritten, but change to .* or .*tiff depending on file format). Target voxel size (x,y) is based on the size of the images (see image setting when capturing the images). Target voxel size (z) is the distance between each section (for example 2, if 2 µm distance between z-scans are used). You will also be asked to provide minimum and maximum diameter of nuclei and lipid droplets. A standard setting is provided, but this may be changed upon validation. Provide information on input (raw images) and output (result documents and images) folder and run the macro using the group of embryos selected for validation. 

![Ida1](https://user-images.githubusercontent.com/43760657/204838153-c3d3feba-1581-4556-b7b8-a09e0ddfcce5.svg)

![Ida2](https://user-images.githubusercontent.com/43760657/204838109-891b0b43-cb86-49fe-8702-178441cd7746.svg)




