% What about the Ghosts?????

% First we must compact the outputs into "Evaluations"
EvaluateMaskRegionStatisticsSynthetic
% Then we build curves from the evaluations
CreateMaskROCCurve
% Then we throw out the repetitions
CompactReports

%This can be substituted by BuildCurvesFromEvals
BuildCurvesFromEvals

% Then we group only the 100_0 curves into a package for each dataset
CreateCurveFiles
%Plot the curves
PlotMatlabROC


%Also build the F05 file
Get05FP
%Plot the bars
PlotMatlabBars