clear all;

AlgorithmName='18';

load('../Datasets_Independent.mat');

NSize=3;
Multiplier=10;
Flatten=true;

InputOrigRoot='/media/marzampoglou/3TB_B/ImageForensics/Datasets/';
OutputRoot='/media/marzampoglou/3TB_A/AlgorithmOutput/';

Folders=dir([InputOrigRoot Datasets.MarkRealWorldSplices]);
Folders=Folders(3:end);

for Folder=1:length(Folders)
    
    InputFolder=Folders(Folder).name;
    disp(InputFolder)
    
    OutDir=[OutputRoot AlgorithmName '/' Datasets.MarkRealWorldSplices '/' Folders(Folder).name];
    mkdir(OutDir);
    FileList=[];
    for fileExtension={'*.jpg','*.jpeg','*.png','*.gif','*.tif','*.bmp'}
        FileList=[FileList;dir([InputOrigRoot Datasets.MarkRealWorldSplices '/' Folders(Folder).name '/' fileExtension{1}])];
    end
    
    for fileInd=1:length(FileList)
        InputFileName=[InputOrigRoot Datasets.MarkRealWorldSplices '/' InputFolder '/' FileList(fileInd).name];
        OutputName=[strrep(InputFileName,InputOrigRoot,[OutputRoot AlgorithmName '/']) '.mat'];
        if ~exist(OutputName)
            im=CleanUpImage(InputFileName);
            Result = MedFiltForensics(im,NSize,Multiplier,Flatten);
            
            Name=strrep(InputFileName,InputOrigRoot,'');
            save(OutputName,'AlgorithmName','Result','Name','-v7.3');
            
            if mod(fileInd,15)==0
                disp(fileInd)
            end
        end
    end
end
