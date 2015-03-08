
@import AVFoundation; @import Darwin; @import AtoZAutoBox;

#import <AtoZIO/IO+Protocols.h>

typedef struct { NSUInteger col; NSUInteger row; } Position;

@interface AtoZIO : NSObject + (instancetype) io;

@property (readonly)  NSString * $0;       /* EXE */
@property (readonly)  NSNumber * $$;       /* PID */
@property (readonly)   NSArray * stdin, * stdinlines;
@property (readonly)    CGSize   size;
@property (readonly)       int   width, height;
@property (readonly)      BOOL   isatty, isxcode;

@property (nonatomic) NSString * prompt;


- (NSString*) prompt:(NSString*)_; /*! Read to String */
//- (NSString*) prompt:(NSString*)_ c:(int)c;

- (void) clearConsole; /*! Command-K */

@property (readonly,copy) NSString * scan;

@property Position cursorPosition;

@property (readonly) NSDictionary * infoPlist;

/*! Returns a NSDictionary or nil with embbedded data for the CURRENT executable
    @param s specific SEGMENT with the |section| to get data from
    @param x a SECTION to get data from
    @param e if a parsing error occurs and nil is returned, this is the NSError that occured
 */
+ (NSData*) embeddedDataFromSegment:(NSString*)s inSection:(NSString*)x error:(NSError**)e;

- (AVAudioPlayer*) playerForAudio:dataOrPath;

@end

@interface NSString (AtoZIO) <Bicolor>

- (void) echo;
- (void) print;
- (void) printC:color;
- (void) print256;

+ (NSString*) withColor:color fmt:(NSString*)fmt,...;

@end



#define IO AtoZIO.io // -=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-

#define UNO(instance) + (instancetype) instance { static dispatch_once_t u; static id uno; \
                      return dispatch_once(&u, ^{ uno = self.class.new; }),           uno; }

#define PROCINFO NSProcessInfo.processInfo


