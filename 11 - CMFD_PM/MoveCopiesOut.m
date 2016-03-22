InputDirList=dir('/media/marzampoglou/3TB_B/ImageForensics/MATLAB Code/matlab-forensics/11 - CMFD_PM/ChallengeDetections/*.png');

DetectionImagePath='/media/marzampoglou/3TB_B/ImageForensics/MATLAB Code/matlab-forensics/11 - CMFD_PM/ChallengeDetections/';
SourceImagePath='/media/marzampoglou/3TB_B/ImageForensics/Datasets/Challenge/dataset-dist/phase-01/training/fake/';

CopyMovedImagePath='/media/marzampoglou/3TB_B/ImageForensics/Datasets/CopyMovedChallenge/dataset-dist/phase-01/training/fake/';
mkdir(CopyMovedImagePath);

for ii=1:length(InputDirList)
    DetectionImage=[DetectionImagePath InputDirList(ii).name];
    SourceImage=[SourceImagePath strrep(InputDirList(ii).name,'..','.')];
    movefile(SourceImage,strrep(SourceImage,SourceImagePath,CopyMovedImagePath));
end