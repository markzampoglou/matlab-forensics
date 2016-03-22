clear all;

Algorithms={'01' '02' '17' '05' '06' '08' '10' '14' '04' '16a' '16b' '07' '12'};

for AlgorithmInd=1:length(Algorithms)
    
    R=load(['NewChalCompactReport_' Algorithms{AlgorithmInd} '.mat']);
    Fields=fieldnames(R.Report.CompactCurves{1,2});
    for DatasetInd=1:size(R.Report.CompactCurves,2)
        for FieldInd=1:length(Fields)
            for Quality=1:3
                NewSeries=R.Report.CompactCurves{DatasetInd}.(Fields{FieldInd}){Quality};
                Ind=1;
                if ~isempty(NewSeries)
                    while NewSeries(2,Ind)>0.05
                        Ind=Ind+1;
                    end
                    Output.Threshold{DatasetInd,FieldInd}(AlgorithmInd,Quality)=NewSeries(1,Ind);
                    Output.Value{DatasetInd,FieldInd}(AlgorithmInd,Quality)=NewSeries(3,Ind);
                end
            end
        end
        
    end
end

save('FP05_New.mat','Output');

