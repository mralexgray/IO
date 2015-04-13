//￤

#import <AtoZIO/IO+Protocols.h>

@Kind (AtoZIO) <RectLike, Subscriptable, IOOpts>


_RO  _Main main         // argc + argv
___
_RC  _Dict infoPlist    // embdded plist | long/short opts, parsed
___
_RO  ioEnv env          // where we runnin at'
___
_RO  _List args         // JUST the args, maam'
__         stdinlines   // readline?'
___
_NC  _ObjC stream           // stdin + stdout'
___

_TT preprocess __Text_ t ___

_AT  _IsIt hideCursor   ｜( peek-a-boo                                 )

_NA  _Text title        ｜( console window title                       )

#if MAC_ONLY
_RO  _UInt userID       ｜( i.e. 501                                   )
_RC  _Text user         ｜( i.e. localadmin                            )
#endif

_RC  _Text scan
__         resetFX      ｜( 'needs doc'                                )

_NA  _Text prompt       ｜( 'settable greeting for input' )


_VD run       ___  // Runloop
-   run _ cmd ___  // Run command, get result.


_VD echo _ _Text_ fmt, ... ___

_VD repl ___

_P _Cell cursorLocation; /// dynamic

- _Text_       prompt:(id<Bicolor>)string; /*! Read to String */    //- (NSString*) prompt:(NSString*)_ c:(int)c;

_VD   fillScreen __Colr_ colr ___
_VD       notify __Note_ note ___
_VD        print __List_ lins ___
_TT  imageString __ObjC_ iOrP ___  // iterm


#if MAC_ONLY
- _Void_ clearMacConsole; /*! Command-K */
#endif

- _Void_ clearConsole;    /*! COdes! */

/*! Returns a NSDictionary or nil with embbedded data for the CURRENT executable
    @param s specific SEGMENT with the |section| to get data from
    @param x a SECTION to get data from
    @param e if a parsing error occurs and nil is returned, this is the NSError that occured
 */
//+ _Data_ embeddedDataFromSegment:_Text_ s inSection:_Text_ x error:_Errr__ e;

- _Data_ section:_Text_ __TEXTsection ___

- _SndP_ playerForAudio:dataOrPath ___

- _Void_ justPlay _ path ___

#define IO ((AtoZIO*)[AtoZIO io])
+ _Kind_ io ___

// deprecate

+ _Dict_ infoPlist __Text_ path ___

@end


@Vows _IO <NObj>

_REAL
_VD        help ___

@Reqd

- initWithArgs _ _List_ x ___
@Optn _RO SEL defaultMethod ___ ￭

int  printfc(const char * __restrict, ...) __printflike(1, 2);
int fprintfc(FILE * __restrict, const char * __restrict, ...) __printflike(2, 3);


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



@interface NSO (AtoZIO) 

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

JREnumDeclare(ConsoleColors,  xBLACK, xDARK_GRAY, xGRAY, xWHITE,
                              xRED,     xLIGHT_RED,   xYELLOW,  xDARK_YELLOW,
                              xGREEN,   xLIGHT_GREEN, xCYAN,    xLIGHT_CYAN,
                              xBLUE,    xLIGHT_BLUE,  xPURPLE, xLIGHT_PURPLE);

//- _UInt_ ﹗ _              // PID (process ID) of last job run in background
//- _UInt_ ＃ _              // argc
//- _List_ ﹫ _              // whoknows, lets make this LINES
//- _List_ ﹡ _              // whoknows, i'm making this an array of word params
//- _List_ － _              // flags?  lets make it something better
//- _SInt_ ﹖ _              // Exit status of a command, function, or the script itself
//- _Text_ ０ _              // EXE path
//- _Numb_ ＄ _              // Process ID (PID) of the script itself.


#define ＃ (_UInt_ IO.main.argc)  //
#define ﹡ @[]
#define ＄ (_UInt_ AZPROCINFO.processIdentifier) // Process ID (PID) of the script itself.
#define ０ (_Text_ AZPROCINFO.arguments[0])

//#define ﹗ (_UInt_ AZPROCINFO.processIdentifier) // like $!, pid of last job run in background
//- _UInt_  _                // argc
//- _List_ ﹫ _              // whoknows, lets make this LINES
//- _List_ ﹡ _              // whoknows, i'm making this an array of word params
//- _List_ － ___              // flags?  lets make it something better
//- _SInt_ ﹖ ___              // Exit status of a command, function, or the script itself
//- _Text_ ０ _              // EXE path
                                                                       /*
  keyget  id x = IO[@"prompt>"] (scan)
  keyset         IO[@"prompt>"] = ^(id z){ [z doSomething]; } (scan w/ block)

  idxget  id x = IO[244] (ie @"ANSIESC:244;")
  idxset         IO[244] -> [IO[244] print]                              */

//_RO  _UInt rows,
//           cols       ___
//_RO  _Size size,           // WIN dims
//           pixels     _    // WIN dims


/*    ___                       ___           ___
     /  /\          ___        /  /\         /  /\
    /  /::\        /  /\      /  /::\       /  /::|   
   /  /:/\:\      /  /:/     /  /:/\:\     /  /:/:|   
  /  /:/~/::\    /  /:/     /  /:/  \:\   /  /:/|:|__ 
 /__/:/ /:/\:\  /  /::\    /__/:/ \__\:\ /__/:/ |:| /\
 \  \:\/:/__\/ /__/:/\:\   \  \:\ /  /:/ \__\/  |:|/:/
  \  \::/      \__\/  \:\   \  \:\  /:/      |  |:/:/ 
   \  \:\           \  \:\   \  \:\/:/       |  |::/  
    \  \:\           \__\/    \  \::/        |  |:/   
     \__\/                     \__\/         |__|/

            _____                   _______         
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


//_RO  _IsIt isatty       ￤('nothing will happen')
//        __ isxcode      ｜( 'Where we at?' )
