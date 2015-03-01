
@import AVFoundation;  @import Foundation;   @import Darwin;
@import AtoZUniversal; @import AtoZAutoBox;  @import ExtObjC;

@protocol Bicolor <NSObject, IndexSet, KeyGet> @concrete

//  @"Apple"[2] -> fg -> 2/256  | color @"Apple"[ORANGE]  -> fgwith ORANGE color

@property id  fclr, bclr;
@property int ftty, btty;
@property (readonly) BOOL colored;
@property (readonly, copy) NSString *x;
- (id<Bicolor>) withFG:(id)_;
- (id<Bicolor>) withBG:(id)_;
@end

@protocol CLI <NSObject> @required
- (NSString*) :(SEL)_;
- (NSString*)  longOptForMethod:(SEL)_;

@concrete
@property (readonly) NSArray *methods;
@property (readonly, copy) NSString *usage;
@end

typedef struct { NSUInteger col; NSUInteger row; } Position;

@interface AtoZIO : NSObject + (instancetype) io;

@property (readonly)  NSString * $0;       /* EXE */
@property (readonly)  NSNumber * $$;       /* PID */
@property (readonly)   NSArray * args;
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

#import <AtoZIO/GBOptionsHelper.h>
#import <AtoZIO/GBSettings.h>


#define IO AtoZIO.io // -=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-

#define UNO(instance) + (instancetype) instance { static dispatch_once_t u; static id uno; \
                      return dispatch_once(&u, ^{ uno = self.class.new; }),           uno; }

#define PROCINFO NSProcessInfo.processInfo


