InputDirList=dir('/media/marzampoglou/3TB_B/ImageForensics/Datasets/Challenge/dataset-dist/phase-01/training/fake/*.png');

InputList=strcat('/media/marzampoglou/3TB_B/ImageForensics/Datasets/Challenge/dataset-dist/phase-01/training/fake/', {InputDirList.name});
MaskList=strcat('/media/marzampoglou/3TB_B/ImageForensics/Datasets/Masks/Challenge/dataset-dist/phase-01/training/fake/', {InputDirList.name});


%% parameters 
% parameters Feature Extraction
param = struct();
param.type_feat = 2; % type of feature, one of the following:
    % 1) ZM-cart
    % 2) ZM-polar 
    % 3) PCT-cart
    % 4) PCT-polar
    % 5) FMT (log-polar)

diameter_feat = {16,16,16,16,24}; 
param.diameter  = diameter_feat{param.type_feat}; % patch diameter
param.ZM_order  = 5;
param.PCT_NM    = [0,0;0,1;0,2;0,3; 1,0;1,1;1,2;2,0;2,1;3,0];
param.FMT_N     = -2:2; param.FMT_M  =  0:4;
param.radiusNum = 26; % number of sampling points along the radius
param.anglesNum = 32; % number of sampling points along the circumferences
param.radiusMin = sqrt(2); % minimun radius for FMT

% parameters Matching
param.num_iter = 8; % N_{it} = number of iterations
param.th_dist1 = 8; % T_{D1} = minimum length of offsets
param.num_tile = 1; % number of thread

% parameters Post Processing
param.th2_dist2 = 50*50; % T^2_{D2} = minimum diatance between clones
param.th2_dlf   = 300;   % T^2_{\epsion} = threshold on DLF error
param.th_sizeA  = 1200;  % T_{S} = minimum size of clones
param.th_sizeB  = 1200;  % T_{S} = minimum size of clones
param.rd_median = 4;     % \rho_M = radius of median filter
param.rd_dlf    = 6;     % \rho_N = radius of DLF patch
param.rd_dil    = param.rd_dlf+param.rd_median; % \rho_D = radius for dilatetion

Matches=cell(0);
Percentages=[];
for ii=1:length(InputList)
    Image=imread(InputList{ii});
    Mask=imread(MaskList{ii});
    Mask=~(mean(imresize(Mask,[size(Image,1) size(Image,2)]),3)>128);
    [CMMask,param,data] = CMFD_PM(Image,param);
    %imagesc(Image);
    CMMask=imresize(CMMask,[size(Image,1) size(Image,2)])>0.5;
    MatchPercentage=mean(Mask(CMMask));
    if MatchPercentage>0.2
        disp(['found ' num2str(ii)]);
        Matches{ii}=InputList{ii};
        Percentages(ii)=MatchPercentage;
        DispResult=zeros(size(Mask,1),2*size(Mask,2)+20);
        DispResult(1:size(Mask,1),1:size(Mask,2))=Mask;
        DispResult(1:size(Mask,1),size(Mask,2)+21:end)=CMMask;
        [a,b,c]=fileparts(InputList{ii});
        imwrite(DispResult,['ChallengeDetections/' b '.' c]);
    end
    if mod(ii,50)==0
        disp(ii)
    end
end