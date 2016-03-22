rng(1917);
warning('off','all')

load('../../Datasets_Independent.mat');

DatasetList={'Carvalho','ColumbiauUncomp','FirstChallengeTrain','VIPPDempSchaReal','VIPPDempSchaSynth'}; %'VIPP2', , 'FirstChallengeTest2',

InputOrigRoot='/media/marzampoglou/3TB_B/ImageForensics/Datasets/';
InputResaveRoot='/media/marzampoglou/3TB_B/ImageForensics/Datasets/Resaved/';
OutputRoot='/media/marzampoglou/3TB_A/AlgorithmOutput/';
MaskRoot='/media/marzampoglou/3TB_B/ImageForensics/Datasets/Masks/';

Qualities=90;
Rescales=[95 75 50];

ImagesToKeep=100;


for Dataset=1:length(DatasetList)
    disp(DatasetList{Dataset});
    InputSet=DatasetList{Dataset};
    disp(DatasetList{Dataset});
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
        InputPath=[InputOrigRoot InputPaths{subfolder} '/'];
        FileList=[];
        for fileExtension={'*.jpg','*.jpeg','*.png','*.gif','*.tif','*.bmp'}
            subList=getAllFiles(InputPath,fileExtension{1},true);
            randInd=randperm(length(subList));
            subList=subList(randInd);
            subList=subList(1:min(ImagesToKeep,length(subList)));
            FileList=[FileList;subList];
        end
        
        for fileInd=1:length(FileList)
            im=imread(FileList{fileInd});
            if isa(im,'uint16')
                im=im2uint8(im);
            end
            for Quality=Qualities
                for Rescale=Rescales
                    ImResc=imresize(im,Rescale/100);
                    OutPath=[strrep(FileList{fileInd},InputOrigRoot,[InputResaveRoot num2str(Quality) '_' num2str(Rescale) '/']) '.jpg'];
                    [p,f,ext]=fileparts(OutPath);
                    mkdir(p);
                    imwrite(ImResc, OutPath, 'Quality', Quality);
                end
            end
        end
    end
end
warning('on','all')