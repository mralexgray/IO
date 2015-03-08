
#import "IO.h"

char term[1024] = {'a','n','s','i', 0};  /* The default terminal is ANSI */

#define GOT_TO printf("got to %i\n", __LINE__)

@implementation AtoZIO @synthesize isxcode = _isxcode; @dynamic cursorPosition; UNO(io);

- (NSString*) $0       { return   PROCINFO.arguments[0];       }
- (NSNumber*) $$       { return @(PROCINFO.processIdentifier); }
-      (BOOL) isatty   { return [@(isatty(STDERR_FILENO))boolValue]; }
-      (BOOL) isxcode  { static dispatch_once_t u; return

  dispatch_once(&u, ^{ _isxcode  = [  IOrun([NSString stringWithFormat:@"/bin/ps -p %@",
                                      IOrun([NSString stringWithFormat:@"/bin/ps -xc -o ppid= -p %@", IO.$$])])
                                                                rangeOfString:@"Xcode"].location != NSNotFound;
  }), _isxcode;
}
-       (int) width    { return self.size.width;   }
-       (int) height   { return self.size.height;  }
-    (CGSize) size     { char * nterm; struct winsize w;

  if (!(nterm = getenv("TERM"))) return (NSSize){ 80, 30};
  /* We are running standalone, retrieve the terminal type from the environment. */
  strcpy(term, nterm); ioctl(0, TIOCGWINSZ, &w); return (CGSize){ w.ws_col, w.ws_row};

}

- (NSString*) prompt:(NSString*)_ { return [self prompt:_ c:0]; } /* OK */

- (NSString*) prompt:(NSString*)_ c:(int)c { _.ftty = c; [_ print];

  return [NSString.alloc initWithData:NSFileHandle.fileHandleWithStandardInput.availableData
                             encoding:NSASCIIStringEncoding];
}



- (void) setCursorPosition:(Position)_ {

  printf("%s%lu;%luH", CSI, _.row + 1, _.col + 1);
}
- (void) clearConsole {

  NSAppleScript *s = [NSAppleScript.alloc initWithSource:@"tell application \"System Events\" to keystroke \"k\" using command down"];

  NSDictionary *err; NSAppleEventDescriptor * x = [s executeAndReturnError:&err];
  if (err || (x && x.stringValue)) NSLog(@"err:%@ event:%@",err, x.stringValue);
} /* OK */

- (NSArray*) args {

  NSMutableArray *args = @[].mutableCopy;
  [NSProcessInfo.processInfo.arguments enumerateObjectsUsingBlock:^(id arg, NSUInteger i, BOOL *s) {
    !i || ![arg length] ?: [args addObject:arg];
  }];
  return args;
} /* OK */

+ (NSData*) embeddedDataFromSegment:(NSString*)seg inSection:(NSString*)sec error:(NSError**)e {
  return [DDEmbeddedDataReader embeddedDataFromSegment:seg inSection:sec error:e];
}

- (NSDictionary*) infoPlist { return [DDEmbeddedDataReader defaultEmbeddedPlist:nil]; }

- (AVAudioPlayer*) playerForAudio:dataOrPath { // lets create an audio player to play the audio.

  NSError *e; AVAudioPlayer *player  = [dataOrPath isKindOfClass:  NSData.class]
                                     ? [AVAudioPlayer.alloc initWithData:dataOrPath error:&e]
                                     : [dataOrPath isKindOfClass:   NSURL.class]
                                    || [dataOrPath isKindOfClass:NSString.class]
                                     ? [AVAudioPlayer.alloc initWithContentsOfURL:
                                       [dataOrPath isKindOfClass:NSURL.class]
                                     ?  dataOrPath
                                     : [NSURL fileURLWithPath:dataOrPath] error:&e] : nil;

  return !player || e ? NSLog(@"problem making player: %@", e), (id)nil
                      : [player setNumberOfLoops:-1], [player prepareToPlay], player;
}

- (NSString*) scan {

  return [NSString.alloc initWithData:NSFileHandle.fileHandleWithStandardInput.availableData encoding:NSUTF8StringEncoding]; }

- (void) fillScreen:(Clr)c { id line; [line = [NSString stringWithFormat:@"%*s", IO.width," "] setBtty:c];

  int h = IO.height; while (h--) [line echo];
}

@end



//NSString* outP;	char buffer[BUFSIZ + 1];
  //  memset(buffer, '\0', sizeof(buffer));
//  FILE *read_fp = popen([cmd UTF8String], "r");
//  if (read_fp == NULL) return @"";
//  size_t chars_read = fread(buffer, sizeof(char), BUFSIZ, read_fp);
//  outP = chars_read ? [NSString stringWithUTF8String:buffer] : @"";
//  pclose(read_fp);
//  return outP;
//}



extern id IOrun	(id commandToRun){

  NSTask *t    = NSTask.new;
  t.launchPath = @"/bin/sh";
  t.arguments  = @[@"-c", commandToRun];


  NSPipe *p; t.standardOutput = (p = NSPipe.pipe);

  NSFileHandle *file = p.fileHandleForReading; [t launch];

  return [NSString.alloc initWithData:file.readDataToEndOfFile encoding: NSUTF8StringEncoding];
}


                         // if (!value && self.ftty) [self setFclr:value = [NSColor fromTTY: self.ftty]]; },
                         // if (!value && self.btty) [self setBclr:value = [NSColor fromTTY: self.btty]]; },


