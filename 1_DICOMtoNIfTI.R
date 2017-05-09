# Input  : DICOM files. (Brain slices)
# Funtion: Inspects the DICOM header and find the modality used by the MRI Scanner. Converts the NIFTI to DICOM with compression.
# Output : Equivalent NIFTI file with the modailty name as the filename inside the OUTPUT folder. 

library('oro.nifti')
library('oro.dicom')

# Path to the folder containing the DICOM files.
setwd("Path/")
slice = readDICOM("Filename.dcm")

# Plots the slice. [OPTIONAL]
d = dim(t(slice$img[[1]]))
image(1:d[1], 1:d[2], t(slice$img[[1]]), col = gray(0:64/64))

# Checks the header for modality.
hdr = slice$hdr[[1]]
modalityname = hdr[hdr$name == "SeriesDescription", "value"]

# Path to the directory containing the folder with all the DICOM files.
setwd("Path/")

#Path to the folder containing all the files.
all_slices = readDICOM("Foldername/")

number_slices_dicom = length(all_slices$img)
nii_file = dicom2nifti(all_slices)
niftidimension = dim(nii_file)


if(niftidimension[3] == number_slices_dicom )
{
writeNIfTI(nii_file, modalityname, verbose=TRUE, gzipped = TRUE,compression = 6)
dir.create("OUTPUT")
filename = paste(modalityname,".nii.gz",sep="")
file.copy(from = filename,  to = "PATH/OUTPUT/")
file.remove(filename)
print("Script ended succesfully.")
} else
{
  print("Conversion Failed. NIFTI AND DICOM dimensions don't match. ")
}