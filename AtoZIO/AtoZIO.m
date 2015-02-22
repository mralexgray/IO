

#include <stdio.h>
#include <sys/ioctl.h>

#import <AtoZAutoBox/AtoZAutoBox.h>
#import "DDEmbeddedDataReader.h"
#import <AQOptionParser/AQOptionParser.h>

#import "AtoZIO.h"

#define GOT_TO printf("got to %i\n", __LINE__)

@implementation AtoZIO

+ (NSString*) exePath { return NSProcessInfo.processInfo.arguments[0]; }

+      (BOOL) inTTY    { return [@(isatty(STDERR_FILENO))boolValue]; }
+      (BOOL) inXcode  { return [NSProcessInfo.processInfo.environment[@"XCODE_COLORS"] isEqual:@YES]; }

+       (int) terminal_width   { return [self terminal_size].width;   }
+       (int) terminal_height  { return [self terminal_size].height;  }
+    (NSSize) terminal_size    { char * nterm; struct winsize w;

  if (!(nterm = getenv("TERM"))) return (NSSize){ -1,-1};
  /* We are running standalone, retrieve the terminal type from the environment. */
  strcpy(term, nterm); ioctl(0, TIOCGWINSZ, &w); return (NSSize){ w.ws_col, w.ws_row};

} /* OK */

+ (NSString*) readWithPrompt:(NSString*)_ {

  !_ ?: (void)fprintf(stderr,"%s", _.UTF8String);

  return [NSString.alloc initWithData:NSFileHandle.fileHandleWithStandardInput.availableData
                             encoding:NSASCIIStringEncoding];
} /* OK */

+ (void) clearConsole {

  NSAppleScript *s = [NSAppleScript.alloc initWithSource:@"tell application \"System Events\" to keystroke \"k\" using command down"];

  NSDictionary *err; NSAppleEventDescriptor * x = [s executeAndReturnError:&err];
  if (err || (x && x.stringValue)) NSLog(@"err:%@ event:%@",err, x.stringValue);
} /* OK */

+ (NSArray*) args {

  NSMutableArray *args = @[].mutableCopy;
  [NSProcessInfo.processInfo.arguments enumerateObjectsUsingBlock:^(id arg, NSUInteger i, BOOL *s) {
    !i || ![arg length] ?: [args addObject:arg];
  }];
  return args;
} /* OK */


+ (NSData*) embeddedDataFromSegment:(NSString*)seg inSection:(NSString*)sec error:(NSError**)e {
  return [DDEmbeddedDataReader embeddedDataFromSegment:seg inSection:sec error:e];
}

+ (AVAudioPlayer*) playerForAudio:(id)dataOrPath { // lets create an audio player to play the audio.

  NSError *e; AVAudioPlayer *player  = [dataOrPath isKindOfClass:  NSData.class]
                                     ? [AVAudioPlayer.alloc initWithData:dataOrPath error:&e]
                                     : [dataOrPath isKindOfClass:   NSURL.class]
                                    || [dataOrPath isKindOfClass:NSString.class]
                                     ? [AVAudioPlayer.alloc initWithContentsOfURL:
                                       [dataOrPath isKindOfClass:NSURL.class]
                                     ?  dataOrPath
                                     : [NSURL fileURLWithPath:dataOrPath] error:&e]
                                     : nil;

  return !player || e ? NSLog(@"problem making player: %@", e), (id)nil
                      : [player setNumberOfLoops:-1], [player prepareToPlay], player; //prepare the file to play
}

+ (NSDictionary*)parseArgs:(char *[])argv andKeys:(NSArray*)keys count:(int)argc {


  //- (id)initWithArgs:(const char *[])argv andKeys:(NSArray *)keys count:(int)argc
  //{
  //    self = [super init];
  //    const char    ** _argv = argv;
  //    int              _argc = argc;
  //    NSArray        * _keys = keys;
  NSDictionary    * val_ = @{};

  if (argc == 1) return val_;

  int c; int o = (int)keys.count + 1; NSMutableString *fmt = NSMutableString.new;  struct option long_options[o];

  memset(&long_options, 0, sizeof(struct option)*o);

  for (int i = 0; i < keys.count; i++) {

    NSDictionary *kv       = keys[i];
    NSString *name     = [kv objectForKey:@"name"];
    const char *n       = name.UTF8String;
    NSNumber *has_arg  = [kv objectForKey:@"has_arg"];
    int h_a;
    NSString *fl       = [kv objectForKey:@"flag"];
    unichar flag  = [fl characterAtIndex:0];
    if (has_arg.boolValue) {
      h_a = required_argument;
      [fmt appendFormat:@"%@:", fl];
    } else if (!has_arg.boolValue) {
      h_a = no_argument;
      [fmt appendString:fl];
    } else {
      h_a = optional_argument;
      [fmt appendFormat:@"%@::", fl];
    }
    long_options[i].name    = n;
    long_options[i].has_arg = h_a;
    long_options[i].flag    = NULL;
    long_options[i].val     = flag;
  }
  int last = o - 1;
  long_options[last].name = 0;
  long_options[last].has_arg = 0;
  long_options[last].flag = 0;
  long_options[last].val = 0;
  NSMutableDictionary *d = @{}.mutableCopy;
  int option_index = 0;

  //    while ((c = getopt_long(argc,argv,"eshiItnf:r:R:c:C:W:H:",long_opts, &index)) != -1) {    /* Process arguments */
  //    c = c ?: !long_opts[index].flag ? long_opts[index].val : c;
  while ((c = getopt_long(argc,argv,"eshiItnf:r:R:c:C:W:H:",long_options, &option_index)) != -1) {    /* Process arguments */

    c = c ?: !long_options[option_index].flag ? long_options[option_index].val : c;

    //    while (YES) {
    //      XX(argc); XX(argv); XX(fmt.UTF8String); XX( &option_index);
    //GOT_TO;
    //      c = getopt_long(argc, argv, fmt.UTF8String, long_options, &option_index);
    //      XX(c);
    //GOT_TO;
    //        if (c == -1) break;
    //        else {
    //            NSString * k = [NSString stringWithCString:long_options[option_index].name encoding:NSUTF8StringEncoding];
    //            id    v = optarg ? [NSString stringWithCString:optarg encoding:NSUTF8StringEncoding] : @YES;
    //            [d setObject:v forKey:k];
    //        }
    GOT_TO;
  }
  GOT_TO;
  int _i = -1;
  for (int i = 1; i < argc; i++) {
    NSString *arg = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
    if ([arg rangeOfString:@"--"].location == NSNotFound) {  _i = i; /* First non-option argument. */ break; }
  }
  GOT_TO;
  if (_i == -1) [d setObject:@NO forKey:@"{query}"];
  else {
    NSMutableString *q = @"".mutableCopy;
    for (int j = _i; j < argc; j++) [q appendFormat:@"%@ ", [NSString stringWithCString:argv[j] encoding:NSUTF8StringEncoding]];

    q = [NSMutableString stringWithString:[q stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet]];
    [d setObject:q forKey:@"{query}"];
  }
  return [d copy];
}

@end


#pragma mark - AtoZ Additions

void newline(int ct) {

  while ( ct-- ) {
//  for (int i = 0; i < ct; ++i) { //	Telnet requires us to send a specific sequence for a line break (\r\000\n), so let's make it happy.
    if (!telnet) {
      putc('\n', stdout);  continue;  // Send a regular line feed
    }
    putc('\r', stdout);               // Send the telnet newline sequence
    putc(0,    stdout);                  // We will send `n` linefeeds to the client
    putc('\n', stdout);
  }
}
void print_with_newlines(char *first,...){

  int numlines = 0; char * line = first; va_list list; va_start(list, first);

  while (line != NULL) {               printf("%s",line);

    numlines = va_arg(list, int);     newline(numlines);
    line = va_arg(list, char*);
  }            va_end(list);
}
void reset_cursor() { printf("\033[%s", clear_screen ? "H" : "u"); }
void   clr_screen() { printf(clear_screen ? "\033[H\033[2J\033[?25l" : "\033[s"); 		/* Clear the screen */ }

#pragma mark - XTERM

int    CUBE_STEPS[] = { 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF };

RgbColor BASIC16[] = {  {   0,   0,   0 }, { 205,   0,   0}, {   0, 205,   0 }, { 205, 205,   0 }, {   0,   0, 238}, { 205,   0, 205 },
                        {   0, 205, 205 }, { 229, 229, 229}, { 127, 127, 127 }, { 255,   0,   0 }, {   0, 255,   0}, { 255, 255,   0 },
                        {  92,  92, 255 }, { 255,   0, 255}, {   0, 255, 255 }, { 255, 255, 255 } };

RgbColor  COLOR_TABLE[256];

static RgbColor  xterm_to_rgb(int x)  { int calc; return

              x <   16 ? BASIC16[x] :
  232 <= x && x <= 255 ? (calc = 8 + (x - 232) * 0x0A), (RgbColor){ calc,calc,calc} :
   16 <= x && x <= 231 ? (  x -= 16),                   (RgbColor){ CUBE_STEPS[(x / 36) % 6], CUBE_STEPS[(x / 6) % 6], CUBE_STEPS[x % 6]}
                       :                                (RgbColor){ 0,0,0 };
}

#define sqr(x) ((x) * (x))

int rgb_to_xterm(int r, int g, int b) { return ({ /** Quantize RGB values to an xterm 256-color ID */

  int best_match = 0, smallest_distance = 1000000000, c, d;

//  for (c = 16; c < 256; c++) { d = sqr(COLOR_TABLE[c].rVal - r) + sqr(COLOR_TABLE[c].gVal - g) + sqr(COLOR_TABLE[c].bVal - b);
  for (c = 16; c < 256; c++) { d = sqr(COLOR_TABLE[c].r - r) + sqr(COLOR_TABLE[c].g - g) + sqr(COLOR_TABLE[c].b - b);

    if (d < smallest_distance) { smallest_distance = d; best_match = c; } }  best_match; });
}

@implementation NSColor (atozio) @dynamic bg, fg;

//+ (NSArray*)    x16         { return [@16 mapTimes:^id(NSNumber* c){ return [self xColor:c.intValue]; }]; }
+ (NSArray*)    x16           { NSMutableArray *x = @[].mutableCopy; for (int c = 0; c < 16; c++) [x addObject:[self xColor:c]]; return x; }

+ (NSColor*) xColor:(int)x    { RgbColor z = xterm_to_rgb(x); return [self colorWithDeviceRed:z.r/255. green:z.g/255. blue:z.b/255. alpha:1]; }
- (NSNumber*)   x256           { NSColor*x = [self colorUsingColorSpace:NSColorSpace.deviceRGBColorSpace]; return @(rgb_to_xterm(x.redComponent*255, x.greenComponent*255,x.blueComponent*255)); }
- (NSColor*)     bg           { return !!self.otherColor &&  self.otherColor.isBGColor ? self.otherColor : nil;   }
- (NSColor*)     fg           { return !!self.otherColor && !self.otherColor.isBGColor ? self.otherColor : self;  }
- (void)  setBg:(NSColor*)b   { [self setOther:b isBG:YES]; }
- (void)  setFg:(NSColor*)f   { [self setOther:f isBG:NO];  }
- (NSColor*) withFG:(NSColor*)c   { return self.fg = c, self; }
- (NSColor*) withBG:(NSColor*)c   { return self.bg = c, self; }
- (BOOL) isBGColor        { return !!objc_getAssociatedObject(self, _cmd); }
- (NSColor*) otherColor       { return   objc_getAssociatedObject(self, _cmd); }
- (void) setOther:(NSColor*)c
             isBG:(BOOL)x { objc_setAssociatedObject(c,     @selector(isBGColor), x ? @YES : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            objc_setAssociatedObject(self,  @selector(otherColor),             c, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

//JREnumDefine(FMTOptions);

#pragma mark - COLOR

#define FMT_ESC "\x1b["
#define FMT_FG "38;05;"
#define FMT_BG "48;05;"

#define FMT_RESET     "0m"  // Reset all SGR options.
#define FMT_RESET_FG  "39m" // Reset foreground color.
#define FMT_RESET_BG  "49m" // Reset background color.

//  SYNTHESIZE_ASC_OBJ (  color, setColor                );
//SYNTHESIZE_ASC_PRIMITIVE_KVO ( options, setOptions, FMTOptions  );

@implementation NSString (atozio) // static void* colorKey = "color";

- (NSString *)red     { self.color = NSColor.redColor;    return self.xString; }
- (NSString *)orange  { self.color = NSColor.orangeColor; return self.xString; }
- (NSString *)yellow  { self.color = NSColor.yellowColor; return self.xString; }
- (NSString *)green   { self.color = NSColor.greenColor;  return self.xString; }
- (NSString *)blue    { self.color = NSColor.blueColor;   return self.xString; }

- (void)  setColor:(NSColor *)_ { @synchronized(self) { objc_setAssociatedObject(self, @selector(color), _,OBJC_ASSOCIATION_RETAIN); } }

- (NSColor*) color { id c; @synchronized(self) { c = objc_getAssociatedObject(self,_cmd); } return c; }

- (void)    setOptions:(FMTOptions)options {

  [self willChangeValueForKey:@"options"];
  objc_setAssociatedObject(self, @selector(options),
      [NSValue value:&options withObjCType:@encode(FMTOptions)], OBJC_ASSOCIATION_RETAIN);
  [self didChangeValueForKey:@"options"];
}
- (FMTOptions) options {
  __block FMTOptions value;
  memset(&value, 0, sizeof(FMTOptions));
  @synchronized(self) {
    [objc_getAssociatedObject(self, _cmd) getValue:&value]; }
  return value;
}



- (NSString*) fg { return self.color.fg ? [NSString stringWithFormat:@"38;05;%@;", self.color.fg.x256.stringValue] : @""; }

- (NSString*) bg { return self.color.bg ? [NSString stringWithFormat:@"48;05;%@;", self.color.bg.x256.stringValue] : @""; }

- (const char*) cChar  { return self.xString.UTF8String; }

- (NSString*) xString {

  return self.color ? [NSString stringWithFormat:@"" FMT_ESC "%@%@m%@" FMT_ESC FMT_RESET, self.fg, self.bg, self] : self; }

//+ (NSString*) _withColor:(NSColor*)c
//                    fmt:(NSString*)f
//                   args:(va_list)l { NSString*x = [self.alloc initWithFormat:f arguments:l]; return x ? x.color = c, x : nil; }

+ (NSString*) withColor:(NSColor*)c
                    fmt:(NSString*)fmt,... {

  NSString *new; va_list list; va_start(list,fmt);

  if ((new = [self.alloc initWithFormat:fmt arguments:list])) new.color = c;

  va_end(list); return new;

  //  new = [self _withColor:c fmt:fmt args:list];
}

void _put(NSString *x, BOOL cr) { fprintf(stderr,"%s", x.cChar); !cr ?: newline(1); }

- (void) echo                     { _put(self, YES); }
- (void) print                    { _put(self,  NO); }
- (void) printInColor:(NSColor*)c { self.color = c; [self print]; }

+ (NSString*) scan {

  return  [NSString.alloc initWithData:
          [NSFileHandle.fileHandleWithStandardInput availableData]
                                    encoding:NSUTF8StringEncoding];

//  char cstring[1024];
//  scanf("%s", cstring);
//  return [self stringWithUTF8String:cstring];
//  NSFileHandle *input = NSFileHandle.fileHandleWithStandardInput;
//  while (1) {
//    NSData* data = input.availableData;
//    if(data != nil)
//        NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
// }
//  char x[32];
//  int y = 0;
//  double z = 0.0;
//
//  printf("What's your name? ");
//  // note the use of fgets instead of scanf("%s",...)
//  // to prevent buffer overflows by specifying a maximum length!
//  fgets(x, 32, stdin);
//
//  // remove newline
//  x[strlen(x)-1] = '\0';
//
//  printf("Hi, %s!  How old are you? ", x);
//  scanf("%d", &y);
//
//  printf("What's your favorite number? ");
//  scanf("%lf", &z);
//
//  printf("Nice to meet you, %s!  You are %d years old and like the number %f.\n", x, y, z);

}
@end

void    PrintInClr (const char*s, int c)    { printf("%s\n", [NSString withColor:[NSColor xColor:c] fmt:@"%s",s].UTF8String);  }
void      PrintClr (int c)                  { PrintInClr("  ", c); }
void       ClrPlus (const char* c)          { printf("%s0m%s", FMT_ESC, c); }
void    FillScreen (int c)                  {

  for (int ctr = 0; ctr < AtoZIO.terminal_height; ctr++){

    PrintInClr([NSString stringWithFormat:@"%*s", AtoZIO.terminal_width, " "].UTF8String, c);
  }
}
void      Spectrum (void)                   {
 
  for(int r = 0; r < 6; r++) {
      for(int g = 0; g < 6; g++) {
          for(int b = 0; b < 6; b++) PrintClr( 16 + (r * 36) + (g * 6) + b );  ClrPlus("  ");
    }
    printf("\n");
  }
}

NSArray * NumtoArray(int num) {

  NSMutableArray *re = NSMutableArray.new;

	double alpha = 0, omega = num, delta = 1;
	
	delta = (alpha > omega && delta) || (alpha < omega && delta < 0) ? -delta : delta;

	BOOL (^_)(double) = delta ? ^(double g){ return (BOOL) (g <= omega); }
                            : ^(double g){ return (BOOL) (g >= omega); };

	for (double gamma = alpha; _(gamma); gamma += delta) [re addObject:@(gamma)];
	return re;
}

void     AllColors (void(^block)(int c))    {

  for (NSNumber *n in NumtoArray(255))  block(n.intValue);
}
void   _PrintInRnd (id x, va_list list)     {

PrintInClr([NSString.alloc initWithFormat:x arguments:list].UTF8String, arc4random_uniform(256)); }
void  PrintInRnd (id x,...)               { va_list list; va_start(list,x); _PrintInRnd(x, list); va_end(list);

}

__attribute__ ((constructor)) static void setupColors (){

  for (int c = 0; c < 256; c++) COLOR_TABLE[c] = xterm_to_rgb(c);
}



//void SystemGrays () { for (zColor color = 232; color < 256; color++)  PrintClr(color); }

//#define FG(X) "38;05;"#X
//
//#define FMT_BOLD      "1m"
//#define FMT_BOLD_OFF  "22m"
//#define FMT_UNDL      "4m"
//#define FMT_UNDL_OFF  "24m"
//#define FMT_BLNK      "5m" // Less then 150 per minute.
//#define FMT_BLNK_OFF  "25m"
//
//#define FMT_NEG       "7m"  // Set reversed-video active (foreground and background negative).
//#define FMT_POS       "27m" // Reset reversed-video to normal.
//
//#define FMT_FRAME     "51m"
//#define FMT_ENCIRCLE  "52m"
//#define FMT_ENCIRCLE_OFF "54m"
//
//#define FMT_OVERLINED     "53m"
//#define FMT_OVERLINED_OFF "55m"
//
//#define CLR_SCRN "\e[H\e[J"



NSString * standardInput(void) {

  return [[NSProcessInfo.processInfo.arguments subarrayWithRange:NSMakeRange(1, NSProcessInfo.processInfo.arguments.count-1)] componentsJoinedByString:@"\n"];
//   [NSString stringWithData:[NSData dataWithData:[NSFileHandle.fileHandleWithStandardInput readDataToEndOfFile]]
//                         encoding:NSUTF8StringEncoding];
}


NSString *define(NSString*word) {

 return (id) nil;
//	CFRange range = CFRangeMake(0, word.length));  //CFStringGetLength(word));
//	CFStringRef def = DCSCopyTextDefinition(NULL, word.UTF8String, range);
//	return !def ? nil : [NSString stringWithUTF8String:xmalloc( CFStringGetMaximumSizeOfFileSystemRepresentation(def))];
//		CFIndex n =; char *str = ; if (CFStringGetFileSystemRepresentation(def, str, n) == true) {
}



#define COLOR_COMPONENT_SCALE_FACTOR 255.0f
#define COMPONENT_DOMAIN_DEGREES 60.0f
#define COMPONENT_MAXIMUM_DEGREES 360.0f
#define COMPONENT_OFFSET_DEGREES_GREEN 120.0f
#define COMPONENT_OFFSET_DEGREES_BLUE 240.0f
#define COMPONENT_PERCENTAGE 100.0f

@implementation NSColor (HSVExtras) // NSColor+HSVExtras.m MMPieChart Demo

- (RgbColor) rgbColor { return [NSColor rgbColorFromColor:self]; }
- (HsvColor) hsvColor { return [NSColor hsvColorFromColor:self]; }

+ (HsvColor)    hsvColorFromColor:(NSColor*)color {

  return [self hsvColorFromRgbColor:[self rgbColorFromColor:color]];
}
+ (RgbColor)    rgbColorFromColor:(NSColor*)color {

    const CGFloat *colorComponents  = CGColorGetComponents(color.CGColor);
    return (RgbColor){(int)colorComponents[0] * COLOR_COMPONENT_SCALE_FACTOR,
                      (int)colorComponents[1] * COLOR_COMPONENT_SCALE_FACTOR,
                      (int)colorComponents[2] * COLOR_COMPONENT_SCALE_FACTOR,
                           colorComponents[0],
                           colorComponents[1],
                           colorComponents[2] };
}
+ (HsvColor) hsvColorFromRgbColor:(RgbColor)color { HsvColor hsvColor;
    
    CGFloat maximumValue = MAX(color.r, color.g); maximumValue = MAX(maximumValue, color.b);
    CGFloat minimumValue = MIN(color.r, color.g); minimumValue = MIN(minimumValue, color.b);

    CGFloat range = maximumValue - minimumValue; hsvColor.hueValue = 0;

    if (maximumValue == minimumValue) { /* continue */ }

    else if (maximumValue == color.r) {
        hsvColor.hueValue = (int)roundf(COMPONENT_DOMAIN_DEGREES * (color.g - color.b) / range);
        if (hsvColor.hueValue < 0) hsvColor.hueValue += COMPONENT_MAXIMUM_DEGREES;
    }
    else if (maximumValue == color.g)
        hsvColor.hueValue = (int)roundf(((COMPONENT_DOMAIN_DEGREES * (color.b - color.r) / range)
                                        + COMPONENT_OFFSET_DEGREES_GREEN));
    else if (maximumValue == color.b)
        hsvColor.hueValue = (int)roundf(((COMPONENT_DOMAIN_DEGREES * (color.r - color.g) / range)
                                        + COMPONENT_OFFSET_DEGREES_BLUE));
    
    hsvColor.saturationValue = 0;
    if (!maximumValue) { /* continue */ }
    else hsvColor.saturationValue = (int)roundf(((1.0f - (minimumValue / maximumValue)) * COMPONENT_PERCENTAGE));
    
    hsvColor.brightnessValue      = (int)roundf((maximumValue * COMPONENT_PERCENTAGE));
    
    hsvColor.hue        = (CGFloat)hsvColor.hueValue        / COMPONENT_MAXIMUM_DEGREES;
    hsvColor.saturation = (CGFloat)hsvColor.saturationValue / COMPONENT_PERCENTAGE;
    hsvColor.brightness = (CGFloat)hsvColor.brightnessValue / COMPONENT_PERCENTAGE;
    
    return hsvColor;
}

- (BOOL) canProvideRGBComponents {  CGColorSpaceModel ref = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));

  return (ref == kCGColorSpaceModelRGB || ref == kCGColorSpaceModelMonochrome);
}

- (CGFloat) red    { NSAssert([self canProvideRGBComponents], @"Must be an RGB color to use -red");  const CGFloat *c = CGColorGetComponents(self.CGColor);	return c[0]; }
- (CGFloat) green  {	NSAssert([self canProvideRGBComponents], @"Must be an RGB color to use -green");	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome ? c[0] :	c[1];
}
- (CGFloat) blue   { NSAssert([self canProvideRGBComponents], @"Must be an RGB color to use -blue"); const CGFloat *c = CGColorGetComponents(self.CGColor);
  return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome ? c[0] : c[2];
}
- (CGFloat) white  {	NSAssert(CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);	return c[0];
}

- (CGFloat) alpha       {	return CGColorGetAlpha(self.CGColor);                 }
- (CGFloat) hue         { return [NSColor hsvColorFromColor:self].hue;          }
- (CGFloat) saturation  { return [NSColor hsvColorFromColor:self].saturation;   }
- (CGFloat) brightness  { return [NSColor hsvColorFromColor:self].brightness;   }
- (CGFloat) value       {	return self.brightness;                               }

@end

#ifdef php
function swatch() { $r = ceil(rand(0,255));    $g = ceil(rand(0,255));    $b = ceil(rand(0,255));    return array($r,$g,$b); } //Return an RGB array
$s = array(); for($i=0; $i<400; $i++) { list($r,$g,$b) = swatch(); $s[] = rgbtohsv($r,$g,$b); }//Create an array of random RGB colours converted to HSV
foreach($s as $k => $v) { $hue[$k] = $v[0];$sat[$k] = $v[1]; $val[$k] = $v[2];} //Split each array up into H, S and V arrays
array_multisort($hue,SORT_ASC, $sat,SORT_ASC, $val,SORT_ASC,$s); //Sort in ascending order by H, then S, then V and recompile the array
//Display
foreach($s as $k => $v) { list($hue,$sat,$val) = $v; list($r,$g,$b) = hsvtorgb($hue,$sat,$val); echo "<div style='border:1px solid #000;padding:4px;background:rgb($r,$g,$b);'>$r,$g,$b</div>"; }
#endif

//NSString * standardInput();

//@implementation NSBundle (Fake)
//
//+ (BOOL) pretendToBe:appNameOrID {
//
//  typeof(self) bundle = [self bundleWithIdentifier:appNameOrID]
//                     ?: [self bundleForApplicationName:appNameOrID];
//
//  if (!bundle) return NO;
//
//  
//}
//
//@end


//int getIntegerFromConsole(NSString* prompt) { return getStringFromConsole(prompt).intValue; }
//
//float getDecimalFromConsole(NSString* prompt) { return getStringFromConsole(prompt).floatValue; }


//+ (instancetype) IO { static id x; static dispatch_once_t t; dispatch_once(&t, ^{ x = [self.class.alloc init]; }); return x; }
//
//+ (void) describeEnv { /* prin */ }
