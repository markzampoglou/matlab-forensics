InputDirList=dir('/media/marzampoglou/3TB_B/ImageForensics/MATLAB Code/matlab-forensics/11 - CMFD_PM/ChallengeDetections/*.png');

DetectionImagePath='/media/marzampoglou/3TB_B/ImageForensics/MATLAB Code/matlab-forensics/11 - CMFD_PM/ChallengeDetections/';
SourceImagePath='/media/marzampoglou/3TB_B/ImageForensics/Datasets/Challenge2/dataset-dist/phase-01/training/fake/';


for ii=1:length(InputDirList)
    DetectionImage=[DetectionImagePath InputDirList(ii).name];
    SourceImage=[SourceImagePath strrep(InputDirList(ii).name,'..','.')];
    figure(1)
    image(imread(SourceImage))
    figure(2)
    image(imread(DetectionImage))
    InputDirList(ii).name
    pause;
end