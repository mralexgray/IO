
/*  NSNib+XMLBase64.h  *  AtoZCodeFactory */

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#endif

@interface			             NSNib (XMLBase64)
+      (NSData*)   dataFromXMLPath:(NSString*)p;
+    (NSString*) base64FromXMLPath:(NSString*)p;
+    (NSString*)     xmlFromBase64:(NSString*)p;
+ (instancetype)    nibFromXMLPath:(NSString*)s
														 owner:(id)owner
												topObjects:(NSArray**)objs;
@end

@interface NSData (Base64)
+   (NSData*)      dataFromInfoKey:(NSString*)k;
+   (NSData*) dataFromBase64String:(NSString*)s;
- (NSString*)  base64EncodedString;
- (NSString*) base64EncodedStringWithSeparateLines:(BOOL)separateLines; // added by Hiroshi Hashiguchi
@end
