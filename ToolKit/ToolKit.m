
#import "ToolKit.h"
#import "TK_Private.h"
#import "scrutil.h"
// #import <termios.h>
#import <sys/termios.h>

@import AVFoundation.AVAudioPlayer;
#if MAC_ONLY
@import SystemConfiguration;
#endif

_EnumPlan(ConsoleColors)

@Plan ToolKit { Ｐ(_IO) runner; AVAudioPlayer *playa; } UNO(sharedToolKit); // AVAudioPlayerDelegate

_TT description {

  return $(@"ToolKit v.%@  isatty:%@ isxcode:%@ color:%@ user:%@ id:%lu",  [[Bndl bundleForClass:ToolKit.class].version[RED] ioString],
                                                                      [$B(IO.env&io_TTY)[YELLOW] ioString],
                                                                      [$B(IO.env&io_XCODE)[GREEN] ioString],
                                                                      [$B(IO.env&io_COLOR)[BLUE] ioString],
                                                                      [IO.user[ORANGE] ioString],
                                                                      IO.userID);
}
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

_VD setTitle:(_Text)title { printf("\033]0;%s\007",(_title = title).UTF8String); }

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

  return [_IO_Opts.shared respondsToSelector:s] ? _IO_Opts.shared : [super forwardingTargetForSelector:s];
}

- _Ｐ(_IO) dispatch:(Class<_IO>)k,... { SEL def = NULL;

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

    _user = (__bridge _Text)SCDynamicStoreCopyConsoleUser(store, &_uid, NULL);
    _userID = _uid;
  );
}

_UT userID { return [self _FetchUserInfo], _userID;     }
_TT user   { return [self _FetchUserInfo], _user.copy;  }

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
  outP = file.readDataToEndOfFile.toUTF8String;
#endif
  return outP;
}

_VD setObject _ x forKeyedSubscript __Ｐ(Copy) k {

  (_ObjBlk_ x)([self prompt __ObjC_ k])___ /*  ISA(k,Text) ? [k echo] : [_List_ k */
}

_VD setStream __ObjC_ io {

  [io print]___
}

_ID stream {

  return [self scan]___
}

_TT prompt __Text_ t {

  return [self prompt _ t c _ 7]___

} /* OK */

_TT prompt __Text_ t c __SInt_ c {

  t.fclr = @(c);
  [t print];

  return NSFileHandle.fileHandleWithStandardInput.availableData.toUTF8String ___
}

_VD setCursorLocation _ _Cell_ c {

  printf("%s%ld;%ldH", CSI, c.row + 1, c.col + 1);
}

#if MAC_ONLY
_VD clearMacConsole {

  _Scpt s = INIT_(Scpt,WithSource:@"tell application \"System Events\" to keystroke \"k\" using command down");
  _Dict err; _AEvD x = [s executeAndReturnError:&err];
  if (err || (x && x.stringValue)) NSLog(@"err:%@ event:%@",err, x.stringValue);

} /* OK */
#endif

_LT args {

  return [_PI.arguments subarrayWithRange:(NSRange){1,_PI.arguments.count-1}];
} //  subarrayFromIndex:1]; } // .shifted; } /* OK */

_DA section __Text_ __TEXTsection {

  return [DDEmbeddedDataReader embeddedDataFromSection:__TEXTsection error:nil];
}

_DT infoPlistOf __Text_ path {

  return [DDEmbeddedDataReader defaultPlistOfExecutableAtPath:path error:nil];
}

_DT infoPlist {

  return [DDEmbeddedDataReader defaultEmbeddedPlist:nil];
}

_SP playerForAudio _ dataOrPath { // lets create an audio player to play the audio.

  _Errr e = nil; _SndP player =

  ISA(dataOrPath, Data) ? INIT_(SndP,WithData:dataOrPath error:&e) :
  ISA(dataOrPath,NSURL)||
  ISA(dataOrPath, Text) ? INIT_(SndP,WithContentsOfURL:ISA(dataOrPath,NSURL) ? dataOrPath : [dataOrPath urlified] error:&e)
                        : nil;

  return (!player || e) ? NSLog(@"problem making player: %@", e), player
                        : [player setNumberOfLoops:0], [player setDelegate:_ObjC_ self], [player prepareToPlay], player;
}

_VD justPlay _ path {

  playa = nil; [playa = [self playerForAudio:path] play]; /* CFRunLoopRun(); */
}

_VD audioPlayerDidFinishPlaying __SndP_ p successfully __IsIt_ s {

  NSLog(@"finished playing %@ success:%@", p, $B(s)); //  CFRunLoopStop(CFRunLoopGetMain());
}

_TT scan {

//  unichar left = NSLeftArrowFunctionKey;


  return [Text.alloc initWithData:NSFileHandle.fileHandleWithStandardInput.availableData encoding:NSUTF8StringEncoding];
}

_VD fillScreen __Colr_ c { id line = $(@"%*s",@(IO.w).charValue," ");

  [line setBclr:c];

  int h = IO.h; while (h--) [line echo];
}

_VD     notify __Note_ n {

  static IONotifier *ntfr; ntfr = ntfr ?: INIT_(IONotifier,WithNotification:n);
}

_VD  echo __Text_ fmt, ... {

  va_list args; va_start(args, fmt);

  [[Text.alloc initWithFormat:fmt arguments:args] echo]; //  def = va_arg(args, SEL);

  va_end(args);
}
_VD print __List_ lines   {

  [[lines reduce:@"".mC withBlock:^id(id sum, id obj) { return

    [sum appendString: ISA(obj,Text) ? $(@"%@%@%@",(_Text_ obj).ioString, [self resetFX], zNL)
                     : ISA(obj,Colr) ? [[obj bgEsc]    withString:IO.env&io_XCODE ? @"" : @"m"]  : @""], sum;
  }] print];
}

_TT resetFX { AZSTATIC_OBJ(Text, r, ({ IO.env&io_XCODE ? $UTF8(XC_RESET) : $UTF8(ANSI_RESET); }));

  return r;
}

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

int APConsoleLibmain() {
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
