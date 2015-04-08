
/*  NSNib+XMLBase64.h  *  AtoZCodeFactory */

@Xtra(NSNib,XMLBase64)

+ _Data_   dataFromXMLPath:_Text_ p ___
+ _Text_ base64FromXMLPath:_Text_ p ___
+ _Text_     xmlFromBase64:_Text_ p ___
+ _Kind_    nibFromXMLPath:_Text_ s
                     owner:owner
                topObjects:(_List*)o ___

@XtraStop(XMLBase64)

@Xtra(NSData,Base64)

+ _Data_      dataFromInfoKey:_Text_ k ___
+ _Data_ dataFromBase64String:_Text_ s ___
- _Text_  base64EncodedString ___
- _Text_ base64EncodedStringWithSeparateLines:_IsIt_ separateLines ___ // added by Hiroshi Hashiguchi

@XtraStop(Base64)
