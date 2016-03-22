clear all
AlgorithmNames={'17'}; %{'01' '02' '04' '05' '06' '07' '10' '12' '14' '16a' '16b' '17'};%'08'

InputRoot='/media/marzampoglou/3TB_A/AlgorithmOutput/Evaluations/';
Qualities=[0 100 95 85 75 65];
Rescales=[false];
DatasetList={'Carvalho','ColumbiauUncomp', 'FirstChallengeTrain','VIPPDempSchaReal', 'VIPPDempSchaSynth'}; %,  'VIPP2',  'FirstChallengeTest2'

Report.Qualities=Qualities';
for AlgInd=1:length(AlgorithmNames)
    AlgorithmName=AlgorithmNames{AlgInd}
    for Dataset=1:length(DatasetList)
        for QualityInd=1:length(Qualities)
            Quality=Qualities(QualityInd);
            for RescaleInd=1:length(Rescales)
                Rescale=Rescales(RescaleInd);
                InputSet=DatasetList{Dataset};
                NameBase=[InputRoot AlgorithmName '/' num2str(Quality) '_' num2str(Rescale) '/' InputSet '_' ];
                if exist([NameBase 'Au.mat'],'file')
                    EvalAu=load([NameBase 'Au.mat']);
                else
                    EvalAu=load([NameBase 'au.mat']);
                end
                ResultsAu=EvalAu.Results;
                if exist([NameBase 'Sp.mat'],'file')
                    EvalSp=load([NameBase 'Sp.mat']);
                else
                    EvalSp=load([NameBase 'sp.mat']);
                end
                ResultsSp=EvalSp.Results;
                
                for Ind=1:length(ResultsAu)
                    if isnan(ResultsAu(Ind).KSStat)
                        ResultsAu(Ind).KSStat=1;
                    end
                    if isempty(ResultsAu(Ind).KSStat)
                        ResultsAu(Ind).KSStat=0;
                    end
                end
                for Ind=1:length(ResultsSp)
                    if isnan(ResultsSp(Ind).KSStat)
                        ResultsSp(Ind).KSStat=1;
                    end
                    if isempty(ResultsSp(Ind).KSStat)
                        ResultsSp(Ind).KSStat=0;
                    end
                end
                if ~isempty(EvalAu.Results)
                    MeansDiffsAu=cell2mat({ResultsAu.MaskMean})-cell2mat({ResultsAu.OutsideMean});
                    MeansDiffsSp=cell2mat({ResultsSp.MaskMean})-cell2mat({ResultsSp.OutsideMean});
                    MediansDiffsAu=cell2mat({ResultsAu.MaskMedian})-cell2mat({ResultsAu.OutsideMedian});
                    MediansDiffsSp=cell2mat({ResultsSp.MaskMedian})-cell2mat({ResultsSp.OutsideMedian});
                    
                    MeansDiffs=abs([MeansDiffsSp MeansDiffsAu]);
                    MediansDiffs=abs([MediansDiffsSp MediansDiffsAu]);
                    MeansRange=[prctile(MeansDiffs,2) prctile(MeansDiffs,98)];
                    MediansRange=[prctile(MediansDiffs,2) prctile(MediansDiffs,98)];
                    
                    MeanStep=(MeansRange(2)-MeansRange(1))/500;
                    MedianStep=(MediansRange(2)-MediansRange(1))/500;
                    MeanThreshValues=[-inf MeansRange(1):MeanStep:MeansRange(2) inf];
                    MedianThreshValues=[-inf MediansRange(1):MedianStep:MediansRange(2) inf];
                    
                    if length(MeanThreshValues)~=length(MedianThreshValues)
                        disp('something is wrong in the thresholding procedure');
                    end
                    
                    for ThreshInd=1:length(MeanThreshValues);
                        MeanThresh=MeanThreshValues(ThreshInd);
                        %Top row is authentic, bottom row is spliced
                        Curves.MeanPositives(1,ThreshInd)=mean(MediansDiffsAu>=MeanThresh);
                        Curves.MeanPositives(2,ThreshInd)=mean(MediansDiffsSp>=MeanThresh);
                    end
                    for ThreshInd=1:length(MedianThreshValues);
                        MedianThresh=MedianThreshValues(ThreshInd);
                        %Top row is authentic, bottom row is spliced
                        Curves.MedianPositives(1,ThreshInd)=mean(MeansDiffsAu>=MedianThresh);
                        Curves.MedianPositives(2,ThreshInd)=mean(MeansDiffsSp>=MedianThresh);
                    end
                    Curves.MeanThreshValues=MeanThreshValues;
                    Curves.MedianThreshValues=MedianThreshValues;
                    
                    KSThreshValues=0:1/800:1;
                    KSListAu={ResultsAu.KSStat};
                    KSListAu(cellfun(@isempty,KSListAu))={repmat(0,[1 length(KSListAu(cellfun(@isempty,KSListAu)))])};
                    KSListAu=cell2mat(KSListAu);
                    KSListSp={ResultsSp.KSStat};
                    KSListSp(cellfun(@isempty,KSListSp))={repmat(0,[1 length(KSListSp(cellfun(@isempty,KSListSp)))])};
                    KSListSp=cell2mat(KSListSp);
                    
                    for ThreshInd=1:801
                        Thresh=KSThreshValues(ThreshInd);
                        Curves.KSPositives(1,ThreshInd)=mean(KSListAu>=Thresh);
                        Curves.KSPositives(2,ThreshInd)=mean(KSListSp>=Thresh);
                    end
                    Report.Curves{Dataset}.KSPositives{RescaleInd,QualityInd}=Curves.KSPositives;
                    Report.Curves{Dataset}.MedianPositives{RescaleInd,QualityInd}=Curves.MedianPositives;
                    Report.Curves{Dataset}.MeanPositives{RescaleInd,QualityInd}=Curves.MeanPositives;
                    
                    %                    PresentationCurves.Means=CompactCurve(Curves.MeanPositives,Curves.MeanThreshValues);
                    %                    PresentationCurves.Medians=CompactCurve(Curves.MedianPositives,Curves.MedianThreshValues);
                    PresentationCurves.KS=CompactCurve(Curves.KSPositives,0:1/(size(Curves.KSPositives,2)-1):1);
                    
                    Report.DatasetNames{Dataset,1}=InputSet;
                    
                    Report.CompactCurves{Dataset}.MeanPositives{RescaleInd,QualityInd}=[];
                    Report.CompactCurves{Dataset}.MedianPositives{RescaleInd,QualityInd}=[];
                    %                    Report.CompactCurves{Dataset}.MeanPositives{RescaleInd,QualityInd}=PresentationCurves.Means;
                    %                    Report.CompactCurves{Dataset}.MedianPositives{RescaleInd,QualityInd}=PresentationCurves.Medians;
                    Report.CompactCurves{Dataset}.KSPositives{RescaleInd,QualityInd}=PresentationCurves.KS;
                else
                    Report.DatasetNames{Dataset,1}=InputSet;
                    Report.CompactCurves{Dataset}.MeanPositives{RescaleInd,QualityInd}=[];
                    Report.CompactCurves{Dataset}.MedianPositives{RescaleInd,QualityInd}=[];
                    Report.CompactCurves{Dataset}.KSPositives{RescaleInd,QualityInd}=[];
                end
            end
        end
    end
    
    save(['NewChalCompactReport_' AlgorithmName],'Report');
end