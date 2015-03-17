
#import "_IO.h"

CGFloat GETCOMPONENT(int rgorb, _Colr c) {

#if TARGET_OS_IPHONE
CGColorRef tmpColor = [c CGColor];
CGFloat newComponents[4] = {};
memcpy(newComponents, CGColorGetComponents(tmpColor), sizeof(newComponents));
// now newComponents is filled with tmpColor rgba data
  return newComponents[rgorb];
#else
  return rgorb == 0 ? c.redComponent : rgorb == 1 ? c.greenComponent : c.blueComponent;
#endif

}
         rgb COLOR_TABLE[256];
static _UInt  CUBE_STEPS[] = { 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF };
static   rgb     BASIC16[] = {{  0,   0,   0}, {205, 0,   0}, { 0, 205,   0}, { 205, 205,   0},
                              {  0,   0, 238}, {205, 0, 205}, { 0, 205, 205}, { 229, 229, 229},
                              {127, 127, 127}, {255, 0,   0}, { 0, 255,   0}, { 255, 255,   0},
                              { 92,  92, 255}, {255, 0, 255}, { 0, 255, 255}, { 255, 255, 255}};

@implementation Colr (AtoZIO)

- _Text_ bgEsc { return IO.isxcode  ? $(@"" CSI              "bg%@;", self.xcTuple) :
                        IO.isatty   ? $(@"" ANSI_ESC ANSI_BG "%lu",   self.tty) : @"";
}

- _Text_ fgEsc { return IO.isxcode  ? $(@"" CSI              "fg%@;", self.xcTuple) :
                        IO.isatty   ? $(@"" ANSI_ESC ANSI_FG "%lu",   self.tty) : @"";
}

- _UInt_ r { return GETCOMPONENT(0,DEVICECLR(self)) * 255; }
- _UInt_ g { return GETCOMPONENT(1,DEVICECLR(self)) * 255; }
- _UInt_ b { return GETCOMPONENT(2,DEVICECLR(self)) * 255; }

+ _Colr_ fromTTY:_UInt_ x { _UInt r = 0, g = 0, b = 0;  // else is (RgbColor){0, 0, 0};

               x < 16 ? ({ rgb basic = BASIC16[x]; r = basic.r; g = basic.g; b = basic.b; }) :
 232 <= x && x <= 255 ? ({ _UInt calc = 8 + (x - 232) * 0x0A; r = g = b = calc; }) :
    16 <= x && x <= 231 ? ({ x -= 16; r = CUBE_STEPS[(x/36) % 6];
                                    b = CUBE_STEPS[(x/ 6) % 6];
                                    g = CUBE_STEPS[ x     % 6]; }) : (void)nil;
  return MakeColor(r, g, b);
}

- _UInt_ tty { _Colr c = DEVICECLR(self);  /** Quantize RGB values to an xterm 256-color ID */

  int r = c.r, g = c.g, b = c.b, best_m = 0, smallest_d = 1000000000, x, d;

  for (x = 16; x < 256; x++)

    if ((d = sqr(COLOR_TABLE[x].r - r) + sqr(COLOR_TABLE[x].g - g) + sqr(COLOR_TABLE[x].b - b)) < smallest_d) {

      smallest_d = d; best_m = x;
    }
  return best_m;
}

- _Text_ xcTuple { return [Text stringWithFormat:@"%lu,%lu,%lu",self.r, self.g,self.b]; }

@end

__attribute__((constructor)) static _Void init() { for (int c = 0; c < 256; c++) {

  _Colr r = [Colr fromTTY:c];  COLOR_TABLE[c] = (rgb){ r.r, r.g, r.b };   }  //,  /// [Clr_ tty_2_rgb:c];
}


//+ (Clr) fromRGB:(rgb)c { return MakeColor(c.r,c.g,c.b);  }
//- (rgb) rgb { Clr cc = DEVICECLR(self); return (rgb){cc.redComponent*255,cc.greenComponent*255,cc.blueComponent*255}; }

//+ (Clr) xColor:(int)ttyc { return [self tty_2_clr:ttyc); } // return [self colorWithDeviceRed:z.r green:z.g blue:z.b alpha:1]; }
  //-  (int) x256          { return [clr_2_tty(self);

  //  return [objc_getAssociatedObject(self, _cmd) ?: ({
  //
  //  Clr me = [self colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace];
  //  NSNumber *x = @(clr_2_tty((rgb){me.redComponent*255, me.greenComponent*255, me.blueComponent*255}));
  //  objc_setAssociatedObject(self, _cmd, x, OBJC_ASSOCIATION_RETAIN_NONATOMIC);  x; }) intValue];
  //}
