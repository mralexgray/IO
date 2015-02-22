

@import Darwin;
@import AppKit;
@import QuartzCore;
@import ObjectiveC;
@import AVFoundation;

// Imports all source files for GBCli
#import "GBCommandLineParser.h"
#import "DDEmbeddedDataReader.h"

@interface AtoZIO : NSObject

+ (NSString*) exePath;
+  (NSArray*) args;     /* OK */

@property NSString *prompt;

+ (BOOL) inTTY;          /// Seems accurate..
+ (BOOL) inXcode;

#pragma mark - TERM info

/// from AtoZ...  @prop_RO BOOL 	inTTY & inXcode;  (Seems accurate..)

/*! Read to String */ + (NSString*) readWithPrompt:(NSString*)_;
/*! Command-K      */ + (void) clearConsole;  /* OK */
/*! ie. 80 x 33    */

+ (NSSize) terminal_size;
+    (int) terminal_width;
+    (int) terminal_height;

/** -=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-
 Returns the embbedded data for the CURRENT executable from a specific section in a specific segment.
    Segment is %SPECIFIED% Section is %SPECIFIED%
	@param segment a segment with the |section| to get data from
	@param section a section to get data from
	@param error if a parsing error occurs and nil is returned, this is the NSError that occured
	@return a NSDictionary or nil
 */
+ (NSData*)embeddedDataFromSegment:(NSString*)seg inSection:(NSString*)sec error:(NSError**)e;

+ (AVAudioPlayer*) playerForAudio:dataOrPath;

+ (NSDictionary*)parseArgs:(char *[])argv andKeys:(NSArray*)keys count:(int)argc;

//+ (NSURL*) namePipe:(NSS*)path withData:(NSData*)d;
@end


static BOOL  clear_screen = YES,  //	Clear the screen between frames (as opposed to reseting the cursor position) // IF NO works, but shitty
                   telnet = NO;   //	Are we currently in telnet mode?

FOUNDATION_EXPORT void print_with_newlines ( char *, ...);
FOUNDATION_EXPORT void             newline (  int );
FOUNDATION_EXPORT void        reset_cursor ( void );
FOUNDATION_EXPORT void          clr_screen ( void );
//FOUNDATION_EXPORT NSString *   read_string ( void );
//FOUNDATION_EXPORT NSNumber *   read_number ( void );

typedef struct _zTermSize {   int width;
                              int height; } zTermSize;
#pragma mark COLOR


//JREnumDeclare(
typedef NS_ENUM(int,FMTOptions){

                  FMT_BOLD      = 0x00000001,
                  FMT_UNDL      = 0x00000010,
                  FMT_BLNK      = 0x00000100,
                  FMT_NEG       = 0x00001000,
                  FMT_POS       = 0x00011000,
                  FMT_FRAME     = 0x00100000,
                  FMT_ENCIRCLE  = 0x01000000,
                  FMT_OVERLINED = 0x10000000,
                  FMT_NO_RESET  = 0x11111111
};

@interface NSColor  (atozio)

+ (NSArray*) x16;
+ (NSColor*) xColor:(int)x;

@property NSColor *bg, *fg; // Essentially allows a "two-tone" nscolor.

- (NSColor*) withBG:(NSColor*)c;
- (NSColor*) withFG:(NSColor*)c;

@end

@interface NSString (atozio)

@property FMTOptions   options;
@property    NSColor * color;
@property (readonly)  const char *cChar;
@property (readonly) NSString * xString;

@property (readonly,copy) NSString *red, *orange, *yellow, *green, *blue;

- (void) echo;
- (void) print;
- (void) printInColor:(NSColor*)c;

+ (instancetype) withColor:(NSColor*)c fmt:(NSString*)fmt,...;
+ (instancetype) scan;

@end

@interface NSNumber (atozio)
+ (instancetype) scan;
@end


@interface CALayer (atozio)

@property (readonly) const char * xString;

@end


@interface NSBundle (Fake)

+ (BOOL) pretendToBe:appNameOrID;

@end

//void  zPrint (NSC* fg, NSC*bg, FMTOptions opts, NSS* fmt, ...);



/*!	char **argv = *_NSGetArgv();
    NSString *commandLineArg = sizeof(argv) > 1 && !!argv[1] ? @(argv[1])
                                                             : @"/tmp/scorecard-pipe";  // No argument specified, using xyz
extern char ***_NSGetArgv (void);
extern int     _NSGetArgc (void);
*/

extern int *_NSGetArgc(void);
extern char ***_NSGetArgv(void);

/*! mkfifo @code

  NSString *pipePath = @"..."

  if ( mkfifo(pipePath.UTF8String, 0666) == -1 && errno !=EEXIST)	NSLog(@"Unable to open the named pipe %@", pipePath);
	
	int fd = open(pipePath.UTF8String, O_RDWR | O_NDELAY);

	filehandleForReading = [NSFileHandle.alloc initWithFileDescriptor:fd closeOnDealloc: YES];

	[NSNotificationCenter.defaultCenter     removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserverForName:NSFileHandleReadCompletionNotification
                                                  object:filehandleForReading queue:NSOperationQueue.mainQueue
                                              usingBlock:^(NSNotification *n) {

    NSData *d = n.userInfo[NSFileHandleNotificationDataItem];

    if (d.length) {
      NSLog(@"dataReady:%lu bytes", d.length);
      /// .... NSString * dataString = [NSString.alloc initWithData:d encoding:NSASCIIStringEncoding];
    }
    [filehandleForReading readInBackgroundAndNotify]; //Tell the fileHandler to asychronusly report back

  }];

	[filehandleForReading readInBackgroundAndNotify];
*/
extern int         mkfifo (const char *, mode_t);


#define CHAR_FMT(...) [NSString stringWithFormat:@__VA_ARGS__].UTF8String

char term[1024] = {'a','n','s','i', 0};  /* The default terminal is ANSI */

/*	I refuse to include libm to keep this low on external dependencies. Count the number of digits in a number for use with string output.	*/

NS_INLINE int digits(int val){

  int d = 1,c; val >= 0 ? ({ for (c =  10; c <= val; c *= 10) d++; }) : ({ for (c = -10; c >= val; c *= 10) d++; });  return c < 0 ? ++d : d;
}




@interface AtoZOption : NSObject
@property NSString* name;
@end

void       ClrPlus (const char* c);
void    PrintInClr (const char* s, int color);
void      PrintClr (int color);
void   SystemGrays ();
void      System16 ();
void    FillScreen (int color);
void      Spectrum ();
void   AllColors(void(^)(int color));
void PrintInRnd(id x,...);

//typedef    int zColor;
//typedef RgbColor zColorRGB;

typedef struct zColorRGB { int r;
                           int g;
                           int b; } zColorRGB;

//int      rgb_to_xterm ( NSC*);


#pragma mark - Lil functions.

NSString *define(NSString*);


//  NSColor+HSVExtras.h MMPieChart Demo Created by Manuel de la Mata Sáez on 07/02/14.  Copyright (c) 2014 Manuel de la Mata Sáez. All rights reserved.

typedef struct { int hueValue; int saturationValue; int brightnessValue; CGFloat hue; CGFloat saturation; CGFloat brightness; } HsvColor;
typedef struct { int rVal; int gVal; int bVal; CGFloat r; CGFloat g; CGFloat b; } RgbColor;

@interface NSColor (HSVExtras)

+ (HsvColor) hsvColorFromColor:(NSColor*)c;
+ (RgbColor) rgbColorFromColor:(NSColor*)c;

@property (readonly) HsvColor hsvColor;
@property (readonly) RgbColor rgbColor;
@property (readonly)      CGFloat hue,
                  saturation,
                  brightness,
                  value,
                  red, green, blue, white, alpha;
@end


#ifndef XCODE_COLORS_DEFS
#define XCODE_COLORS_DEFS
#pragma mark - COLOR LOGGING
/*	Foreground color: Insert the ESCAPE_SEQ into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
 Background color:	 	Insert the ESCAPE_SEQ into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
 Reset the foreground color (to default value):	Insert the ESCAPE_SEQ into your string, followed by "fg;"
 Reset the background color (to default value):	Insert the ESCAPE_SEQ into your string, followed by "bg;"
 Reset the fground and bground color (to default values) in 1 operation: Insert the ESCAPE_SEQ into your string, followed by ";"
 */
#if TARGET_OS_IPHONE
#define 	XCODE_COLORS_ESCAPE  @"\xC2\xA0["
#else
#define 	XCODE_COLORS_ESCAPE  @"\033["
#define 	CHAR_ESCAPE  "\033["
#define   CHAR_RESET  CHAR_ESCAPE ";"
#endif
#define 	XCODE_COLORS_RESET_FG  	XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define 	XCODE_COLORS_RESET_BG  	XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define 	XCODE_COLORS_RESET	 		XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define 	COLOR_RESET 					XCODE_COLORS_RESET
#define 	COLOR_ESC 					XCODE_COLORS_ESCAPE

#endif


//@import Darwin;       // needed for winsize, ioctl etc
//#import <getopt.h>
//#import </a2z/AtoZMacroDefines.h>
