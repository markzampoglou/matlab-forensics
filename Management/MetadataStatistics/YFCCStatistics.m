MaxValues=250;
N = 1000;
SkippingStep=5;
fileID = fopen('/media/marzampoglou/3TB_B/ImageForensics/Datasets/YFCC Dataset/yfcc100m_exif');
formatSpec = '%s %s';
k = 0;
%StatisticsStruct2=struct;
load('Statistics2.mat');
for package=1:464
    k = k+1;
    C = textscan(fileID,formatSpec,N,'CommentStyle','##','Delimiter','\t');
end
while ~feof(fileID)
    k = k+1;
    C = textscan(fileID,formatSpec,N,'CommentStyle','##','Delimiter','\t');
    C=C{2};
    for LineInd=1:SkippingStep:length(C)
        MetadataLine=C{LineInd};
        if ~strcmp(MetadataLine,'')
            MetadataStruct=BuildMetaStructFromString(MetadataLine);
            Categories=fieldnames(MetadataStruct);
            for Cat=1:length(Categories)
                Category=Categories{Cat};
                Fields=fieldnames(MetadataStruct.(Category));
                for Fie=1:length(Fields)
                    FieldName=Fields{Fie};
                    FieldValue=MetadataStruct.(Category).(FieldName);
                    if isfield(StatisticsStruct2,Category) && isfield(StatisticsStruct2.(Category),FieldName)
                        StatisticsStruct2.(Category).(FieldName).OverallFrequency=StatisticsStruct2.(Category).(FieldName).OverallFrequency+1;
                        if length(fieldnames(StatisticsStruct2.(Category).(FieldName)))<MaxValues
                            if isfield(StatisticsStruct2.(Category).(FieldName),FieldValue)
                                StatisticsStruct2.(Category).(FieldName).(FieldValue)=StatisticsStruct2.(Category).(FieldName).(FieldValue)+1;
                            else
                                StatisticsStruct2.(Category).(FieldName).(FieldValue)=1;
                            end
                        end
                    else
                        StatisticsStruct2.(Category).(FieldName).OverallFrequency=1;
                        StatisticsStruct2.(Category).(FieldName).(FieldValue)=1;
                    end
                end
            end
        end
    end
    disp('Package done');
    save('Statistics2.mat','StatisticsStruct2');
end
fclose(fileID);

