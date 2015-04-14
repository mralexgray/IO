

#ifndef IO_IO_h
#define IO_IO_h

#import <IO/IO.h>

@interface _IO_Opts : NSObject <IO_Opts>

+ _Kind_ shared;

@end

#include <stdio.h>
#include <sys/ioctl.h>

#import "DDEmbeddedDataReader.h"
#import "NSNib+XMLBase64.h"

#define sqr(x) ((x) * (x))
typedef struct { int r; int g; int b; } rgb;

#if     MAC_ONLY
#import <ScriptingBridge/ScriptingBridge.h>
#define DEVICECLR(X) [X colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace]
#else
#define DEVICECLR(X)  X
#endif

#define COLOR_NUM(color) lroundf(c.color##Component*255)

#pragma mark -  Escapes

#define CSI "["        // Control Sequence Initiator

#define XC_FG     CSI "fg;" // Clear any foreground color
#define XC_BG     CSI "bg;" // Clear any background color
#define XC_RESET  CSI ";"   // Clear any foreground or background color

#define ANSI_FG     CSI "0;38;05;"
#define ANSI_BG     CSI "0;48;05;"
#define ANSI_RESET  CSI "m"  // Reset all SGR options.

#define RESET_FX IO.isxcode ? ";" : "m"


//#define ANSI_RESET_FG  "39m" // Reset foreground color.
//#define ANSI_RESET_BG  "49m" // Reset background color.
//#define ANSI_ESC "\x1b["



/*! Xcode does NOT natively support colors in the Xcode debugging console.
 You'll need to install the XcodeColors plugin to see colors in the Xcode console.
 The following is documentation from the XcodeColors project: https://github.com/robbiehanson/XcodeColors

 How to apply color formatting to your log statements:

 To set the foreground color:
 Insert the ESCAPE_SEQ into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.

 To set the background color:
 Insert the ESCAPE_SEQ into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.

 To reset the foreground color (to default value):
 Insert the ESCAPE_SEQ into your string, followed by "fg;"

 To reset the background color (to default value):
 Insert the ESCAPE_SEQ into your string, followed by "bg;"

 To reset the foreground and background color (to default values) in one operation:
 Insert the ESCAPE_SEQ into your string, followed by ";"
 */

//static const char *CSI = "\33[",
//       *CmdClearScreen = "2J";


_CAT( Colr, IO_Colr,

  + _Colr_ fromTTY: _UInt_ c;

  _RO _Numb tty;
  _RC _Text xcTuple, bgEsc, fgEsc
)

extern  int *_NSGetArgc(void);
extern char ***_NSGetArgv(void);

//typedef struct { int argc; char ** argv; } IOMain;


@Vows IONotifier <NSO> // <NSUserNotificationCenterDelegate>
@optional - initWithNotification:(NSNOT*)n;  // IN USE in IO.m
￭
@Kind(IONotifier,<IONotifier>) ￭




#endif



//@interface NSNumber (IO)
//+ (instancetype) scan;
//@end

//extern int rgb_2_tty (rgb c);
//extern int clr_2_tty (Clr c);
//
//extern Clr rgb_2_clr (rgb c);
//extern Clr tty_2_clr (int c);
//
//extern rgb clr_2_rgb (Clr c);
//extern rgb tty_2_rgb (int c);
