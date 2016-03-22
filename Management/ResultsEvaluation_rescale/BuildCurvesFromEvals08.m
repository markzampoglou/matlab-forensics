clear all
AlgorithmNames={'08'};%'08'

InputRoot='/media/marzampoglou/3TB_A/AlgorithmOutput/Evaluations/';
Qualities=[90];
Rescales=[95 75 50];
DatasetList={'Carvalho','ColumbiauUncomp', 'FirstChallengeTrain','VIPPDempSchaReal', 'VIPPDempSchaSynth'}; %,  'VIPP2',  'FirstChallengeTest2'

Report.Qualities=Qualities';
for AlgInd=1:length(AlgorithmNames)
    AlgorithmName=AlgorithmNames{AlgInd};
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
                
                if ~isempty(EvalAu.Results)
                    AuKS={ResultsAu.KSStat};
                    AuKS(1,cellfun(@isempty,AuKS))=repmat({[0]},1,sum(cellfun(@isempty,AuKS)));
                    AuKS=reshape(AuKS,size(ResultsAu,1),size(ResultsAu,2));
                    AuKS=cell2mat(AuKS);

                    SpKS={ResultsSp.KSStat};
                    SpKS(1,cellfun(@isempty,SpKS))=repmat({[0]},1,sum(cellfun(@isempty,SpKS)));
                    SpKS=reshape(SpKS,size(ResultsSp,1),size(ResultsSp,2));
                    SpKS=cell2mat(SpKS);
                    
                    KSThreshValues=0:1/800:1;
                    KSListAu=max(AuKS,[],2);
                    KSListSp=max(SpKS,[],2);
                    
                    for ThreshInd=1:801
                        Thresh=KSThreshValues(ThreshInd);
                        Curves.KSPositives(1,ThreshInd)=mean(KSListAu>=Thresh);
                        Curves.KSPositives(2,ThreshInd)=mean(KSListSp>=Thresh);
                    end
                    Report.Curves{Dataset}.KSPositives{RescaleInd,QualityInd}=Curves.KSPositives;
                    Report.Curves{Dataset}.MedianPositives{RescaleInd,QualityInd}=[];
                    Report.Curves{Dataset}.MeanPositives{RescaleInd,QualityInd}=[];
                    
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