In_Base='/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/';
FolderIn='IP_DIP/TwRes';
NameSuffix='_Tw';

SortedOutDir=['/media/marzampoglou/3TB/Recovery/Recuva/Excellent/Folders/folder_mat/SortedOut/' FolderIn '/'];
mkdir(SortedOutDir);

Out_Base='/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/';
FolderOut='IP_DIP/';
Quality=75;
Rescale=true;

FinalOutputFolder=[Out_Base FolderOut num2str(Quality) '_' num2str(Rescale) '/'];

InList=dir([In_Base FolderIn '/*.mat']);

for ii=1:length(InList)
    Loaded=load([In_Base FolderIn '/' InList(ii).name]);
    if strcmp(Loaded.Name(1:3),'D:\')
        Slashes=strfind(Loaded.Name,'\');
    else
        Slashes=strfind(Loaded.Name,'/');
    end
    Loaded.Name=strrep(Loaded.Name,'\','/');
    if ~isempty(Slashes)>0
        FinalSlash=Slashes(end);
        
        Dots=strfind(Loaded.Name,'.');
        FinalDot=Dots(end);
        
        OutBaseInd=strfind(Loaded.Name,'TwResJPEG/')+10;
        
        
        SubFolderStructure=Loaded.Name(OutBaseInd:FinalSlash);
        if ~exist([FinalOutputFolder SubFolderStructure], 'dir')
            mkdir([FinalOutputFolder SubFolderStructure]);
        end
        
        
        PlainName=Loaded.Name(FinalSlash+1:FinalDot-1);
        PlainName=strrep(PlainName,NameSuffix,'');
        PlainName=[PlainName Loaded.Name(FinalDot:end)];
        
        
        BinMask=Loaded.BinMask;
        Name=[SubFolderStructure PlainName];
        Result=Loaded.Result;
        
        if ~exist([FinalOutputFolder SubFolderStructure PlainName '.mat'],'file')
            save([FinalOutputFolder SubFolderStructure PlainName '.mat'], 'BinMask', 'Name', 'Result', 'Quality', 'Rescale', '-v7.3');
            system(['mv ' In_Base FolderIn '/' InList(ii).name ' ' SortedOutDir]);
        else  
            %disp(['File exists! ' FinalOutputFolder SubFolderStructure PlainName '.mat']);
            LExist=load([FinalOutputFolder SubFolderStructure PlainName '.mat']);
            pause;
        end
    else
        disp(['No slashes! ' Loaded.Name]);
    end
end