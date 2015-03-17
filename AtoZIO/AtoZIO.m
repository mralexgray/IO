
#import "_IO.h"


char term[1024] = {'a','n','s','i', 0};  /* The default terminal is ANSI */

#define GOT_TO printf("got to %i\n", __LINE__)

_IMPL AtoZIO @synthesize isxcode = _isxcode; @dynamic io, cursorLocation;   UNO(_IO);


- (char ***) argv { return _NSGetArgv(); }
- (int*) argc     { return _NSGetArgc(); }
- _Text_ $0       { return   PROCINFO.arguments[0];       }
- _Numb_ $$       { return @(PROCINFO.processIdentifier); }
- _IsIt_ isatty   { return @(isatty(STDERR_FILENO)).bV;   }
- _IsIt_ isxcode  { return dispatch_uno(  _isxcode  =

  [IOrun($(@"ps -p %@",IOrun($(@"ps -xc -o ppid= -p %@", IO.$$)))) containsString:@"Xcode"];

  ), _isxcode;
}
- _UInt_ width    { return self.size.width;   }
- _UInt_ height   { return self.size.height;  }
- _Size_ size     { char * nterm; struct winsize w;

  return !(nterm = getenv("TERM")) ? _Size_{ 80, 30}
                : (strcpy(term, nterm),
                    ioctl(0, TIOCGWINSZ, &w), _Size_{ w.ws_col, w.ws_row});
}

- _Void_ setObject:_ObjC_ _ forKeyedSubscript: _Copy_ k {

//  ISA(k,Text) ? [k echo] : [_List_ k
    ((ObjBlk)_)([self prompt:(id) k]);
}

- _Void_ setIo:(_ObjC)io { [io print]; }
- _ObjC_ io { return [self scan]; }

- _Text_ prompt: _Text_ _ { return [self prompt:_ c:7]; } /* OK */

- _Text_ prompt: _Text_ _ c:(int)c { _.fclr = @(c); [_ print];

  return NSFileHandle.fileHandleWithStandardInput.availableData.UTF8String;
}

- _Void_ setCursorLocation: _Cell_ _ { printf("%s%ld;%ldH", CSI, _.row + 1, _.col + 1); }

#if !TARGET_OS_IPHONE
- _Void_ clearConsole {

  NSAppleScript *s = [NSAppleScript.alloc initWithSource:@"tell application \"System Events\" to keystroke \"k\" using command down"];
  NSDictionary *err; NSAppleEventDescriptor * x = [s executeAndReturnError:&err];
  if (err || (x && x.stringValue)) NSLog(@"err:%@ event:%@",err, x.stringValue);

} /* OK */


- _List_ args { return [NSProcessInfo.processInfo.arguments subarrayFromIndex:1]; } /* OK */

#endif

+ _Data_ embeddedDataFromSegment:_Text_ seg inSection: _Text_ sec error:(_Errr*) e {

   return [DDEmbeddedDataReader embeddedDataFromSegment:seg inSection:sec error:e];
}

- _Dict_ infoPlist { return [DDEmbeddedDataReader defaultEmbeddedPlist:nil]; }

- (AVAudioPlayer*) playerForAudio:dataOrPath { // lets create an audio player to play the audio.

  NSError *e = nil; AVAudioPlayer *player =

  ISA(dataOrPath,Data)  ? [AVAudioPlayer.alloc initWithData:dataOrPath error:&e] :
  ISA(dataOrPath,NSURL) ||
  ISA(dataOrPath,Text)  ? [AVAudioPlayer.alloc initWithContentsOfURL:
                                (ISA(dataOrPath,NSURL) ? dataOrPath : [dataOrPath urlified]) error:&e] : nil;

  return (!player || e) ? NSLog(@"problem making player: %@", e), player
                        : [player setNumberOfLoops:-1], [player prepareToPlay], player;
}

- _Void_ justPlay:path {

  AVAudioPlayer *p = [self playerForAudio:path];
  p.delegate = self;
  [p setNumberOfLoops:0];
  [p play];
  CFRunLoopRun();
}

- _Void_ audioPlayerDidFinishPlaying:(AVAudioPlayer*)p successfully:_IsIt_ s {

  NSLog(@"finished playing");
//  CFRunLoopStop(CFRunLoopGetMain());
}

- _Text_ scan {

  return [Text.alloc initWithData:NSFileHandle.fileHandleWithStandardInput.availableData encoding:NSUTF8StringEncoding]; }

- _Void_ fillScreen: _Colr_ c { id line = $(@"%*s",@(IO.width).charValue," ");

  [line setBclr:c];

  int h = IO.height; while (h--) [line echo];
}

- _Void_ notify:_Note_ _ { 

  static IONotifier *notifier; notifier = notifier ?: [IONotifier.alloc initWithNotification:_];
}

- _Void_ print: _List_ lines {

  [[lines reduce:@"".mC withBlock:^id(id sum, id obj) { return

    [sum appendString: ISA(obj,Text) ? $(@"%@%@%@",(_Text_ obj).x, [self resetFX], zNL)
                     : ISA(obj,Colr) ? [[obj bgEsc]    withString:self.isxcode ? @"" : @"m"]  : @""], sum;
  }] print];
}

- _Text_ resetFX { AZSTATIC_OBJ(Text, r, ({ self.isxcode ? $UTF8(XCODE_RESET) : $UTF8(ANSI_RESET); })); return r; }

- _Void_ fill:_Rect_ r color:_ObjC_ c {

}

- _Text_ imageString: _Text_ path {

#if !TARGET_OS_IPHONE

return ![FM fileExistsAtPath:path] ? path : ({


    NSImage *image = [NSImage.alloc initWithContentsOfFile:path];
//    [image setScalesWhenResized:YES];
    CGFloat multi = MAX(image.size.width, NSScreen.mainScreen.
#if TARGET_OS_IPHONE
bounds
#else
frame
#endif
        .size.width/2)/image.size.width;
    [image setSize:CGSizeMake(image.size.width * multi,image.size.height * multi)];
//    id s = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    id x = [image.TIFFRepresentation base64EncodedStringWithOptions:0];


  $(@"\033]1337;File=name=%@;inline=1:%@\a\n",[path.UTF8Data base64EncodedString],x);//[Data dataWithContentsOfFile:path].base64EncodedString);

  });
//  \033]1337;File=name=" stringByAppendingFormat:@"%@;inline=1;%@\a\n",path.UTF8Data.base64EncodedString,
//                                                    ;

//    [[ -n "$1" ]] && printf "name=$(echo -n $1 | base64)"
//    $(base64 --version | grep GNU > /dev/null) && BASE64ARG=-d || BASE64ARG=-D
//    echo -n "$3" | base64 $BASE64ARG | wc -c | awk '{printf "size=%d",$1}' && printf ";inline=$2:$3\a\n"
//[[   ! -t 0 ]] && print_image "" 1 "$(cat | base64)" && exit 0
//[[ $# -eq 0 ]] && printf  "Usage: imgcat filename ...\n   or: cat filename | imgcat\n" && exit 1
//for fn in "$@"; do
//  [[ -r "$fn" ]] && print_image "$fn" 1 "$(base64 < "$fn")" || printf "imgcat: $fn: No such file or directory\n" && exit 1

#endif
}
//- _Void_ colorTest { for (int i = 0; i <256; i++) { [Text stringWithFormat:@"%]
@end








extern id IOrun	(id commandToRun){ NSString* outP;

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



                         // if (!value && self.ftty) [self setFclr:value = [NSColor fromTTY: self.ftty]]; },
                         // if (!value && self.btty) [self setBclr:value = [NSColor fromTTY: self.btty]]; },


