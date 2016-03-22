clear all;
DatasetNames={'CARV';'COLUMB';'CHAL';'FON_REAL';'FON_SYN'};

for Dataset=1:5
    if Dataset~=4 && Dataset~=5
        JPEGIndex={'10' '01' '06' '08' '14'};
    else
        JPEGIndex={'10' '01' '02' '17' '05' '06' '08' '14'};
    end
    NoiIndex={'04' '16a' '16b' '07' '12'};
    
    AlgName=1;
    for ii=1:length(JPEGIndex)
        load(['NewChalCompactReport_' JPEGIndex{ii} '.mat']);
        Curve=Report.CompactCurves{1,Dataset}.KSPositives{1,1};
        Curves.JPEG.(['a' num2str(AlgName)]).Au=Curve(2,:);
        Curves.JPEG.(['a' num2str(AlgName)]).Sp=Curve(3,:);
        AlgName=AlgName+1;
    end
    
    AlgName=1;
    for ii=1:length(NoiIndex)
        load(['NewChalCompactReport_' NoiIndex{ii} '.mat']);
        Curve=Report.CompactCurves{1,Dataset}.KSPositives{1,1};
        Curves.NOI.(['a' num2str(AlgName)]).Au=Curve(2,:);
        Curves.NOI.(['a' num2str(AlgName)]).Sp=Curve(3,:);
        AlgName=AlgName+1;
    end
    save([DatasetNames{Dataset} 'MATNewChalCurves.mat'],'Curves');
    clear Curves;
end