
/*  NSNib+XMLBase64.h  *  AtoZCodeFactory */

@Xtra(NSNib,XMLBase64)

+ _Data_   dataFromXMLPath:_Text_ p _
+ _Text_ base64FromXMLPath:_Text_ p _
+ _Text_     xmlFromBase64:_Text_ p _
+ _Kind_    nibFromXMLPath:_Text_ s
                     owner:owner
                topObjects:(_List*)o _

@XtraStop(XMLBase64)

@Xtra(NSData,Base64)

+ _Data_      dataFromInfoKey:_Text_ k _
+ _Data_ dataFromBase64String:_Text_ s _
- _Text_  base64EncodedString _
- _Text_ base64EncodedStringWithSeparateLines:_IsIt_ separateLines _ // added by Hiroshi Hashiguchi

@XtraStop(Base64)
