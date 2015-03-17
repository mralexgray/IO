
#import <AtoZIO/IO+Protocols.h>

_IFCE AtoZIO : NObj <Subscriptable, AVAudioPlayerDelegate>
                                                                  /*!
  keyget  id x = IO[@"prompt>"] (scan)
  keyset         IO[@"prompt>"] = ^(id z){ [z doSomething]; } (scan w/ block)
  
  idxget  id x = IO[244] (ie @"ANSIESC:244;")
  idxset         IO[244] -> [IO[244] print]                              */

@prop_NC  _ObjC io;         // R/W stream
@prop_RO  _Text $0;         // EXE path
@prop_RO  _Numb $$;         // PID number
@prop_RO  _Size size;       // WIN dims
@prop_RO  _UInt width,
                height;
@prop_RO  _IsIt isatty,
                isxcode;
@prop_RO  _List args,
                stdinlines;

@prop_RO int   * argc;
@prop_RO char*** argv;

typedef struct { int argc; char ** argv; } IOMain;

@prop_RC  _Text scan, resetFX;
@prop_RO  _Dict infoPlist;
@prop_NA  _Text prompt;

_Type struct { _UInt col;
               _UInt row; } _Cell;


@prop_ _Cell cursorLocation; /// dynamic

- _Text_       prompt:(id<Bicolor>)_; /*! Read to String */    //- (NSString*) prompt:(NSString*)_ c:(int)c;
- _Void_   fillScreen: _Colr_ c;
- _Void_       notify: _Note_ _;
- _Void_        print: _List_ lines;
- _Text_  imageString: _Text_ path; // iterm

- _Void_ clearConsole; /*! Command-K */

/*! Returns a NSDictionary or nil with embbedded data for the CURRENT executable
    @param s specific SEGMENT with the |section| to get data from
    @param x a SECTION to get data from
    @param e if a parsing error occurs and nil is returned, this is the NSError that occured
 */
+ _Data_ embeddedDataFromSegment:_Text_ s inSection:_Text_ x error:_Errr__ e;

- (AVAudioPlayer*) playerForAudio:dataOrPath;

- _Void_ justPlay:path;

@end



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

@prop_RO _Text stringRep;

- _Void_ echo;
- _Void_ print;
- _Void_ printC:_Colr_ _;

+ (INST) _IO;
@end

#define $Bx(b) [[$B(b) withFG:b?GREEN:RED]x]


#define IO ((AtoZIO*)[AtoZIO _IO]) // -=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-=/><\=-

#define UNO(INSTNAME) \
  + (INST) INSTNAME { static id uno__; dispatch_uno( uno__ = [self alloc]; [uno__ init]; ); return uno__; }

#define PROCINFO NSProcessInfo.processInfo
#define _Cell_ (_Cell)


