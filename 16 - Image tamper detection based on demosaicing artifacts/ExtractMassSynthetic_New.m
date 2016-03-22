clear all

AlgorithmName='16';

Qualities=90;  %[0 100 95 85 75 65];
Rescales=[50 75 95];

DatasetList={'Carvalho','ColumbiauUncomp','FirstChallengeTrain','VIPPDempSchaReal', 'VIPPDempSchaSynth'}; %'VIPP2', , 'FirstChallengeTest2',

InputOrigRoot='/media/marzampoglou/3TB_B/ImageForensics/Datasets/';
InputResaveRoot='/media/marzampoglou/3TB_B/ImageForensics/Datasets/Resaved/';
OutputRoot='/media/marzampoglou/3TB_A/AlgorithmOutput/';
MaskRoot='/media/marzampoglou/3TB_B/ImageForensics/Datasets/Masks/';
load('../Datasets_Independent.mat');


c=parcluster('local');
c.NumWorkers=8;
parpool(c,8);
BlockSize=8;

for Quality=Qualities
    for Rescale=Rescales
        for Dataset=1:length(DatasetList)
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
                if Quality==0 && Rescale==false
                    InputPath=[InputOrigRoot InputPaths{subfolder} '/'];
                else
                    InputPath=[InputResaveRoot num2str(Quality) '_' num2str(Rescale) '/' InputPaths{subfolder} '/'];
                end
                FileList={};
                for fileExtension={'*.jpg','*.jpeg','*.png','*.gif','*.tif','*.bmp'}
                    FileList=[FileList;getAllFiles(InputPath,fileExtension{1},true)];
                end
                
                
                for fileInd=1:length(FileList)
                    if Quality==0 && Rescale==0
                        OutputName=[strrep(FileList{fileInd},InputOrigRoot,[OutputRoot AlgorithmName '/0_0/']) '.mat'];
                    else
                        OutputName=[strrep(FileList{fileInd},InputResaveRoot,[OutputRoot AlgorithmName '/']) '.mat'];
                    end
                    
                    if ~exist(OutputName)
                        
                        slashes=strfind(OutputName,'/');
                        if ~exist(OutputName(1:slashes(end)))
                            mkdir(OutputName(1:slashes(end)));
                        end
                        
                        
                        im=CleanUpImage(FileList{fileInd});
                        Result=CFATamperDetection_Both(im);
                        
                        Name=strrep(FileList{fileInd},[InputResaveRoot num2str(Quality) '_' num2str(Rescale) '/'],'');
                        Name=strrep(Name,InputOrigRoot,'');
                        MaskFile=[MaskRoot Name];
                        if Quality~=0 || Rescale~=false
                            MaskFile=MaskFile(1:end-4);
                        end
                        maskdots=strfind(MaskFile,'.');
                        MaskFile=strrep(MaskFile,MaskFile(maskdots(end):end),'.png');
                        if exist(MaskFile,'file')
                            BinMask=mean(CleanUpImage(MaskFile),3)>0;
                        else
                            slashes=strfind(MaskFile,'/');
                            MaskPath=MaskFile(1:slashes(end));
                            MaskList=dir([MaskPath '*.png']);
                            if length(MaskList)==1
                                BinMask=mean(CleanUpImage([MaskPath MaskList(1).name]),3)>0;
                            elseif length(MaskList)==0
                                BinMask={};
                            else
                                error('Something is wrong with the masks');
                            end
                        end
                        save(OutputName,'Quality','Rescale','BinMask','AlgorithmName','Result','Name','-v7.3');
                    end
                    if mod(fileInd,15)==0
                        disp(fileInd)
                    end
                end
            end
        end
    end
end
delete(gcp)