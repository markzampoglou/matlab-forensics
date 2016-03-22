clear all;
close all;

DatasetNames={'CARV';'COLUMB';'CHAL';'FON_REAL';'FON_SYN'}; % 'VIPP2';
for Dataset=1:5;
    load([DatasetNames{Dataset} 'MATCurves.mat'],'Curves');
    
    JPEGLineColors={'b','k','b','k','m','c','r','g'};
    JPEGMarkerStyles={'o','s','s','v','^','v','x','d'};
    JPEGLineStyles={'-','--',':','-.',':','-.','-','--'};

    NOILineColors={'b','k','m','c','r','g','b','k'};
    NOIMarkerStyles={'o','s','^','v','x','d','s','v'};
    NOILineStyles={'-','--',':','-.','-','--',':','-.'};
    
    
    JPEGFields=fieldnames(Curves.JPEG);
    JPEGNames={'DCT','ADQ1','ADQ2','ADQ3','NADQ','ELA','GHO','BLK'};
    if length(fieldnames(Curves.JPEG))==8
        JPEGIndex=1:8;
    else
        JPEGIndex=[1 2 6 7 8];
    end
    
    figure(1);
    plot(Curves.JPEG.(JPEGFields{1}).Au,Curves.JPEG.(JPEGFields{1}).Sp,[JPEGLineColors{1} JPEGMarkerStyles{1} JPEGLineStyles{1}],'MarkerFaceColor',JPEGLineColors{1},'LineWidth',2);
    axis([0 0.3 0 1]);
    xlabel('False Positives');
    ylabel('True Positives');
    title(['Dataset: ' strrep(DatasetNames{Dataset},'_','\_') ' | Algorithms: JPEG']);
    hold on;
    for ii=2:length(JPEGFields)
        plot(Curves.JPEG.(JPEGFields{ii}).Au,Curves.JPEG.(JPEGFields{ii}).Sp,[JPEGLineColors{JPEGIndex(ii)} JPEGMarkerStyles{JPEGIndex(ii)} JPEGLineStyles{JPEGIndex(ii)}],'MarkerFaceColor',JPEGLineColors{JPEGIndex(ii)},'LineWidth',2);
    end
    legend(JPEGNames(JPEGIndex),'Location','best')
    grid on;
    set(findall(gcf,'-property','FontSize'),'FontSize',12)
    savefig(['Figures/' DatasetNames{Dataset} '-JPEG.fig']);
    print(['Figures/' DatasetNames{Dataset} '-JPEG.png'],'-dpng','-r1200');
    hold off;
    
    NoiFields=fieldnames(Curves.NOI);
    NoiNames={'CFA1', 'CFA2', 'CFA3', 'NOI1', 'NOI2'};
    figure(2);
    plot(Curves.NOI.(NoiFields{1}).Au,Curves.NOI.(NoiFields{1}).Sp,[NOILineColors{1} NOIMarkerStyles{1} NOILineStyles{1}],'MarkerFaceColor',NOILineColors{1},'LineWidth',2);
    axis([0 0.3 0 1]);
    xlabel('False Positives');
    ylabel('True Positives');
    title(['Dataset: ' strrep(DatasetNames{Dataset},'_','\_') ' | Algorithms: CFA-Noise']);
    hold on;
    for ii=2:length(NoiFields)
        plot(Curves.NOI.(NoiFields{ii}).Au,Curves.NOI.(NoiFields{ii}).Sp,[NOILineColors{ii} NOIMarkerStyles{ii} NOILineStyles{ii}],'MarkerFaceColor',NOILineColors{ii},'LineWidth',2);
    end
    legend(NoiNames,'Location','best')
    grid on;
    set(findall(gcf,'-property','FontSize'),'FontSize',12)
    savefig(['Figures/' DatasetNames{Dataset} '-NOISE.fig']);
    print(['Figures/' DatasetNames{Dataset} '-NOISE.png'],'-dpng','-r1200');
    hold off;
    disp('done');
end