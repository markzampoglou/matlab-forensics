AlgorithmName='01';

Datasets=load('../Datasets_Linux.mat');


InputOrigRoot='/media/marzampoglou/3TB/markzampoglou/ImageForensics/Datasets/';
OutputRoot='/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/';

Folders=dir(Datasets.MarkRealWorldSplices);
Folders=Folders(3:end);

for Folder=1:length(Folders)
    
    InputFolder=Folders(Folder).name;
    disp(InputFolder)
    
    OutDir=strrep([Datasets.MarkRealWorldSplices '/' Folders(Folder).name], InputOrigRoot, [OutputRoot AlgorithmName '/']);
    mkdir(OutDir);
    FileList=[];
    for fileExtension={'*.jpg','*.jpeg','*.png','*.gif','*.tif','*.bmp'}
        FileList=[FileList;dir([Datasets.MarkRealWorldSplices '/' Folders(Folder).name '/' fileExtension{1}])];
    end
    
    FileList=FileList(1:end);
    for fileInd=1:length(FileList)
        InputFileName=[Datasets.MarkRealWorldSplices '/' InputFolder '/' FileList(fileInd).name];
        OutputName=[strrep(InputFileName,InputOrigRoot,[OutputRoot AlgorithmName '/']) '.mat'];
        if ~exist(OutputName)
            Salvaged=[OutputRoot  AlgorithmName '/RW/' FileList(fileInd).name '.mat'];
            if exist(Salvaged)
                Salv=load(Salvaged);
                Salve.Name=strrep(InputFileName,InputOrigRoot,'');
                save(OutputName, '-struct',Salv);
            else
                
                if strcmp(InputFileName(end-3:end),'.jpg') || strcmp(InputFileName(end-4:end),'.jpeg')
                    ImageIn=jpeg_read(InputFileName);
                else
                    ImageIn=CleanUpImage(InputFileName);
                end
                [Feature_Vector, Result, coeffArray] = Extract_Features(ImageIn);
                Name=strrep(InputFileName,InputOrigRoot,'');
                save(OutputName,'Name','AlgorithmName','Feature_Vector','Result','coeffArray','-v7.3');
            end
            if mod(fileInd,15)==0
                disp(fileInd)
            end
        end
    end
end
