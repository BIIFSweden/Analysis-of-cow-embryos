Dialog.create("EmbryoSegmentation");
Dialog.addString("Selected image regular expression",".*czi");
Dialog.addNumber("Target voxel size (x,y)", 0.5);
Dialog.addNumber("Target voxel size (z)", 2.0);
Dialog.addNumber("Nuclei min diameter (voxels after scaling)", 10);
Dialog.addNumber("Nuclei max diameter (voxels after scaling)", 50);
Dialog.addNumber("Fat min diameter (voxels after scaling)", 3);
Dialog.addNumber("Fat max diameter (voxels after scaling)", 20);
Dialog.show();

regexpOriginal = Dialog.getString();
targetXY = Dialog.getNumber();
targetZ = Dialog.getNumber();
nucleiMinD = Dialog.getNumber();
nucleiMaxD = Dialog.getNumber();
fatMinD = Dialog.getNumber();
fatMaxD = Dialog.getNumber();

nucleiMinMinorD = round(nucleiMinD * targetXY / targetZ);
if (nucleiMinMinorD < 1) nucleiMinMinorD = 1;
fatMinMinorD = round(fatMinD * targetXY / targetZ);
if (fatMinMinorD < 1) fatMinMinorD = 1;

nucleiMinV = round(nucleiMinD * nucleiMinD * nucleiMinD * targetXY / targetZ);
nucleiMaxV = round(nucleiMaxD * nucleiMaxD * nucleiMaxD * targetXY / targetZ);

fatMinV = round(fatMinD * fatMinD * fatMinD * targetXY / targetZ);
fatMaxV = round(fatMaxD * fatMaxD * fatMaxD * targetXY / targetZ);

inputdirOriginal = getDirectory("Choose an input directory for the input images ");
dir = getDirectory("Choose an output directory ");
var start = getTime();
run("Close All");
print("\\Clear");
setBatchMode("hide");

processDirectory(inputdirOriginal, dir, regexpOriginal);

var end = getTime();
var time1 = (end-start)/1000;
print("time " + time1 + "s");

setBatchMode("show");

function processDirectory(originalDir, outputDir, regexpOriginal)
{
	//Parameters

	IJ.log("inputdir = " + originalDir);
	listOriginal = getFileList(originalDir);
	for (j = 0; j < listOriginal.length; j++)
	{
		if (File.isDirectory(originalDir + File.separator + listOriginal[j]))
		{
			IJ.log("listOriginal IsDir");
			outputSubDir = outputDir + File.separator + listOriginal[j];
			if (!File.isDirectory(outputSubDir)) 
				File.makeDirectory(outputSubDir);
			processDirectory(originalDir + File.separator + listOriginal[j], outputSubDir, regexpOriginal);
		}
		else if (matches(listOriginal[j],regexpOriginal))
		{
			IJ.log(originalDir+listOriginal[j]);
			open(originalDir+File.separator+listOriginal[j]);
			dotPos = lastIndexOf(listOriginal[j], ".");
			if (dotPos >= 0) 
				imageName = substring(listOriginal[j], 0, dotPos); 
			else
				imageName = listOriginal[j];

			getVoxelSize(vwidth, vheight, vdepth, vunit);
			IJ.log("vWidth " + vwidth + " vHeight " + vheight + " vDepth " + vdepth);
			getDimensions(width, height, channels, slices, frames);
			IJ.log("Width " + width + " Height " + height + " Slices " + slices);
			
			scaleX = vwidth / targetXY;
			scaleY = vheight / targetXY;
			scaleZ = vdepth / targetZ;
			
			run("Scale...", "x=" + scaleX + " y=" + scaleY + " z=" + scaleZ + " interpolation=Bilinear average create title=subsampled");
			
			getVoxelSize(vwidth, vheight, vdepth, vunit);
			IJ.log("vWidth " + vwidth + " vHeight " + vheight + " vDepth " + vdepth);
			getDimensions(width, height, channels, slices, frames);
			IJ.log("Width " + width + " Height " + height + " Slices " + slices);
			
			run("Split Channels");
			selectWindow("C2-subsampled");
			close();
			
			selectWindow("C4-subsampled");
			run("Median...", "radius=2 stack");
			getRawStatistics(nPixels, mean, min, max, std, histogram);
			thr = round(mean);
			run("Subtract...", "value=" + thr + " stack");
			File.delete(outputDir + File.separator + imageName + "_nuclei.csv");
			run("PerObjectEllipsefit3D ", "minsize=" + nucleiMinV + " maxsize=" + nucleiMaxV + " ellipsethr=0.5 minmajoraxis=" + nucleiMinD + " maxmajoraxis=" + nucleiMaxD + " minminoraxis=" + nucleiMinMinorD + " maxminoraxis=" + nucleiMaxD + " minmajorminorratio=1 maxmajorminorratio=20 minpeak=0 darkbkg outputfile=[" + outputDir + File.separator + imageName + "_nuclei.csv]");
			
			selectWindow("C3-subsampled");
			run("Median...", "radius=2 stack");
			getRawStatistics(nPixels, mean, min, max, std, histogram);
			thr = round(mean);
			run("Subtract...", "value=" + thr + " stack");
			File.delete(outputDir + File.separator + imageName + "_fat.csv");
			run("PerObjectEllipsefit3D ", "minsize=" + fatMinV + " maxsize=" + fatMaxV + " ellipsethr=0.5 minmajoraxis=" + fatMinD + " maxmajoraxis=" + fatMaxD + " minminoraxis=" + fatMinMinorD + " maxminoraxis=" + fatMaxD + " maxmajorminorratio=10 minpeak=0 darkbkg outputfile=[" + outputDir + File.separator + imageName + "_fat.csv]");
			
			run("Merge Channels...", "c1=C1-subsampled c2=C3-subsampled c3=C4-subsampled keep");
			saveAs("Tiff", outputDir + File.separator + imageName + "_res.tif");
			run("Close All");
		}
	}
}