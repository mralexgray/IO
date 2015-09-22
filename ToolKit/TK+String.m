
#import "TK_Private.h"

@XtraPlan(Text,IO_Text)

+ _Text_ withColor:_Colr_ c fmt:_Text_ fmt,... { _Text new; va_list list; va_start(list,fmt);

  if ((new = [self.alloc initWithFormat:fmt arguments:list])) new.fclr = c; va_end(list); return new;
}

- (_CChr) cChar { return self.ioString.UTF8String; }

- _Void_ print256 {

  int c = 24;
  for (id x in [self componentsSeparatedByString:@" "]) {
    [[x stringByAppendingString:@" "] printC:[Colr fromTTY:c]]; c = c < 255 ? (c + 1) : 24;
  }
}


@XtraStop(Text,IO)

@XtraPlan(NObj,IO_NObj)

- _Text_ stringRep { return

  ISA(self,Text) ? (_Text_ self) : [self respondsToStringThenDo:NSStringValue] ?:
  ISA(self,List) ? (_List_ self).description :
  ISA(self,Numb) ?  _Text_ [Colr fromTTY:(_Numb_ self).iV] : self.description; }

- _Void_ echo     { printf("%s\n", self.stringRep.cChar); }
- _Void_ print    { // printf("%s" ,   self.stringRep.cChar);

//    NSData *data = self.stringRep.UTF8Data;// dataUsingEncoding:NSUTF8StringEncoding];
    [NSSTDOUT writeData:self.stringRep.UTF8Data];
}
- _Void_ printC:c { [self.stringRep[c] print];                        }

@XtraStop()


//SYNTHESIZE_ASC_PRIMITIVE_BLOCK(xfg, setXfg, int, ^{}, ^{ value = MAX(MIN(value,256),0) ?: 15; });
//SYNTHESIZE_ASC_PRIMITIVE_BLOCK(xbg, setXbg, int, ^{}, ^{ value = MAX(MIN(value,256),0) ?: 15; });

//- _Void_ setXbg:(int)b  { [self setXbg:b]; }
//- _Void_ setXfg:(int)f  { [self setXfg:f]; }
//- (int) xfg             { return self.fg ? self.fg.tty : ; }
//- (int) xbg             { return self.bg.tty; }

#pragma mark - COLOR

//- _Void_ setFg:(NSColor*)f { [self setXbg:f.tty]; }
//- _Void_ setBg:(NSColor*)b { [self setXfg:b.tty]; }
//- (Clr) fg { return [Clr_ fromTTY:self.xfg]; }
//- (Clr) bg { return [Clr_ fromTTY:self.xbg]; }

//SYNTHESIZE_ASC_OBJ_BLOCK(fg, setFg,  ^{ value = value ?: Clr_.redColor; },
//                                     ^{ value = DEVICECLR(value); });
//SYNTHESIZE_ASC_OBJ_BLOCK(bg, setBg, ^{ }, ^{ value = DEVICECLR(value); });


// rgb a;   (a = clr_2_rgb(c)).r, a.g, a.b];
//id ansiEsc (int c,BOOL fg) { return !c ? @"" : [NSString stringWithFormat:@"%s%i",fg ? ANSI_FG : ANSI_BG, c]; }

//- (NSString*) xString { return
//
//  IO.isxcode  ?
//  [NSString stringWithFormat:@"" XCODE_ESC "fg%@;" XCODE_ESC "bg%@;%@" XCODE_RESET, self.bg.xcTuple, self.fg.xcTuple, self] :
//
//  IO.isatty   ?
//  [NSString stringWithFormat:@"" ANSI_ESC ANSI_FG "%i"ANSI_BG"%im%@" ANSI_RESET, self.xfg, self.xbg,self] : self;
//
//}


_Void newline(int ct) { BOOL telnet = NO;

  while (ct--) { //	Telnet requires us to send a specific sequence for a line break (\r\000\n).

    if (!telnet) {
      putc('\n', stdout);  continue;  // Send a regular line feed
    }
    putc('\r', stdout);               // Send the telnet newline sequence
    putc(0,    stdout);               // We will send `n` linefeeds to the client
    putc('\n', stdout);
  }
}

//void _put(NSString *x, BOOL cr) {

//    fprintf(stderr,"%s", x.UTF8String); !cr ?: newline(1); }


@XtraPlan(NSO, pther)

//- (NSString *)red     { self.fg = NSColor.redColor;    return self.xString; }
//- (NSString *)orange  { self.fg = NSColor.orangeColor; return self.xString; }
//- (NSString *)yellow  { self.fg = NSColor.yellowColor; return self.xString; }
//- (NSString *)green   { self.fg = NSColor.greenColor;  return self.xString; }
//- (NSString *)blue    { self.fg = NSColor.blueColor;   return self.xString; }

typedef NS_ENUM(int,FMTOptions){

  FMT_BOLD      = 0x00000001,
  FMT_UNDL      = 0x00000010,
  FMT_BLNK      = 0x00000100,
  FMT_NEG       = 0x00001000,
  FMT_POS       = 0x00011000,
  FMT_FRAME     = 0x00100000,
  FMT_ENCIRCLE  = 0x01000000,
  FMT_OVERLINED = 0x10000000,
  FMT_NO_RESET  = 0x11111111
};

- _Void_ setOptions:(FMTOptions)options {

  [self willChangeValueForKey:@"options"];
  objc_setAssociatedObject(self, @selector(options), [NSValue value:&options withObjCType:@encode(FMTOptions)], OBJC_ASSOCIATION_RETAIN);
  [self didChangeValueForKey:@"options"];
}
- (FMTOptions) options {

  FMTOptions value;
  memset(&value, 0, sizeof(FMTOptions));
  @synchronized(self) { [objc_getAssociatedObject(self, _cmd) getValue:&value]; }
  return value;
}


@end

void FillLineClr(int c) {

  _Text x = [@(c).strV stringByPaddingToLength:IO.w withString:@" " startingAtIndex:0];
  //  [x setBclr:[NSC fromTTY:c]];
  [x setBclr:@(c)];//[NSC fromTTY:c]];
  [x print];
}

//void    PrintInClr (const char*s, int c)    { ;  }
//void      PrintClr (int c)                  { PrintInClr("  ", c); }
void       ClrPlus (const char* c)          { printf("%s0m%s", CSI, c); }
void      Spectrum (void)                   {

  //  for(int r = 0; r < 600; r++) { FillLineClr(r); }
  for(int r = 0; r < 6; r++) {
    for(int g = 0; g < 6; g++) {
      for(int b = 0; b < 6; b++) FillLineClr( 16 + (r * 36) + (g * 6) + b );  ClrPlus("  ");
    }
    printf("\n");
  }
}



