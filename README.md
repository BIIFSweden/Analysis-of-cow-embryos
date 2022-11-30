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








