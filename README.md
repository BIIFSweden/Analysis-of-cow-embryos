# YlvaSjunnesson2017-1 Analysis of cow embryos

<p align="center">
  <img width="500" height="500" src="https://user-images.githubusercontent.com/43760657/204838109-891b0b43-cb86-49fe-8702-178441cd7746.svg">
  
  <i> Figure 1. Example image showing a day 8 bovine blastocyst stained with flourophores to detect nuclei (blue channel) and lipids (green channel). A: Nuclei channel of a single confocal plane, B: lipid channel, single confocal plane, C: 3D stack created with all z-planes merged and D: output image from using the presented code (analysis3D_IterativePOEplusrestPercentile_MaskNuclei_190722_PFHXS.ijm). Image adapted from https://doi.org/10.1016/j.reprotox.2022.02.004 </i>
</p>
  
## Synopsis

This ImageJ tool enables systematic image analyses to evaluate mammalian embryos produced in vitro (or in vivo). The tool is developed to detect nuclei, lipids and apoptotic cells (using TUNEL) in produced blastocysts. It identifies and assesses the volume of separate objects (nuclei/lipids) and overlap between fluorophores (i.e., TUNEL + nuclei stain). This allow investigation of endpoints such as: 

- Cell count in blastocysts (amount of nuclei)
- Lipid droplet count in blastocysts (amount of lipid droplets) 
- Lipid droplet volume (average lipid droplet volume and estimation of total lipid volume in each embryo)

## Requirements

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

## Installation

## Using the tool

Drag and drop the macro that will be used to the Fiji window [*.ijm-file, se above]. Insert relevant information into the dialog box. You will be asked to provide “selected image regular expression” (.*czi is prewritten, but change to .* or .*tiff depending on file format). Target voxel size (x,y) is based on the size of the images (see image setting when capturing the images). Target voxel size (z) is the distance between each section (for example 2, if 2 µm distance between z-scans are used). You will also be asked to provide minimum and maximum diameter of nuclei and lipid droplets. A standard setting is provided, but this may be changed upon validation. Provide information on input (raw images) and output (result documents and images) folder and run the macro using the group of embryos selected for validation. 

![Ida1](https://user-images.githubusercontent.com/43760657/204838153-c3d3feba-1581-4556-b7b8-a09e0ddfcce5.svg)


  
 ## Publications used in
  
Hallberg, I. Persson, S, Olovsson, M., Moberg, M., Ranefall, P., Laskowski, D., Damdimopoulou, P., Sirard, MA., Rüegg, J., Sjunnesson, YCB., (2022) ”Bovine oocyte exposure to perfluorohexane sulfonate (PFHxS) induces phenotypic, transcriptomic, and DNA methylation changes in resulting embryos in vitro”, Reproductive Toxicology, Volume 109, 19-30, ISSN 0890-6238, https://doi.org/10.1016/j.reprotox.2022.02.004.
  
Hallberg, I., Persson, S., Olovsson., M., Sirard, MA., Damdimopoulou, P., Rüegg, J., Sjunnesson, YCB. (2021). “Perfluorooctane sulfonate (PFOS) exposure of bovine oocytes affects early embryonic development at human-relevant levels in an in vitro model”. Toxicology. 464. Dec 2021. 153028. doi.org/10.1016/j.tox.2021.153028 

Leqlercq A., Sjunnesson, Y. & Hallberg, I., ”Occurrence of late-apoptotic symptoms in porcine ex vivo-fertilized embryos upon exposure of oocytes to perfluoroalkyl substances (PFASs) under the conditions of in vitro meiotic maturation” [submitted manuscript]
  
  
## Acknowledgements
  
This project has support from the Nils Lagerlöfs fund (KSLA GFS2021-0031) and the BioImage Informatics Facility, a unit of the National Bioinformatics Infrastructure Sweden NBIS, with funding from SciLifeLab, National Microscopy Infrastructure NMI (VR-RFI 2019-00217), and the Chan-Zuckerberg Initiative.


