clear all;
DatasetNames={'CARV';'COLUMB';'CHAL';'FON_REAL'};

for Dataset=2:5
    CurveFiles=dir('CompactReport*.mat');
    AlgIndex=[1 6 9 4 12 5];
    
    AlgName=1;
    for ii=AlgIndex
        load(CurveFiles(ii).name);
        Curve=Report.CompactCurves{1,Dataset}.KSPositives{1,1};
        Curves.ALG.(['a' num2str(AlgName)]).Au=Curve(2,:);
        Curves.ALG.(['a' num2str(AlgName)]).Sp=Curve(3,:);
        AlgName=AlgName+1;
    end
    
    save([DatasetNames{Dataset-1} 'MATCurves.mat'],'Curves');
    clear Curves;
end