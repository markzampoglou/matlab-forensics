clear all;
load('../Datasets_Independent.mat');
DatasetList={'Carvalho', 'ColumbiauUncomp','FirstChallengeTrain','VIPPDempSchaReal','VIPPDempSchaSynth'}; %,'FirstChallengeTest','FirstChallengeTest2' 'VIPP2', 

InputRoot='/media/marzampoglou/3TB_B/Image Forensics/Datasets/';
OutputRoot='/media/marzampoglou/3TB_B/Image Forensics/Datasets/Resaved/';

Qualities=[65 75 85 95 100];
Resizes=[false];

for Dataset=1:length(DatasetList)
    InputSet=DatasetList{Dataset};
    InputPaths={};
    InputData=getfield(Datasets,InputSet);
    if isstruct(InputData)
        Names=fieldnames(InputData);
        for jj=1:length(Names);
            InputPaths=[InputPaths;getfield(InputData,Names{jj})];
        end
    else
        InputPaths={InputData};
    end
    
    for subfolder=1:length(InputPaths);
        FileList={};
        for fileExtension={'*.jpg','*.jpeg','*.png','*.gif','*.tif','*.bmp'}
            FileList=[FileList;getAllFiles([InputRoot InputPaths{subfolder}],fileExtension{1},true)];
        end
        for fileInd=1:length(FileList)
            ImageIn=CleanUpImage(FileList{fileInd});
            for Quality=Qualities
                for Resize=Resizes
                    DestinationFile=[strrep(FileList{fileInd},InputRoot,[OutputRoot num2str(Quality) '_' num2str(Resize) '/']) '.jpg'];
                    if ~exist(DestinationFile,'file')
                        slashes=strfind(DestinationFile,'/');
                        DestPath=DestinationFile(1:slashes(end));
                        if ~exist(DestPath,'dir')
                            mkdir(DestPath);
                        end
                        if Resize
                            ImageOut=imresize(ImageIn,0.75);
                        else
                            ImageOut=ImageIn;
                        end
                        imwrite(ImageOut,DestinationFile,'quality',Quality);
                    end
                end
            end
        end
    end
end