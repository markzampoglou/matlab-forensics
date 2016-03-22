CopyMoves=dir('/media/marzampoglou/3TB_B/ImageForensics/Datasets/CopyMovedChallenge/dataset-dist/phase-01/training/fake/*.png');
CopyMoves={CopyMoves.name};

ImplementedAlgorithms=dir('/media/marzampoglou/3TB_A/AlgorithmOutput/Evaluations/');
ImplementedAlgorithms={ImplementedAlgorithms(3:end).name};

ImplementedAlgorithms={'05' '17'}; % {'01' '02' '04' '06' '07' '08' '10' '12' '14' '16a' '16b'}; %

for Alg=1:length(ImplementedAlgorithms)
    ScaleRecomp=dir(['/media/marzampoglou/3TB_A/AlgorithmOutput/Evaluations/' ImplementedAlgorithms{Alg} '/']);
    ScaleRecomp={ScaleRecomp(3:end).name};
    for SR=1:length(ScaleRecomp)
        ChallengeEvals=dir(['/media/marzampoglou/3TB_A/AlgorithmOutput/Evaluations/' ImplementedAlgorithms{Alg} '/' ScaleRecomp{SR} '/' 'FirstChallenge*']);
        for EvalFile=1:length(ChallengeEvals)
            Eval=load(['/media/marzampoglou/3TB_A/AlgorithmOutput/Evaluations/' ImplementedAlgorithms{Alg} '/' ScaleRecomp{SR} '/' ChallengeEvals(EvalFile).name]);
            for CopiedFile=1:length(CopyMoves)
                IndexC = strfind(Eval.Names,CopyMoves{CopiedFile});
                Index = find(not(cellfun('isempty', IndexC)));
                if ~isempty(Index)
                    Eval.Names=Eval.Names([1:Index-1 Index+1:end]);
                    Eval.Results=Eval.Results([1:Index-1 Index+1:end]);
                end
            end
            save(['/media/marzampoglou/3TB_A/AlgorithmOutput/Evaluations/' ImplementedAlgorithms{Alg} '/' ScaleRecomp{SR} '/' ChallengeEvals(EvalFile).name],'-struct','Eval');
        end
    end
end