clear all;
close all;

DatasetNames={'CARV';'COLUMB';'CHAL';'FON_REAL'}

AlgorithmNames={'ADQ','ADQ2','CFA1','NADQ','ELA','NOI1', 'GHO', 'DCT', 'NOI2', 'BLK', 'CFA2', 'CFA3', 'MED'};

ColumnNames={'Original','100','95','85','75','65'};

DispAlgs=[1 7 10 5 13 6 ];
load('FP05.mat');



for Dataset=1:4;
    figure(1);
    bar(Output.Value{Dataset,3}(DispAlgs,:));
    axis([0 7 0 1]);
    legend(ColumnNames,'Location','best')
    
    
    xlabel(['Dataset: ' strrep(DatasetNames{Dataset},'_','\_')]);
    ylabel('True Positives for FP=5%');
    %title(['Dataset: ' strrep(DatasetNames{Dataset},'_','\_') ' | Algorithms: JPEG']);
    grid on;
    set(findall(gcf,'-property','FontSize'),'FontSize',12);
    set(gca,'fontsize',11,'XTickLabel',AlgorithmNames(DispAlgs))
    set(gcf,'Position',[220 320 860 330 ]);
    set(gcf,'PaperPositionMode','auto')
    savefig(['Figures/' DatasetNames{Dataset} 'Bar_SM.fig']);
    print(['Figures/' DatasetNames{Dataset} 'Bar_SM.png'],'-dpng','-r1200');
    
end