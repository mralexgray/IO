
#import <ToolKit/TK+Protocols.h>  // Public interfaces of ancillary features.

@KIND(ToolKit) < IO_Opts,         // Unique protocol handles all IO, option parsing.
                 RectLike,        // Inherits tons of funvtions that allow it to be treated like an NSRect.
                 Subscriptable >  // Protocol declares indexed and keyed subscription.

#define IO ((ToolKit*)[ToolKit shared])

_RO  _Main          main          ｜( 'struct with argc + argv, get it anywhere!' )
_RO  _Ptty           env          ｜( 'where we runnin at? color, xcode vs tty, etc' )
_NC ＾SInt signalHandler ___

_RO _List args              ￤( 'JUST the args, maam'  )
__        stdinlines        ｜( 'readline?'            )

_NC _ObjC stream            ｜( 'stdin + stdout'       )

_NA _IsIt hideCursor        ｜( 'peek-a-boo'           )


_NC _Text title             ｜( 'console window title'                       )

_RC _Text scan
__        resetFX           ｜( 'needs doc'                                )

_NA _Text prompt           ｜( 'settable greeting for input' )

_VD  run                     ｜( 'Runloop' )
_ID  run _ cmnd              ｜( 'Run command, get result' )

_VD  fmt __Text_ fmt, ...  ｜( '...' )
_VD echo __Text_ fmt, ...  ｜( '...' )

_VD repl                    ｜( '...' )

_AT _Cell cursorLocation    ｜( 'dynamic' )

_TT prompt __Ｐ(Bicolor) string; /*! Read to String */    //- (NSString*) prompt:(NSString*)_ c:(int)c;

_VD   fillScreen __Colr_ colr  ｜( '...' )
_VD       notify __Note_ note  ｜( '...' )
_VD        print __List_ lins  ｜( '...' )
_TT  imageString __ObjC_ iOrP  ｜( 'iterm' )


_VD clearConsole ___    /*! COdes! */

/*! Returns a NSDictionary or nil with embbedded data for the CURRENT executable
    @param s specific SEGMENT with the |section| to get data from
    @param x a SECTION to get data from
    @param e if a parsing error occurs and nil is returned, this is the NSError that occured
 */
//+ _Data_ embeddedDataFromSegment:_Text_ s inSection:_Text_ x error:_Errr__ e;

- _Data_ section:_Text_ __TEXTsection ___

- _SndP_ playerForAudio:dataOrPath ___

- _Void_ justPlay _ path ___

#if MAC_ONLY

_RO _UInt userID            ｜( 'i.e. 501 ' )
_RC _Text user              ｜( 'i.e. localadmin ' )

_VD clearMacConsole         ｜( ' Command-K ' )

_TT preprocess __Text_ text ｜( 'peek-a-boo' )

#endif

// deprecate

_DT infoPlistOf __Text_ path ___
_DT infoPlist ___

#define TK_BUNDLE_EXTENSION @"tkbundle"

_ID runBundleFromStdin;

￭


@Vows _IO <NObj>

_REAL
_VD        help ___

@Reqd

- initWithArgs _ _List_ x ___
@Optn _RO SEL defaultMethod ___ ￭

int  printfc(const char * __restrict, ...) __printflike(1, 2);
int fprintfc(FILE * __restrict, const char * __restrict, ...) __printflike(2, 3);



#define CHAR_FMT(...) [NSString stringWithFormat:@__VA_ARGS__].UTF8String

@Xtra(NObj,IO_Nobj)

_RO _Text stringRep ___

- _Void_ echo ___
- _Void_ print ___
- _Void_ printC _ _Colr_ c ___

//- (P(_IO)) dispatch:(Class<_IO>)k, ... ___

@end

#define $Bx(b) [[$B(b) withFG:b?GREEN:RED]ioString]

// -=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-

#define UNO(INSTNAME) + (INST) INSTNAME { static id uno__; dispatch_uno( uno__ = [self alloc]; uno__ = [uno__ init]; ); return uno__; }
#define PROCINFO [NSProcessInfo processInfo]
#define _Cell_ (_Cell)


int APConsoleLibmain();

/* TODO: Background colors set (in windows just higher numbers, linux escape seq
 * "\033[4nm" where n = 0..7 */

_EnumKind(ConsoleColors,  xBLACK, xDARK_GRAY, xGRAY, xWHITE,
                          xRED,     xLIGHT_RED,   xYELLOW,  xDARK_YELLOW,
                          xGREEN,   xLIGHT_GREEN, xCYAN,    xLIGHT_CYAN,
                          xBLUE,    xLIGHT_BLUE,  xPURPLE, xLIGHT_PURPLE);

#define ＃ (_UInt_ IO.main.argc)  //
#define ﹡ @[]
#define ＄ (_UInt_ AZPROCINFO.processIdentifier) // Process ID (PID) of the script itself.
#define ０ (_Text_ AZPROCINFO.arguments[0])



/*          _____                   _______
           /\    \                 /::\    \        
          /::\    \               /::::\    \       
          \:::\    \             /::::::\    \
           \:::\    \           /::::::::\    \     
            \:::\    \         /:::/~~\:::\    \    
             \:::\    \       /:::/    \:::\    \   
             /::::\    \     /:::/    / \:::\    \  
    ____    /::::::\    \   /:::/____/   \:::\____\ 
   /\   \  /:::/\:::\    \ |:::|    |     |:::|    |
  /::\   \/:::/  \:::\____\|:::|____|     |:::|    |
  \:::\  /:::/    \::/    / \:::\    \   /:::/    / 
   \:::\/:::/    / \/____/   \:::\    \ /:::/    /  
    \::::::/    /             \:::\    /:::/    /   
     \::::/____/               \:::\__/:::/    /    
      \:::\    \                \::::::::/    /     
       \:::\    \                \::::::/    /      
        \:::\    \                \::::/    /       
         \:::\____\                \::/____/        
          \::/    /                 ~~              
           \/____/    
*/

//_RC  _Dict infoPlist      // embdded plist
//___
