
//#import <FunSize/FunSize.h>
@import AtoZUinversal
#import <ToolKit/TK+Protocols.h> // Public interfaces of ancillary features.


@Kind (ToolKit) < RectLike,
                  Subscriptable,
                  IO_Opts
                >

_RO  _Main main ___             // access to argc + argv, anywhere
_RO  ioEnv  env ___             // where we runnin at'

_NC ＾SInt signalHandler ___

#if MAC_ONLY
_RO  _UInt userID       ｜( i.e. 501                                   )
_RC  _Text user         ｜( i.e. localadmin                            )
#endif

_RO  _List args           // JUST the args, maam'
__         stdinlines     // readline?'
___
_NC  _ObjC stream         // stdin + stdout'
___

_TT preprocess __Text_ t ___

_AT  _IsIt hideCursor   ｜( peek-a-boo                                 )

_NA  _Text title        ｜( console window title                       )


_RC  _Text scan
__         resetFX      ｜( 'needs doc'                                )

_NA  _Text prompt       ｜( 'settable greeting for input' )


_VD run       ___  // Runloop
_ID run _ cmd ___  // Run command, get result.


_VD echo __Text_ fmt, ... ___

_VD repl ___

_AT _Cell cursorLocation ___ /// dynamic

_TT prompt __Ｐ(Bicolor) string; /*! Read to String */    //- (NSString*) prompt:(NSString*)_ c:(int)c;

_VD   fillScreen __Colr_ colr ___
_VD       notify __Note_ note ___
_VD        print __List_ lins ___
_TT  imageString __ObjC_ iOrP ___  // iterm


#if MAC_ONLY
- _Void_ clearMacConsole; /*! Command-K */
#endif

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

#define IO ((ToolKit*)[ToolKit shared])

// deprecate

_DT infoPlistOf __Text_ path ___
_DT infoPlist ___

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

@interface NSO (IO_Nobj)

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
