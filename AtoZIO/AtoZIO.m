
#import "IO_.h"
#import "scrutil.h"
#import <termios.h>

#import <AVFoundation/AVAudioPlayer.h>

@import SystemConfiguration;
#if MAC__ONLY
#endif

JREnumDefine(ConsoleColors);

@Plan AtoZIO { P(_IO) runner; AVAudioPlayer *playa; } UNO(io); // AVAudioPlayerDelegate

_TT preprocess __Text_ t {

  NTBTask * task = [NTBTask.alloc initWithLaunchPath: @"/usr/bin/clang"];

  task.arguments = @[ @"-w",
                      @"-std=c11",
                      @"-fmodules",
                      @"-framework", @"AtoZ",
                      @"-F/Users/localadmin/Library/Frameworks",
                      @"-E",
                      @"-x", @"objective-c",
                      @"-"];

  [task writeAndCloseInput:t]; return [[task waitForOutputString] copy];
  //  id output = ; //@"".mC;  while ([task isRunning]) [output appendString:] return [output copy];
}

@synthesize user = _user, userID = _userID, env = _env; @dynamic hideCursor, cursorLocation;

#pragma mark - Console

_VD setTitle:(_Text)title { printf("\033]0;%s\007", [_title = title UTF8String]); }

#pragma mark - Commandline

_VD repl {

  id class = [self prompt:@"Create instance of class:"];
  Class k = NSClassFromString(class);
  if (!k) return [$(@"can't create class \"%@\"!", k) echo];
  id method = [self prompt:@"Via method:"];
  id x = [(id)k performString:method];
  id act = [self prompt:@"No what:"];
  id res = [x performString:act];

  [res echo];

}

- forwardingTargetForSelector __Meth_ s {

  return [IOOpts.shared respondsToSelector:s] ? IOOpts.shared : [super forwardingTargetForSelector:s];
}

- (P(_IO)) dispatch:(Class<_IO>)k,... { SEL def = NULL;

  runner = [k.alloc init]; va_list args; va_start(args, k); def = va_arg(args, SEL); va_end(args);

  if (!def && [runner respondsToSelector:@selector(defaultMethod)]) def = runner.defaultMethod ___

//  if (def && [runner respondsToSelector:def])
  return runner;
}

#if MAC_ONLY

/* Adapted from QA1133:http://developer.apple.com/mac/library/qa/qa2001/qa1133.html */

_VD _FetchUserInfo { dispatch_uno( uid_t _uid;

    SCDynamicStoreRef store = SCDynamicStoreCreate(NULL, CFSTR("GetConsoleUser"), NULL, NULL);
    NSAssert(store, @"oops");
    _user = (__bridge NSS*)SCDynamicStoreCopyConsoleUser(store, &_uid, NULL);
    _userID = _uid;
  );
}

_UT userID { return [self _FetchUserInfo], _userID; }
_TT user   { return [self _FetchUserInfo], _user;   }

#endif

- (_Char**) argv  { return          _NSGetArgv(); }
- ( _SInt*) argc  { return (_SInt*) _NSGetArgc(); }

- (ioEnv) env  { dispatch_uno(

  if(isatty(STDERR_FILENO)) _env |= io_TTY;

  if ([[self run:$(@"ps -p %@",

      [self run:$(@"ps -xc -o ppid= -p %lu",＄)])] containsString:@"Xcode"]) _env |= io_XCODE;

  if ([_PI.environment.allKeys any:^BOOL(id o) { return [o caseInsensitiveContainsString:@"XcodeColors"]; }] ||

      [_PI.environment[@"TERM"] containsAnyOf:@[@"ANSI", @"ansi", @"color", @"256"]]) _env |= io_COLOR

  ); return _env;
}


- _Void_ clearConsole           { puts("\e[2J"); }

- _Void_ setHideCursor:_IsIt_ b { printf("\e[?25%c", b ? 'h' : 'l'); }

- _Rect_ frame { struct winsize ws; ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws);

  return ws.ws_col ? _Rect_ {0,0,ws.ws_col ?: 100, ws.ws_row?: 80} :

  ({ id r = _PI.environment[@"ROWS"], c = _PI.environment[@"COLUMNS"];
    _Rect_ {0,0,r ? [r fV] : 66, c ? [c fV] : 11 };
  });
}
//- _Size_ pixels { return _Size_ {_Flot_ self.ws.ws_xpixel, _Flot_ ws.ws_ypixel}; }

- _Void_ run { AZRUNFOREVER; }

- _ObjC_ run:_ObjC_ commandToRun { NSString* outP;

#if TARGET_OS_IPHONE
  char buffer[BUFSIZ + 1];
  memset(buffer, '\0', sizeof(buffer));
  FILE *read_fp = popen([commandToRun UTF8String], "r");
  if (read_fp == NULL) return @"";
  size_t chars_read = fread(buffer, sizeof(char), BUFSIZ, read_fp);
  outP = chars_read ? $UTF8(buffer) : @"";
  pclose(read_fp);
#else
  NSTask *t    = NSTask.new;
  t.launchPath = @"/bin/sh";
  t.arguments  = @[@"-c", commandToRun];
  NSPipe *p; t.standardOutput = (p = NSPipe.pipe);
  NSFileHandle *file = p.fileHandleForReading; [t launch];
  outP = file.readDataToEndOfFile.UTF8String;
#endif
  return outP;
}

- _Void_ setObject:_ObjC_ x forKeyedSubscript:_Copy_ k {

  (_ObjBlk_ x)([self prompt:_ObjC_ k])___ /*  ISA(k,Text) ? [k echo] : [_List_ k */
}

- _Void_ setStream:(_ObjC)io { [io print]___ }

- _ObjC_    stream { return [self scan]___ }

- _Text_ prompt:_Text_ t { return [self prompt:t c:7]___ } /* OK */

- _Text_ prompt:_Text_ t c:_SInt_ c { t.fclr = @(c)___ [t print]___

  return NSFileHandle.fileHandleWithStandardInput.availableData.UTF8String ___
}

- _Void_ setCursorLocation: _Cell_ c { printf("%s%ld;%ldH", CSI, c.row + 1, c.col + 1); }

#if MAC_ONLY
- _Void_ clearMacConsole {

  NSAppleScript *s = INIT_(NSAppleScript,WithSource:@"tell application \"System Events\" to keystroke \"k\" using command down");
  NSDictionary *err; NSAppleEventDescriptor * x = [s executeAndReturnError:&err];
  if (err || (x && x.stringValue)) NSLog(@"err:%@ event:%@",err, x.stringValue);

} /* OK */
#endif

- _List_ args { return [_PI.arguments subarrayWithRange:(NSRange){1,_PI.arguments.count-1}]; } //  subarrayFromIndex:1]; } // .shifted; } /* OK */

- _Data_ section:_Text_ __TEXTsection { return [DDEmbeddedDataReader embeddedDataFromSection:__TEXTsection error:nil]; }

+ _Dict_ infoPlist: _Text_ path { return [DDEmbeddedDataReader defaultPlistOfExecutableAtPath:path error:nil]; }

- _Dict_ infoPlist { return [DDEmbeddedDataReader defaultEmbeddedPlist:nil]; }

- (AVAudioPlayer*) playerForAudio: dataOrPath { // lets create an audio player to play the audio.

  NSError *e = nil; AVAudioPlayer *player =

  ISA(dataOrPath, Data) ? INIT_(AVAudioPlayer,WithData:dataOrPath error:&e) :
  ISA(dataOrPath,NSURL)||
  ISA(dataOrPath, Text) ? INIT_(AVAudioPlayer,WithContentsOfURL:ISA(dataOrPath,NSURL) ? dataOrPath : [dataOrPath urlified] error:&e)
                        : nil;

  return (!player || e) ? NSLog(@"problem making player: %@", e), player
                        : [player setNumberOfLoops:0], [player setDelegate:_ObjC_ self], [player prepareToPlay], player;
}

- _Void_ justPlay:path { playa = nil; [playa = [self playerForAudio:path] play]; /* CFRunLoopRun(); */ }

- _Void_ audioPlayerDidFinishPlaying:(AVAudioPlayer*)p successfully:_IsIt_ s {

  NSLog(@"finished playing");
//  CFRunLoopStop(CFRunLoopGetMain());
}

- _Text_ scan {

//  unichar left = NSLeftArrowFunctionKey;


  return [Text.alloc initWithData:NSFileHandle.fileHandleWithStandardInput.availableData encoding:NSUTF8StringEncoding];
}

- _Void_ fillScreen: _Colr_ c { id line = $(@"%*s",@(IO.w).charValue," ");

  [line setBclr:c];

  int h = IO.h; while (h--) [line echo];
}

- _Void_ notify:_Note_ note {  static IONotifier *ntfr; ntfr = ntfr ?: INIT_(IONotifier,WithNotification:note); }

_VD echo _ _Text_ fmt, ... { va_list args; va_start(args, fmt);

  [[Text.alloc initWithFormat:fmt arguments:args] echo]; //  def = va_arg(args, SEL);
  va_end(args);
}
_VD print:_List_ lines {

  [[lines reduce:@"".mC withBlock:^id(id sum, id obj) { return

    [sum appendString: ISA(obj,Text) ? $(@"%@%@%@",(_Text_ obj).ioString, [self resetFX], zNL)
                     : ISA(obj,Colr) ? [[obj bgEsc]    withString:IO.env&io_XCODE ? @"" : @"m"]  : @""], sum;
  }] print];
}

- _Text_ resetFX { AZSTATIC_OBJ(Text, r, ({ IO.env&io_XCODE ? $UTF8(XC_RESET) : $UTF8(ANSI_RESET); })); return r; }

_VD fill __Rect_ r color __ObjC_ c { }

_TT imageString __ObjC_ pathOrImage { _Pict image; _Text name, x;

  ISA(pathOrImage,Pict) ? ({ image = pathOrImage; name = [ _Pict_ pathOrImage name] ?: @"N/A"; })
                        : ({

    image = [FM fileExistsAtPath:pathOrImage] ? [NSImage.alloc initWithContentsOfFile:pathOrImage] : nil;
    name = pathOrImage;
  });

#if MAC_ONLY
    _Rect r = NSScreen.mainScreen.frame;
    CGFloat multi = MAX(image.size.width, r.size.width / 2.) / image.size.width;
    [image setSize:AZScaleSize(image.size, multi)];
    x = [image.TIFFRepresentation base64EncodedStringWithOptions:0];

#else
//    id s = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    x = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
#endif

  return $(@"\033]1337;File=name=%@;inline=1:%@\a\n",name.UTF8Data.base64EncodedString,image);//[Data dataWithContentsOfFile:path].base64EncodedString);
}
￭

///  \033]1337;File=name=" stringByAppendingFormat:@"%@;inline=1;%@\a\n",path.UTF8Data.base64EncodedString,
// CGSizeMake(image.size.width * multi, image.size.height * multi)];
//    [[ -n "$1" ]] && printf "name=$(echo -n $1 | base64)"
//    $(base64 --version | grep GNU > /dev/null) && BASE64ARG=-d || BASE64ARG=-D
//    echo -n "$3" | base64 $BASE64ARG | wc -c | awk '{printf "size=%d",$1}' && printf ";inline=$2:$3\a\n"
//[[   ! -t 0 ]] && print_image "" 1 "$(cat | base64)" && exit 0
//[[ $# -eq 0 ]] && printf  "Usage: imgcat filename ...\n   or: cat filename | imgcat\n" && exit 1
//for fn in "$@"; do
//  [[ -r "$fn" ]] && print_image "$fn" 1 "$(base64 < "$fn")" || printf "imgcat: $fn: No such file or directory\n" && exit 1

//#endif
//- _Void_ colorTest { for (int i = 0; i <256; i++) { [Text stringWithFormat:@"%]


//- _List_ － { return @[] ___ }
//- _List_ ﹫ { return @[] ___ }
//- _SInt_ ﹖ { return 0   ___ }

//- _UInt_ width    { return self.size.width;   }
//- _UInt_ height   { return self.size.height;  }
//- (struct winsize) _winsize { nterm = nterm ?: getenv("TERM");
//
//  ioctl(0, TIOCGWINSZ, &w);
////  (strcpy(term, nterm), , _Size_{ w.ws_col, w.ws_row})
//  return w;/// = !nterm ? _Size_{ 80, 30}
//
//- _Size_ size     {
//
//}
//@prop_RO  _Size size;       // WIN dims
                         // if (!value && self.ftty) [self setFclr:value = [NSColor fromTTY: self.ftty]]; },
                         // if (!value && self.btty) [self setBclr:value = [NSColor fromTTY: self.btty]]; },


//- _List_ ﹡ { return @[] _ }
//- _UInt_ ﹗ { return 0   _ }
//- _UInt_ ＃ { return 0   _ }

//char term[1024] = {'a','n','s','i', 0};  /* The default terminal is ANSI */

//#define GOT_TO printf("got to %i\n", __LINE__)


//- (struct winsize) ws { // int fd;

//  return ((fd = open("/dev/tty",O_WRONLY)) < 0) ? ws : ({ ioctl(fd,TIOCGWINSZ,&ws); close(fd); ws; });




int getch(void) {

	static int ch = -1, fd = 0;
	struct termios neu, alt;
	fd = fileno(stdin);
	tcgetattr(fd, &alt);
	neu = alt;
	neu.c_lflag &= ~(ICANON | ECHO);
	tcsetattr(fd, TCSANOW, &neu);
	ch = getchar();
	tcsetattr(fd, TCSANOW, &alt);
	return ch;
}

int kbhit(void) {
	struct termios term, oterm;
	int fd = 0;
	int c = 0;
	tcgetattr(fd, &oterm);
	memcpy(&term, &oterm, sizeof (term));
	term.c_lflag = term.c_lflag & (!ICANON);
	term.c_cc[VMIN] = 0;
	term.c_cc[VTIME] = 1;
	tcsetattr(fd, TCSANOW, &term);
	c = getchar();
	tcsetattr(fd, TCSANOW, &oterm);
	if (c != -1)
		ungetc(c, stdin);
	return ((c != -1) ? 1 : 0);
}

void clearConsole(void) {
	/*char a[80];*/
	printf("\033[2J"); /* Clear the entire screen.		*/
	printf("\033[0;0f"); /* Move cursor to the top left hand corner */
}

void consoleGotoXY(short x, short y) { printf("\033[%i;%if", y, x); }

void setConsoleColor(ConsoleColors clr)  {

  const char * c =
    clr == xBLACK ? "0;30m" :       clr == xRED ? "0;31m" :  clr == xGREEN ? "0;32m" :
    clr == xDARK_YELLOW ? "0;33m" : clr == xBLUE ? "0;34m" :      clr == xPURPLE ? "0;35m" :
    clr == xCYAN ? "0;36m" :        clr == xGRAY ? "0;37m" :      clr == xDARK_GRAY ? "1;30m" :
	clr == xLIGHT_RED ? "1;31m" :   clr == xLIGHT_GREEN ? "1;32m" : clr == xYELLOW ? "1;33m" :
	clr == xLIGHT_BLUE ? "1;34m" :   clr == xLIGHT_PURPLE ? "1;35m" : clr == xLIGHT_CYAN ? "1;36m" :
	clr == xWHITE ? "1;37m" : ""; printf("\033[%s",c);
}

void setConsoleSize(short xsize, short ysize)   {
	char rcmd[32];
	sprintf(rcmd, "resize -s %i %i > /dev/null", ysize, xsize);
	system(rcmd);
}

void getConsoleSize(short *xsize, short *ysize) {
	FILE *pipe = popen("stty size", "r");
	fscanf(pipe, "%hi%hi", ysize, xsize);
	pclose(pipe);
}


int APConsoleLibmain()
{
	int i;
	short xsize;
	short ysize;
	char *text = "HelloworldABCDEF";
	char key = 0;

	IO.title = @"Console Lib Test";
  IO.size = _Size_ {50, 15};
//	setConsoleSize(50, 15);
	clearConsole();

	for (i = 0; i < 16; i++) {
		setConsoleColor(i);
		printf("%c", text[i]);
	}

	getConsoleSize(&xsize, &ysize);
	consoleGotoXY(10, 10);
	printf("Terminal size:%ix%i\n", xsize, ysize);

	while (key != 'q') {
		key = 0;
		if (kbhit())
			key = getch();
		if (key != 'q' && key != 0) {
			consoleGotoXY(10, 10);
			printf("You pressed: %c (%i)\n", key, key);
		}
	}

	printf("Input: ");
	int ix;
	scanf("%i", &ix);
	return 0;
}
