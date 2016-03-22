FileList=getAllFiles('/media/marzampoglou/3TB_A/AlgorithmOutput/16b/90_50','*.mat',true);
FileList=[FileList; getAllFiles('/media/marzampoglou/3TB_A/AlgorithmOutput/16b/90_75','*.mat',true)];
FileList=[FileList; getAllFiles('/media/marzampoglou/3TB_A/AlgorithmOutput/16b/90_95','*.mat',true)];

for File=1:length(FileList)
    load(FileList{File});
    if Result.F2Map==0
        delete(FileList{File});
    end
end