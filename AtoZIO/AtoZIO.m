
#import "_IO.h"


@Plan AtoZIO { AVAudioPlayer *playa; } UNO(_IO); // AVAudioPlayerDelegate

@synthesize isxcode = _isxcode; @dynamic hideCursor, io, cursorLocation;

+ _Void_ load {   [$(@"isatty:%@ isxcode:%@\n", $B(IO.isatty), $B(IO.isxcode)) printC:RANDOMCOLOR]; }

- _List_ － { return @[] _ }
- _List_ ﹫ { return @[] _ }
- _SInt_ ﹖ { return 0   _ }

- (_Char**) argv  { return          _NSGetArgv(); }
- ( _SInt*) argc  { return (_SInt*) _NSGetArgc(); }

- _Text_ ０       { return   PROCINFO.arguments[0];       } /*$0*/
- _Numb_ ＄       { return @(PROCINFO.processIdentifier); } /*$$*/
- _IsIt_ isatty   { return @(isatty(STDERR_FILENO)).bV;   }
- _IsIt_ isxcode  { return dispatch_uno(  _isxcode  =

  [[self run:$(@"ps -p %@",[self run:$(@"ps -xc -o ppid= -p %@", IO.＄)])] containsString:@"Xcode"];

  ), _isxcode;
}
- _Void_ clearConsole           { puts("\e[2J"); }
- _Void_ setHideCursor:_IsIt_ b { printf("\e[?25%c", b ? 'h' : 'l'); }

- _Rect_ frame { struct winsize ws;

  ioctl(STDOUT_FILENO, TIOCSWINSZ, &ws); return _Rect_ {0,0,ws.ws_col, ws.ws_row};
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

- _Void_ setObject:_ObjC_ x forKeyedSubscript:_Copy_ k { (_ObjBlk_ x)([self prompt:_ObjC_ k]) _ /*  ISA(k,Text) ? [k echo] : [_List_ k */ }

- _Void_ setIo:_ObjC_ io { [io print] _ }

- _ObjC_              io { return [self scan] _ }

- _Text_ prompt:_Text_ t { return [self prompt:t c:7] _ } /* OK */

- _Text_ prompt:_Text_ t c:_SInt_ c { t.fclr = @(c)_ [t print]_

  return NSFileHandle.fileHandleWithStandardInput.availableData.UTF8String _
}

- _Void_ setCursorLocation: _Cell_ c { printf("%s%ld;%ldH", CSI, c.row + 1, c.col + 1); }

#if MAC_ONLY
- _Void_ clearMacConsole {

  NSAppleScript *s = INIT_(NSAppleScript,WithSource:@"tell application \"System Events\" to keystroke \"k\" using command down");
  NSDictionary *err; NSAppleEventDescriptor * x = [s executeAndReturnError:&err];
  if (err || (x && x.stringValue)) NSLog(@"err:%@ event:%@",err, x.stringValue);

} /* OK */
#endif

- _List_ args { return NSProcessInfo.processInfo.arguments.shifted; } /* OK */

- _Data_ section:_Text_ __TEXTsection { return [DDEmbeddedDataReader embeddedDataFromSection:__TEXTsection error:nil];
}

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

  return [Text.alloc initWithData:NSFileHandle.fileHandleWithStandardInput.availableData encoding:NSUTF8StringEncoding]; }

- _Void_ fillScreen: _Colr_ c { id line = $(@"%*s",@(IO.w).charValue," ");

  [line setBclr:c];

  int h = IO.h; while (h--) [line echo];
}

- _Void_ notify:_Note_ note {  static IONotifier *ntfr; ntfr = ntfr ?: INIT_(IONotifier,WithNotification:note); }

- _Void_ print:_List_ lines {

  [[lines reduce:@"".mC withBlock:^id(id sum, id obj) { return

    [sum appendString: ISA(obj,Text) ? $(@"%@%@%@",(_Text_ obj).x, [self resetFX], zNL)
                     : ISA(obj,Colr) ? [[obj bgEsc]    withString:self.isxcode ? @"" : @"m"]  : @""], sum;
  }] print];
}

- _Text_ resetFX { AZSTATIC_OBJ(Text, r, ({ self.isxcode ? $UTF8(XCODE_RESET) : $UTF8(ANSI_RESET); })); return r; }

- _Void_ fill:_Rect_ r color:_ObjC_ c {

}

- _Text_ imageString:_ObjC_ pathOrImage { _Pict image; _Text name, x;

  ISA(pathOrImage,Pict) ? ({ image = pathOrImage; name = [pathOrImage name] ?: @"N/A"; })
                        : ({

    image = [FM fileExistsAtPath:pathOrImage] ? [NSImage.alloc initWithContentsOfFile:pathOrImage] : nil;
    name = pathOrImage;
  });

#if MAC_ONLY
                                    //([NSScreen.mainScreen vFK:@"bounds"]?:
    _Rect r = [[NSScreen.mainScreen vFK:@"frame"] rV];

    CGFloat multi = MAX(image.size.width, r.size.width / 2.) / image.size.width;
    [image setSize:AZScaleSize(image.size, multi)];
    x = [image.TIFFRepresentation base64EncodedStringWithOptions:0];

#else
//    id s = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    x = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
#endif

  return $(@"\033]1337;File=name=%@;inline=1:%@\a\n",name.UTF8Data.base64EncodedString,image);//[Data dataWithContentsOfFile:path].base64EncodedString);

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
}
//- _Void_ colorTest { for (int i = 0; i <256; i++) { [Text stringWithFormat:@"%]
￭



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
