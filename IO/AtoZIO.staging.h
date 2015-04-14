
//+ (NSURL*) namePipe:(NSS*)path withData:(NSData*)d;

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

nscolor
 + (NSArray*)   x16;

//JREnumDeclare(



//@property                NSColor * fg, * bg; // set/get colors
//@property                    int   xfg, xbg; // 0-256 alters NSColor
//@property (readonly)  const char * cChar;    // string for color printing
//@property (readonly)    NSString * cString;  // nsstring for prining

//@property (readonly,copy) NSString *red, *orange, *yellow, *green, *blue;

//- _Void_ clear;

//@property (nonatomic) Color tinta, papel;
//@property (nonatomic) scrAttributes attributes;
//@property             scrPosition cursorPosition;
//@property (nonatomic) BOOL showCursor;

//- _Void_ moveCursorTo:(NSUInteger)fila column:(NSUInteger)columna;

#define MOVETO(R,C) IO.cursorPosition = (scrPosition){R,C}


@interface CALayer (IO)

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
//void      System16 ();
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


//#import <Darwin/Darwin.h>       // needed for winsize, ioctl etc
//#import <getopt.h>
//#import </a2z/AtoZMacroDefines.h>


//typedef struct {  int  hVal; int   sVal; int  bVal;
//                  CGFloat h; CGFloat  s; CGFloat b; } HsvColor;
//
//typedef struct {  int  rVal; int  gVal;  int  bVal;
//                  CGFloat r; CGFloat g;  CGFloat b; } RgbColor;
