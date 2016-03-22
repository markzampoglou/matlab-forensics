clear all;
close all;

DatasetNames={'CARV';'COLUMB';'CHAL';'FON_REAL'}; %;'FON_SYN'} 'VIPP2';
for Dataset=1:4;
    
    load([DatasetNames{Dataset} 'MATCurves.mat'],'Curves');
    
    LineColors={'b','k','m','c','r','g','b'};
    MarkerStyles={'o','s','^','v','x','d','o'};
    LineStyles={'-','--',':','-.','-','--',':'};
    
    ALGFields=fieldnames(Curves.ALG);
    ALGNames={'DQ','GHO','BLK','ELA','MED','DW'};
    
    figure(1);
    plot(Curves.ALG.(ALGFields{1}).Au,Curves.ALG.(ALGFields{1}).Sp,[LineColors{1} MarkerStyles{1} LineStyles{1}],'MarkerFaceColor',LineColors{1},'LineWidth',2);
    axis([0 0.3 0 1]);
    xlabel('False Positives');
    ylabel('True Positives');
    title(['Dataset: ' strrep(DatasetNames{Dataset},'_','\_')]);
    hold on;
    for ii=2:length(ALGFields)
        plot(Curves.ALG.(ALGFields{ii}).Au,Curves.ALG.(ALGFields{ii}).Sp,[LineColors{ii} MarkerStyles{ii} LineStyles{ii}],'MarkerFaceColor',LineColors{ii},'LineWidth',2);
    end
    legend(ALGNames,'Location','best')
    grid on;
    set(findall(gcf,'-property','FontSize'),'FontSize',12)
    savefig(['Figures/' DatasetNames{Dataset} '-SM.fig']);
    print(['Figures/' DatasetNames{Dataset} '-SM.png'],'-dpng','-r1200');
    hold off;    
end