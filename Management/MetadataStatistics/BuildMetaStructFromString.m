function MetaStructOut = BuildMetaStructFromString( StringIn )
    %BUILDMETASTRUCTFROMSTRING Summary of this function goes here
    %   Detailed explanation goes here
    SplitString=strsplit(StringIn,',');
    for FieldInd=1:length(SplitString)
        Field=SplitString{FieldInd};
        NameVal=strsplit(Field,':');
        CategoryName=strsplit(NameVal{1},'.');
        Category=matlab.lang.makeValidName(urldecode(CategoryName{1}),'ReplacementStyle','hex');
        Name=matlab.lang.makeValidName(urldecode(CategoryName{2}),'ReplacementStyle','hex');
        Val=matlab.lang.makeValidName(urldecode(NameVal{2}),'ReplacementStyle','hex');
        MetaStructOut.(Category).(Name)=Val;
    end
end