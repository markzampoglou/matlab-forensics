load('../Datasets.mat');
FeatureLength=18;
upLimit=inf;

%for ii=[60:5:95]
%    disp(['Q2: ' num2str(ii)]);
%   List=getAllFiles(LuoArtificial.au, ['*_' num2str(ii) '.jpg'], true);
%   Features=zeros(length(List), FeatureLength);
%  for jj=1:length(List)
%       Features(jj,:)=Extract_Features(List{jj});
%       if mod(jj,20)==0
%          disp(jj);
%      end
% end
%  save(['./Descriptors/ArtificialSet/' num2str(ii) '-au.mat'],'Features','List');
%
%  List=getAllFiles(LuoArtificial.sp, ['*_' num2str(ii) '.jpg'], true);
%  Features=zeros(length(List), FeatureLength);
%  for jj=1:length(List)
%     Features(jj,:)=Extract_Features(List{jj});
%     if mod(jj,20)==0
%         disp(jj);
%     end
%  end
% save(['./Descriptors/ArtificialSet/' num2str(ii) '-sp.mat'],'Features','List');
% end

DataPath={CASIA2.au, CASIA2.tp, ColumbiaImage.au, ColumbiaImage.sp, ColumbiauUncomp.au, ColumbiauUncomp.sp, UCID.au, VIPPDempSchaReal.au, VIPPDempSchaReal.sp, VIPPDempSchaSynth.au, VIPPDempSchaSynth.sp, CASIA2Tw.au, CASIA2Tw.tp, ColumbiaImageTw.au, ColumbiaImageTw.sp, ColumbiauUncompTw.au, ColumbiauUncompTw.sp, UCIDTw.au, VIPPDempSchaRealTw.au, VIPPDempSchaRealTw.sp, VIPPDempSchaSynthTw.au, VIPPDempSchaSynthTw.sp, CASIA2TwRes.au, CASIA2TwRes.tp, ColumbiaImageTwRes.au, ColumbiaImageTwRes.sp, ColumbiauUncompTwRes.au, ColumbiauUncompTwRes.sp, UCIDTwRes.au, VIPPDempSchaRealTwRes.au, VIPPDempSchaRealTwRes.sp, VIPPDempSchaSynthTwRes.au, VIPPDempSchaSynthTwRes.sp};
OutNames={'CASIA2_au.mat', 'CASIA2_tp.mat', 'ColumbiaImage_au.mat', 'ColumbiaImage_sp.mat', 'ColumbiauUncomp_au.mat', 'ColumbiauUncomp_sp.mat', 'UCID_au.mat', 'VIPPDempSchaReal_au.mat', 'VIPPDempSchaReal_sp.mat', 'VIPPDempSchaSynth_au.mat', 'VIPPDempSchaSynth_sp.mat', 'CASIA2Tw_au.mat', 'CASIA2Tw_tp.mat', 'ColumbiaImageTw_au.mat', 'ColumbiaImageTw_sp.mat', 'ColumbiauUncompTw_au.mat', 'ColumbiauUncompTw_sp.mat', 'UCIDTw_au.mat', 'VIPPDempSchaRealTw_au.mat', 'VIPPDempSchaRealTw_sp.mat', 'VIPPDempSchaSynthTw_au.mat', 'VIPPDempSchaSynthTw_sp.mat', 'CASIA2TwRes_au.mat', 'CASIA2TwRes_tp.mat', 'ColumbiaImageTwRes_au.mat', 'ColumbiaImageTwRes_sp.mat', 'ColumbiauUncompTwRes_au.mat', 'ColumbiauUncompTwRes_sp.mat', 'UCIDTwRes_au.mat', 'VIPPDempSchaRealTwRes_au.mat', 'VIPPDempSchaRealTwRes_sp.mat', 'VIPPDempSchaSynthTwRes_au.mat', 'VIPPDempSchaSynthTwRes_sp.mat'};

for FolderInd=1:length(DataPath)
    List=[getAllFiles(DataPath{FolderInd},'*.jpg',true); getAllFiles(DataPath{FolderInd},'*.jpeg',true);];
    
    
    OutPath=OutNames{FolderInd} ;
    disp(OutPath);
    
    Features=zeros(length(List),FeatureLength);
    
    
    for ii=1:min(length(List),upLimit)
        if mod(ii,20)==0
            disp(ii);
        end
        filename=List{ii};
        Features(ii,:)=ExtractFeatures(List{ii});
        save(['.\Descriptors\' OutPath],'Features','List','-v7.3');
    end
end