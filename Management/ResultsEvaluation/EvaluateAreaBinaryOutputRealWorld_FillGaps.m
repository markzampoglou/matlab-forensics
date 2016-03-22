clear all;
MaskLimits=[0 1; 0 1; 0 22; 0 700; 0 0.1];
%5: 0 55; 6:-0.1 10; 7: 0 6; 10:0 20 16a: 0 0.1 16b: 0.7

ThresholdSteps=100;

%'12'  and '16b' are left hanging

AlgorithmNames={'02' '04' '05' '07' '08'  '10' '14' '16'}  % '12'  '16' '01' '04' '05' '06' '07'

ImageRoot='/media/marzampoglou/3TB/markzampoglou/ImageForensics/Datasets/';
InputRoot='/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/';
OutputRoot='/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/Evaluations/';

MaskRoot=[ImageRoot 'Masks/'];

Datasets=load('../../Datasets_Linux.mat');

Folders=dir(Datasets.MarkRealWorldSplices);
Folders=Folders(3:end);


for AlgorithmInd=1:length(AlgorithmNames)
    AlgorithmName=AlgorithmNames{AlgorithmInd};
    disp(AlgorithmName)
    mkdir([OutputRoot AlgorithmName '/WildWeb_MaskArea/']);
    for Folder=2:length(Folders)
        InputFolder=Folders(Folder).name;
        disp(InputFolder)
        InputPath=[InputRoot AlgorithmName '/Wild Web Dataset/WildWeb/' InputFolder];
        MaskPath=[Datasets.MarkRealWorldSplices '/' InputFolder '/Mask/'];
        FileList=getAllFiles(InputPath,'*.mat',true);
        MaskList=getAllFiles(MaskPath,'*.png',true);
        for MaskInd=1:length(MaskList)
            OutputFile=[OutputRoot AlgorithmName '/WildWeb_MaskArea/' InputFolder '_' num2str(MaskInd) '.mat'];
            Mask=CleanUpImage(MaskList{MaskInd});
            clear Results;
            Names={};
            if exist(OutputFile)
                load(OutputFile,'Names');
                if length(Names)<length(FileList)
                    disp('Missing Files');
                    load(OutputFile);
                    Extended=false;
                    for InputFile=1:length(FileList)
                        ToSeek=FileList{InputFile};
                        SeekSlashes=strfind(ToSeek,'/');
                        Core1=['Wild Web Dataset/WildWeb/' InputFolder '/' strrep(ToSeek(SeekSlashes(end)+1:end),'.mat','')];
                        Core2=['WildWeb/' InputFolder '/' ToSeek(SeekSlashes(end)+1:end)];
                        Core3=['/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/02/Wild Web Dataset/' Core2];
                        if isempty(find(strcmp(Names,Core1),1)) && isempty(find(strcmp(Names,Core2),1)) && isempty(find(strcmp(Names,Core3),1))
                            NewEntryInd=length(Names)+1;
                            disp([AlgorithmName ' Missing ' FileList{InputFile} ' at ' InputFolder]);
                            Input=load(FileList{InputFile});
                            ResultMap=GetAlgorithmInputMap(Input,AlgorithmName);
                            Mask=mean(Mask,3);
                            if isfield(Input,'Name')
                                Names{NewEntryInd}=Input.Name;
                            else
                                Names{NewEntryInd}=FileList{InputFile};
                            end
                            for MapInd=1:length(ResultMap)
                                ResultMap{MapInd}(isnan(ResultMap{MapInd}))=0;
                                if isempty(ResultMap{MapInd})
                                    ResultMap{MapInd}=zeros(1024);
                                    disp(['empty map: '  Input.Name]);
                                end
                                
                                if numel(Mask)<numel(ResultMap{MapInd})
                                    MaskThresh=mean([min(min(Mask)) max(max(Mask))]);
                                    MaskResize=imresize(Mask,size(ResultMap{MapInd}),'nearest')>MaskThresh;
                                    ResultMap{MapInd}=ResultMap{MapInd};
                                else
                                    MaskThresh=mean([min(min(Mask)) max(max(Mask))]);
                                    MaskResize=Mask>MaskThresh;
                                    ResultMap{MapInd}=imresize(ResultMap{MapInd},size(Mask),'nearest');
                                end
                                MaskThresholdRange=(MaskLimits(AlgorithmInd,2)-MaskLimits(AlgorithmInd,1));
                                MaskThresholds=MaskLimits(AlgorithmInd,1):MaskThresholdRange/ThresholdSteps:MaskLimits(AlgorithmInd,2);
                                
                                MaskThresholdInd=1;
                                Zeroed=false;
                                while MaskThresholdInd<=length(MaskThresholds) && ~Zeroed
                                    MaskThreshold=MaskThresholds(MaskThresholdInd);
                                    ResultThresholded{1}=ResultMap{MapInd}>=MaskThreshold;
                                    ResultThresholded{2}=ResultMap{MapInd}<MaskThreshold;
                                    if sum(ResultThresholded{1}(:))==0
                                        Zeroed=true;
                                    end
                                    for ResultVersion=1:2
                                        [ProcessedMasks,Processes]=ProcessMask(ResultThresholded{ResultVersion});
                                        for ProcessInd=1:length(ProcessedMasks)
                                            clear Result;
                                            Result.PixelCount=numel(ResultThresholded);
                                            Result.Positives=sum(MaskResize(:));
                                            Result.Negatives=sum(~MaskResize(:));
                                            Result.ReturnedPositives=sum(sum(ProcessedMasks{ProcessInd}));
                                            Result.ReturnedNegatives=sum(sum(~ProcessedMasks{ProcessInd(:)}));
                                            Result.TP=sum(sum(ProcessedMasks{ProcessInd}&MaskResize));
                                            Result.FP=sum(sum(ProcessedMasks{ProcessInd}&~MaskResize));
                                            Result.TN=sum(sum(~ProcessedMasks{ProcessInd}&~MaskResize));
                                            Result.FN=sum(sum(~ProcessedMasks{ProcessInd}&MaskResize));
                                            Result.Prec=Result.TP/Result.ReturnedPositives;
                                            if isnan(Result.Prec)
                                                Result.Prec=0;
                                            end
                                            Result.Rec=Result.TP/Result.Positives;
                                            if isnan(Result.Rec)
                                                Result.Rec=0;
                                            end
                                            Result.F1=2*(Result.Prec*Result.Rec)/(Result.Prec+Result.Rec);
                                            if isnan(Result.F1)
                                                Result.F1=0;
                                            end
                                            Result.Union=sum(sum(ProcessedMasks{ProcessInd}|MaskResize));
                                            Result.IoU=Result.TP/Result.Union;
                                            if isnan(Result.IoU)
                                                Result.IoU=0;
                                            end
                                            Result.MarkMeasure=(Result.TP^2)/(Result.ReturnedPositives*Result.Positives);
                                            if isnan(Result.MarkMeasure)
                                                Result.MarkMeasure=0;
                                            end
                                            
                                            Results(NewEntryInd,MaskThresholdInd,ProcessInd,ResultVersion,MapInd)=Result;
                                            MaskThresholdInd=MaskThresholdInd+1;
                                        end
                                    end
                                end
                                FinalInd=MaskThresholdInd;
                                if Zeroed
                                    for MaskThresholdInd=FinalInd:length(MaskThresholds)
                                        for ResultVersion=1:2
                                            for ProcessInd=1:length(ProcessedMasks)
                                                Result=[];
                                                Result.PixelCount=0;
                                                Result.Positives=0;
                                                Result.Negatives=0;
                                                Result.ReturnedPositives=0;
                                                Result.ReturnedNegatives=0;
                                                Result.TP=0;
                                                Result.FP=0;
                                                Result.TN=0;
                                                Result.FN=0;
                                                Result.Prec=0;
                                                Result.Rec=0;
                                                Result.F1=0;
                                                Result.Union=0;
                                                Result.IoU=0;
                                                Result.MarkMeasure=0;
                                                Results(NewEntryInd,MaskThresholdInd,ProcessInd,ResultVersion,MapInd)=Result;
                                            end
                                        end
                                    end
                                end
                            end
                            if mod(InputFile,50)==0
                                disp(InputFile)
                            end
                            Extended=true;
                        end
                        
                        %disp('saved');
                        %pause
                    end
                    if Extended
                        save([OutputFile '_extended.mat'],'Results','Names','Processes','-v7.3');
                    end
                end
            else
                for InputFile=1:length(FileList)
                    Input=load(FileList{InputFile});
                    ResultMap=GetAlgorithmInputMap(Input,AlgorithmName);
                    Mask=mean(Mask,3);
                    if isfield(Input,'Name')
                        Names{InputFile}=Input.Name;
                    else
                        Names{InputFile}=FileList{InputFile};
                    end
                    for MapInd=1:length(ResultMap)
                        ResultMap{MapInd}(isnan(ResultMap{MapInd}))=0;
                        if isempty(ResultMap{MapInd})
                            ResultMap{MapInd}=zeros(1024);
                            disp(['empty map: '  Input.Name]);
                        end
                        
                        if numel(Mask)<numel(ResultMap{MapInd})
                            MaskThresh=mean([min(min(Mask)) max(max(Mask))]);
                            MaskResize=imresize(Mask,size(ResultMap{MapInd}),'nearest')>MaskThresh;
                            ResultMap{MapInd}=ResultMap{MapInd};
                        else
                            MaskThresh=mean([min(min(Mask)) max(max(Mask))]);
                            MaskResize=Mask>MaskThresh;
                            ResultMap{MapInd}=imresize(ResultMap{MapInd},size(Mask),'nearest');
                        end
                        MaskThresholdRange=(MaskLimits(AlgorithmInd,2)-MaskLimits(AlgorithmInd,1));
                        MaskThresholds=MaskLimits(AlgorithmInd,1):MaskThresholdRange/ThresholdSteps:MaskLimits(AlgorithmInd,2);
                        
                        MaskThresholdInd=1;
                        Zeroed=false;
                        while MaskThresholdInd<=length(MaskThresholds) && ~Zeroed
                            MaskThreshold=MaskThresholds(MaskThresholdInd);
                            ResultThresholded{1}=ResultMap{MapInd}>=MaskThreshold;
                            ResultThresholded{2}=ResultMap{MapInd}<MaskThreshold;
                            if sum(ResultThresholded{1}(:))==0
                                Zeroed=true;
                            end
                            for ResultVersion=1:2
                                [ProcessedMasks,Processes]=ProcessMask(ResultThresholded{ResultVersion});
                                for ProcessInd=1:length(ProcessedMasks)
                                    clear Result;
                                    Result.PixelCount=numel(ResultThresholded);
                                    Result.Positives=sum(MaskResize(:));
                                    Result.Negatives=sum(~MaskResize(:));
                                    Result.ReturnedPositives=sum(sum(ProcessedMasks{ProcessInd}));
                                    Result.ReturnedNegatives=sum(sum(~ProcessedMasks{ProcessInd(:)}));
                                    Result.TP=sum(sum(ProcessedMasks{ProcessInd}&MaskResize));
                                    Result.FP=sum(sum(ProcessedMasks{ProcessInd}&~MaskResize));
                                    Result.TN=sum(sum(~ProcessedMasks{ProcessInd}&~MaskResize));
                                    Result.FN=sum(sum(~ProcessedMasks{ProcessInd}&MaskResize));
                                    Result.Prec=Result.TP/Result.ReturnedPositives;
                                    if isnan(Result.Prec)
                                        Result.Prec=0;
                                    end
                                    Result.Rec=Result.TP/Result.Positives;
                                    if isnan(Result.Rec)
                                        Result.Rec=0;
                                    end
                                    Result.F1=2*(Result.Prec*Result.Rec)/(Result.Prec+Result.Rec);
                                    if isnan(Result.F1)
                                        Result.F1=0;
                                    end
                                    Result.Union=sum(sum(ProcessedMasks{ProcessInd}|MaskResize));
                                    Result.IoU=Result.TP/Result.Union;
                                    if isnan(Result.IoU)
                                        Result.IoU=0;
                                    end
                                    Result.MarkMeasure=(Result.TP^2)/(Result.ReturnedPositives*Result.Positives);
                                    if isnan(Result.MarkMeasure)
                                        Result.MarkMeasure=0;
                                    end
                                    
                                    Results(InputFile,MaskThresholdInd,ProcessInd,ResultVersion,MapInd)=Result;
                                    MaskThresholdInd=MaskThresholdInd+1;
                                end
                            end
                        end
                        FinalInd=MaskThresholdInd;
                        if Zeroed
                            for MaskThresholdInd=FinalInd:length(MaskThresholds)
                                for ResultVersion=1:2
                                    for ProcessInd=1:length(ProcessedMasks)
                                        Result=[];
                                        Result.PixelCount=0;
                                        Result.Positives=0;
                                        Result.Negatives=0;
                                        Result.ReturnedPositives=0;
                                        Result.ReturnedNegatives=0;
                                        Result.TP=0;
                                        Result.FP=0;
                                        Result.TN=0;
                                        Result.FN=0;
                                        Result.Prec=0;
                                        Result.Rec=0;
                                        Result.F1=0;
                                        Result.Union=0;
                                        Result.IoU=0;
                                        Result.MarkMeasure=0;
                                        Results(InputFile,MaskThresholdInd,ProcessInd,ResultVersion,MapInd)=Result;
                                    end
                                end
                            end
                        end
                    end
                    if mod(InputFile,50)==0
                        disp(InputFile)
                    end
                end
                
                save(OutputFile,'Results','Names','Processes','-v7.3');
                %disp('saved');
                %pause
            end
        end
    end
end
