Statistics.F04_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/04/','*.mat',true);
Statistics.F04_2_MaxVals=zeros(1,length(Statistics.F04_List));
Statistics.F04_8_MaxVals=zeros(1,length(Statistics.F04_List));
Statistics.F04_2_MinVals=zeros(1,length(Statistics.F04_List));
Statistics.F04_8_MinVals=zeros(1,length(Statistics.F04_List));

for ii=1:length(Statistics.F04_List)
    Loaded=load(Statistics.F04_List{ii});
    Statistics.F04_2_MaxVals(ii)=max(max(Loaded.Result{1}));
    Statistics.F04_8_MaxVals(ii)=max(max(Loaded.Result{2}));
    Statistics.F04_2_MinVals(ii)=min(min(Loaded.Result{1}));
    Statistics.F04_8_MinVals(ii)=min(min(Loaded.Result{2}));
    if mod(ii,500)==0
        disp(ii)
    end
end

Statistics.F05_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/05/','*.mat',true);
Statistics.F05A_MinVals=zeros(1,length(Statistics.F05_List));
Statistics.F05NA_MinVals=zeros(1,length(Statistics.F05_List));
Statistics.F05A_MaxVals=zeros(1,length(Statistics.F05_List));
Statistics.F05NA_MaxVals=zeros(1,length(Statistics.F05_List));
for ii=1:length(Statistics.F05_List)
    Loaded=load(Statistics.F05_List{ii});
    Statistics.F05A_MaxVals(ii)=max(max(Loaded.Result{5,1}));
    Statistics.F05NA_MaxVals(ii)=max(max(Loaded.Result{5,2}));
    Statistics.F05A_MinVals(ii)=min(min(Loaded.Result{5,1}));
    Statistics.F05NA_MinVals(ii)=min(min(Loaded.Result{5,2}));
    if mod(ii,500)==0
        disp(ii)
    end
end

Statistics.F07_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/07/','*.mat',true);
Statistics.F07_MaxVals=zeros(1,length(Statistics.F07_List));
Statistics.F07_MinVals=zeros(1,length(Statistics.F07_List));
for ii=1:length(Statistics.F07_List)
    Loaded=load(Statistics.F07_List{ii});
    Statistics.F07_MaxVals(ii)=max(max(Loaded.Result));
    Statistics.F07_MinVals(ii)=min(min(Loaded.Result));
    if mod(ii,500)==0
        disp(ii)
    end
end

Statistics.F08_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/08/','*.mat',true);
Statistics.F08_MaxVals=zeros(1,length(Statistics.F08_List));
Statistics.F08_MinVals=zeros(1,length(Statistics.F08_List));
for ii=1:length(Statistics.F08_List)
    Loaded=load(Statistics.F08_List{ii});
    MassIms=[Loaded.Results.dispImages{:}];
    Statistics.F08_MaxVals(ii)=max(max(MassIms));
    Statistics.F08_MinVals(ii)=min(min(MassIms));
    if mod(ii,500)==0
        disp(ii)
    end
end

Statistics.F09_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/09/','*.mat',true);
Statistics.F09_MaxVals=zeros(1,length(Statistics.F09_List));
Statistics.F09_MinVals=zeros(1,length(Statistics.F09_List));
for ii=1:length(Statistics.F09_List)
    Loaded=load(Statistics.F09_List{ii});
    Statistics.F09_MaxVals(ii)=max(max(Loaded.Result.OutlierPrmsMap_filtered));
    Statistics.F09_MinVals(ii)=min(min(Loaded.Result.OutlierPrmsMap_filtered));
    if mod(ii,500)==0
        disp(ii)
    end
end

Statistics.F10_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/10/','*.mat',true);
Statistics.F10_MaxVals=zeros(1,length(Statistics.F10_List));
Statistics.F10_MinVals=zeros(1,length(Statistics.F10_List));
for ii=1:length(Statistics.F10_List)
    Loaded=load(Statistics.F10_List{ii});
    Statistics.F10_MaxVals(ii)=max(max(Loaded.Result));
    Statistics.F10_MinVals(ii)=min(min(Loaded.Result));    
    if mod(ii,500)==0
        disp(ii)
    end
end

Statistics.F12_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/12/','*.mat',true);
Statistics.F12_MaxVDCTVals=zeros(1,length(Statistics.F12_List));
Statistics.F12_MinVDCTVals=zeros(1,length(Statistics.F12_List));
Statistics.F12_MaxVHaarVals=zeros(1,length(Statistics.F12_List));
Statistics.F12_MinVHaarVals=zeros(1,length(Statistics.F12_List));
for ii=1:length(Statistics.F12_List)
    Loaded=load(Statistics.F12_List{ii});
    Statistics.F12_MaxVDCTVals(ii)=max(max(max(Loaded.Result.estVDCT)));
    Statistics.F12_MinVDCTVals(ii)=min(min(min(Loaded.Result.estVDCT)));
    Statistics.F12_MaxVHaarVals(ii)=max(max(max(Loaded.Result.estVHaar)));
    Statistics.F12_MinVHaarVals(ii)=min(min(min(Loaded.Result.estVHaar)));
    if mod(ii,500)==0
        disp(ii)
    end
end

Statistics.F14_List=getAllFiles('/media/marzampoglou/New_NTFS_Volume/markzampoglou/ImageForensics/AlgorithmOutput/14/','*.mat',true);
Statistics.MaxF14_Vals=zeros(1,length(Statistics.F14_List));
Statistics.MinF14_Vals=zeros(1,length(Statistics.F14_List));
for ii=1:length(Statistics.F14_List)
    Loaded=load(Statistics.F14_List{ii});
<<<<<<< HEAD
<<<<<<< HEAD
    Statistics.F14_MaxVals(ii)=max(max(Loaded.Result));
    Statistics.F14_MinVals(ii)=min(min(Loaded.Result));
=======
    Statistics.MaxF14_Vals(ii)=max(max(Loaded.Result));
    Statistics.MinF14_Vals(ii)=min(min(Loaded.Result));
>>>>>>> 9c91a43a5f9f9606503509c0f3394d63a8a749de
=======
    Statistics.MaxF14_Vals(ii)=max(max(Loaded.Result));
    Statistics.MinF14_Vals(ii)=min(min(Loaded.Result));
>>>>>>> origin/master
    if mod(ii,500)==0
        disp(ii)
    end
end




Statistics.F05A_Hist=hist(Statistics.F05A_Vals,[min(Statistics.F05A_Vals):max(Statistics.F05A_Vals)]);
Statistics.F05A_99=46;
Statistics.F05NA_Hist=hist(Statistics.F05NA_Vals,[min(Statistics.F05NA_Vals):max(Statistics.F05NA_Vals)]);
Statistics.F05NA_99=31;
<<<<<<< HEAD
<<<<<<< HEAD


Statistics.F04_2_Hist=hist(Statistics.F04_2_Vals,[min(Statistics.F05A_Vals):max(Statistics.F05A_Vals)]);
Statistics.F04_8_Hist=hist(Statistics.F04_8_Vals,[min(Statistics.F05NA_Vals):max(Statistics.F05NA_Vals)]);

=======
>>>>>>> 9c91a43a5f9f9606503509c0f3394d63a8a749de
=======
>>>>>>> origin/master
