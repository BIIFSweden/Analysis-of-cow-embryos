setOption("ScaleConversions", true);

Dialog.create("EmbryoSegmentation");
Dialog.addString("Selected image regular expression",".*czi");
Dialog.addNumber("Target voxel size (x,y)", 0.5);
Dialog.addNumber("Target voxel size (z)", 2.0);
Dialog.addNumber("Nuclei min diameter (voxels after scaling)", 10);
Dialog.addNumber("Nuclei max diameter (voxels after scaling)", 70);
Dialog.addNumber("Fat min diameter (voxels after scaling)", 0);
Dialog.addNumber("Fat max diameter (voxels after scaling)", 40);
Dialog.addNumber("Percentile for intensity of clustered objects ", 0.5);
Dialog.show();

regexpOriginal = Dialog.getString();
targetXY = Dialog.getNumber();
targetZ = Dialog.getNumber();
nucleiMinD = Dialog.getNumber();
nucleiMaxD = Dialog.getNumber();
fatMinD = Dialog.getNumber();
fatMaxD = Dialog.getNumber();
percentile = Dialog.getNumber();

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
setBatchMode(true);

processDirectory(inputdirOriginal, dir, regexpOriginal);

var end = getTime();
var time1 = (end-start)/1000;
print("time " + time1 + "s");

setBatchMode(false);

function iterativePOE(inputWindow, outputWindow, outputFile, minV, maxV, minD, maxD, minMinorD, seedShrink)
{	
	selectWindow(inputWindow);
	run("Duplicate...", "title=POEAll duplicate");
	run("PerObjectEllipsefit3D ", "minsize=" + minV + " maxsize=" + maxV + " ellipsethr=0.5 minmajoraxis=" + minD + " maxmajoraxis=" + maxD + " minminoraxis=" + minMinorD + " maxminoraxis=" + maxD + " minmajorminorratio=1 maxmajorminorratio=20 minpeak=0 darkbkg outputfile=[]");
	
	i = 1;
	isEmpty = false;
	Stack.getStatistics(voxelCount, mean, min, max, stdDev);
	selectWindow("POEAll");
	run("Duplicate...", "title=SeedsAll duplicate");
	run("Minimum 3D...", "x=" + seedShrink + " y=" + seedShrink + " z=" + seedShrink);
	if (max==0)
		isEmpty = true;
	while(!isEmpty)
	{
		i += 1;
		IJ.log(i);
		selectWindow("POEAll");
		run("Duplicate...", "title=POEAllInv duplicate");
		run("Maximum 3D...", "x=2 y=2 z=2");
		run("Invert", "stack");
		run("Divide...", "value=255.000 stack");
		imageCalculator("Multiply create stack", inputWindow, "POEAllInv");
		rename("POE");
		run("PerObjectEllipsefit3D ", "minsize=" + minV + " maxsize=" + maxV + " ellipsethr=0.5 minmajoraxis=" + minD + " maxmajoraxis=" + maxD + " minminoraxis=" + minMinorD + " maxminoraxis=" + maxD + " minmajorminorratio=1 maxmajorminorratio=20 minpeak=0 darkbkg outputfile=[]");
		run("Minimum 3D...", "x=1 y=1 z=1");
		run("Maximum 3D...", "x=1 y=1 z=1");
		Stack.getStatistics(voxelCount, mean, min, max, stdDev);
		if (max==0)
		{
			isEmpty = true;
			//Get the rest of the blobs by threshold at median of current objects
			selectWindow("POE");
			close();
			selectWindow("POEAll");
			run("Duplicate...", "title=POEAll1 duplicate");
			run("Divide...", "value=255.000 stack");
			imageCalculator("Multiply create stack", inputWindow, "POEAll1");
			rename("InputMasked");

			//GetStack histogram
			getHistogram(values, counts, 256);
			for (slice=2; slice<=nSlices; slice++) 
			{
				run("Set Slice...", "slice=" + slice);
				getHistogram(values2, counts2, 256);
				for (j=0; j<256; j++) {
					counts[j] += counts2[j];
				}
			}
			thr = 1;
			breakVal = (voxelCount - counts[0]) * percentile;
			sum = 0;
			while (sum < breakVal && thr < 255)
			{
				sum += counts[thr];
				thr++;
			}
			print("Voxels " + voxelCount + " Bkg " + counts[0] + " breakVal " + breakVal + " Final thr " + thr);
			imageCalculator("Multiply create stack", inputWindow, "POEAllInv");
			rename("POE");
			setThreshold(thr, 255);
			run("Convert to Mask", "background=Dark black");
			selectWindow("InputMasked");
			close();
			selectWindow("POEAll1");
			close();
		}
		imageCalculator("Max create stack", "POEAll","POE");
		rename("POEAllNew");
		selectWindow("POEAll");
		close();
		selectWindow("POEAllNew");
		rename("POEAll");
		selectWindow("POE");
		run("Duplicate...", "title=Seeds duplicate");
		run("Minimum 3D...", "x=" + seedShrink + " y=" + seedShrink + " z=" + seedShrink);
		imageCalculator("Max create stack", "SeedsAll","Seeds");
		rename("SeedsAllNew");
		selectWindow("SeedsAll");
		close();
		selectWindow("SeedsAllNew");
		rename("SeedsAll");
		selectWindow("Seeds");
		close();
		selectWindow("POEAllInv");
		close();
		selectWindow("POE");
		close();
	}
	run("3D Watershed Split", "binary=POEAll seeds=SeedsAll radius=1");
	selectWindow("POEAll");
	close();
	selectWindow("SeedsAll");
	close();
	selectWindow("EDT");
	close();
    selectWindow("Split");
    rename(outputWindow);
    File.delete(outputFile);
    run("FrequencyNoBkg ", "outputfile=[" + outputFile + "]");
    selectWindow(outputWindow);
	setThreshold(1, 65535);
	run("Convert to Mask", "background=Dark black");
}

function processImage()
{
	imageName=getTitle();
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
	Stack.getStatistics(voxelCount, mean, min, max, stdDev);
	thr = round(mean);
	run("Subtract...", "value=" + thr + " stack");
	newMax = max - mean;
	setMinAndMax(0, newMax);
	run("8-bit");
	
	iterativePOE("C4-subsampled", "Nuclei", outputDir + File.separator + imageName + "_nuclei.csv", nucleiMinV, nucleiMaxV, nucleiMinD, nucleiMaxD, nucleiMinMinorD, 2);

	selectWindow("C3-subsampled");
	run("Median...", "radius=2 stack");
	Stack.getStatistics(voxelCount, mean, min, max, stdDev);
	thr = round(mean);
	run("Subtract...", "value=" + thr + " stack");
	newMax = max - mean;
	setMinAndMax(0, newMax);
	run("8-bit");
	//Mask out Nuclei
	selectWindow("Nuclei");
	run("Duplicate...", "title=NucleiInv duplicate");
	run("Invert", "stack");
	imageCalculator("Min create stack", "C3-subsampled","NucleiInv");
	rename("C3-subsampledMasked");
	
	iterativePOE("C3-subsampledMasked", "Fat", outputDir + File.separator + imageName + "_fat.csv", fatMinV, fatMaxV, fatMinD, fatMaxD, fatMinMinorD, 1);
	
	selectWindow("C1-subsampled");
	Stack.getStatistics(voxelCount, mean, min, max, stdDev);
	setMinAndMax(0, max);
	run("8-bit");
	run("Merge Channels...", "c1=C1-subsampled c2=Fat c3=Nuclei keep");
	saveAs("Tiff", outputDir + File.separator + imageName + "_res.tif");
}

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
			//open(originalDir+File.separator+listOriginal[j]);
			run("Bio-Formats", "open=[" + originalDir+File.separator+listOriginal[j] + "] color_mode=Default open_files rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			dotPos = lastIndexOf(listOriginal[j], ".");
			if (dotPos >= 0) 
				imageName = substring(listOriginal[j], 0, dotPos); 
			else
				imageName = listOriginal[j];

			processImage();
			
			run("Close All");
		}
	}
}
