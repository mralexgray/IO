
#pragma mark - AtoZ Additions

void print_with_newlines(char *first,...){

  int numlines = 0; char * line = first; va_list list; va_start(list, first);

  while (line != NULL) {               printf("%s",line);

    numlines = va_arg(list, int);     newline(numlines);
    line = va_arg(list, char*);
  }            va_end(list);
}
void reset_cursor() { printf("\033[%s", clear_screen ? "H" : "u"); }
void   clr_screen() { printf(clear_screen ? "
H\033[2J\033[?25l" : "\033[s"); 		/* Clear the screen */ }



+  (NSArray*) x16   { static NSMutableArray *x;

  return x ?: ({ x = @[].mutableCopy; int c = 16; while (c--) [x addObject:[self xColor:c]]; x; });
}

//JREnumDefine(FMTOptions);


//  SYNTHESIZE_ASC_OBJ (  color, setColor                );
//SYNTHESIZE_ASC_PRIMITIVE_KVO ( options, setOptions, FMTOptions  );


@end


//+ (NSString*) _withColor:(NSColor*)c
//                    fmt:(NSString*)f
//                   args:(va_list)l { NSString*x = [self.alloc initWithFormat:f arguments:l]; return x ? x.color = c, x : nil; }

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


NSArray * NumtoArray(int num) {

  NSMutableArray *re = NSMutableArray.new;

	double alpha = 0, omega = num, delta = 1;
	
	delta = (alpha > omega && delta) || (alpha < omega && delta < 0) ? -delta : delta;

	BOOL (^_)(double) = delta ? ^(double g){ return (BOOL) (g <= omega); }
                            : ^(double g){ return (BOOL) (g >= omega); };

	for (double gamma = alpha; _(gamma); gamma += delta) [re addObject:@(gamma)];
	return re;
}

void     AllColors (void(^block)(int c))    { for (NSNumber *n in NumtoArray(255))  block(n.intValue); }
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

//#import <AQOptionParser/AQOptionParser.h>



- (NSDictionary*) parseArgs:(char*[])argv andKeys:(NSArray*)keys count:(int)argc;

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






static NSArray *codes_fg = nil, *codes_bg = nil, *colors = nil;

/*! Initializes the colors array, as well as the codes_fg and codes_bg arrays, for 256 color mode.
 This method is used when the application is running from within a shell that supports 256 color mode.
 This method is not invoked if the application is running within Xcode, or via normal UI app launch.
 */
__attribute__((constructor)) static void initialize_colors_256() {

  if (codes_fg || codes_bg || colors) return;

  NSMutableArray *m_codes_fg = [NSMutableArray arrayWithCapacity:(256 - 16)];
  NSMutableArray *m_codes_bg = [NSMutableArray arrayWithCapacity:(256 - 16)];
  NSMutableArray *m_colors   = [NSMutableArray arrayWithCapacity:(256 - 16)];

#if MAP_TO_TERMINAL_APP_COLORS

  /*! Standard Terminal.app colors:

   These are the colors the Terminal.app uses in xterm-256color mode.
   In this mode, the terminal supports 256 different colors, specified by 256 color codes.

   The first 16 color codes map to the original 16 color codes supported by the earlier xterm-color mode.
   These are actually configurable, and thus we ignore them for the purposes of mapping,
   as we can't rely on them being constant. They are largely duplicated anyway.

   The next 216 color codes are designed to run the spectrum, with several shades of every color.
   While the color codes are standardized, the actual RGB values for each color code is not.
   Apple's Terminal.app uses different RGB values from that of a standard xterm.
   Apple's choices in colors are designed to be a little nicer on the eyes.

   The last 24 color codes represent a grayscale.

   Unfortunately, unlike the standard xterm color chart,
   Apple's RGB values cannot be calculated using a simple formula (at least not that I know of).
   Also, I don't know of any ways to programmatically query the shell for the RGB values.
   So this big giant color chart had to be made by hand.

   More information about ansi escape codes can be found online.
   http://en.wikipedia.org/wiki/ANSI_escape_code
   */
  // Colors

  m_colors   = [NSMutableArray arrayWithArray:@[
                                                MakeColor( 47,  49,  49), MakeColor( 60,  42, 144), MakeColor( 66,  44, 183), MakeColor( 73,  46, 222), MakeColor( 81,  50, 253), MakeColor( 88,  51, 255), MakeColor( 42, 128,  37), MakeColor( 42, 127, 128), MakeColor( 44, 126, 169), MakeColor( 56, 125, 209), MakeColor( 59, 124, 245), MakeColor( 66, 123, 255), MakeColor( 51, 163,  41), MakeColor( 39, 162, 121), MakeColor( 42, 161, 162), MakeColor( 53, 160, 202), MakeColor( 45, 159, 240), MakeColor( 58, 158, 255), MakeColor( 31, 196,  37), MakeColor( 48, 196, 115), MakeColor( 39, 195, 155), MakeColor( 49, 195, 195), MakeColor( 32, 194, 235), MakeColor( 53, 193, 255), MakeColor( 50, 229,  35), MakeColor( 40, 229, 109), MakeColor( 27, 229, 149), MakeColor( 49, 228, 189), MakeColor( 33, 228, 228), MakeColor( 53, 227, 255), MakeColor( 27, 254,  30), MakeColor( 30, 254, 103), MakeColor( 45, 254, 143), MakeColor( 38, 253, 182), MakeColor( 38, 253, 222), MakeColor( 42, 253, 252), MakeColor(140,  48,  40), MakeColor(136,  51, 136), MakeColor(135,  52, 177), MakeColor(134,  52, 217), MakeColor(135,  56, 248), MakeColor(134,  53, 255), MakeColor(125, 125,  38), MakeColor(124, 125, 125), MakeColor(122, 124, 166), MakeColor(123, 124, 207), MakeColor(123, 122, 247), MakeColor(124, 121, 255), MakeColor(119, 160,  35), MakeColor(117, 160, 120), MakeColor(117, 160, 160), MakeColor(115, 159, 201), MakeColor(116, 158, 240), MakeColor(117, 157, 255), MakeColor(113, 195,  39), MakeColor(110, 194, 114), MakeColor(111, 194, 154), MakeColor(108, 194, 194), MakeColor(109, 193, 234), MakeColor(108, 192, 255), MakeColor(105, 228,  30), MakeColor(103, 228, 109), MakeColor(105, 228, 148), MakeColor(100, 227, 188), MakeColor( 99, 227, 227), MakeColor( 99, 226, 253), MakeColor( 92, 253,  34), MakeColor( 96, 253, 103), MakeColor( 97, 253, 142), MakeColor( 88, 253, 182), MakeColor( 93, 253, 221), MakeColor( 88, 254, 251), MakeColor(177,  53,  34), MakeColor(174,  54, 131), MakeColor(172,  55, 172), MakeColor(171,  57, 213), MakeColor(170,  55, 249), MakeColor(170,  57, 255), MakeColor(165, 123,  37), MakeColor(163, 123, 123), MakeColor(162, 123, 164), MakeColor(161, 122, 205), MakeColor(161, 121, 241), MakeColor(161, 121, 255), MakeColor(158, 159,  33), MakeColor(157, 158, 118), MakeColor(157, 158, 159), MakeColor(155, 157, 199), MakeColor(155, 157, 239), MakeColor(154, 156, 255), MakeColor(152, 193,  40), MakeColor(151, 193, 113), MakeColor(150, 193, 153), MakeColor(150, 192, 193), MakeColor(148, 192, 232), MakeColor(149, 191, 253), MakeColor(146, 227,  28), MakeColor(144, 227, 108), MakeColor(144, 227, 147), MakeColor(144, 227, 187), MakeColor(142, 226, 227), MakeColor(142, 225, 252), MakeColor(138, 253,  36), MakeColor(137, 253, 102), MakeColor(136, 253, 141), MakeColor(138, 254, 181), MakeColor(135, 255, 220), MakeColor(133, 255, 250), MakeColor(214,  57,  30), MakeColor(211,  59, 126), MakeColor(209,  57, 168), MakeColor(208,  55, 208), MakeColor(207,  58, 247), MakeColor(206,  61, 255), MakeColor(204, 121,  32), MakeColor(202, 121, 121), MakeColor(201, 121, 161), MakeColor(200, 120, 202), MakeColor(200, 120, 241), MakeColor(198, 119, 255), MakeColor(198, 157,  37), MakeColor(196, 157, 116), MakeColor(195, 156, 157), MakeColor(195, 156, 197), MakeColor(194, 155, 236), MakeColor(193, 155, 255), MakeColor(191, 192,  36), MakeColor(190, 191, 112), MakeColor(189, 191, 152), MakeColor(189, 191, 191), MakeColor(188, 190, 230), MakeColor(187, 190, 253), MakeColor(185, 226,  28), MakeColor(184, 226, 106), MakeColor(183, 225, 146), MakeColor(183, 225, 186), MakeColor(182, 225, 225), MakeColor(181, 224, 252), MakeColor(178, 255,  35), MakeColor(178, 255, 101), MakeColor(177, 254, 141), MakeColor(176, 254, 180), MakeColor(176, 254, 220), MakeColor(175, 253, 249), MakeColor(247,  56,  30), MakeColor(245,  57, 122), MakeColor(243,  59, 163), MakeColor(244,  60, 204), MakeColor(242,  59, 241), MakeColor(240,  55, 255), MakeColor(241, 119,  36), MakeColor(240, 120, 118), MakeColor(238, 119, 158), MakeColor(237, 119, 199), MakeColor(237, 118, 238), MakeColor(236, 118, 255), MakeColor(235, 154,  36), MakeColor(235, 154, 114), MakeColor(234, 154, 154), MakeColor(232, 154, 194), MakeColor(232, 153, 234), MakeColor(232, 153, 255), MakeColor(230, 190,  30), MakeColor(229, 189, 110), MakeColor(228, 189, 150), MakeColor(227, 189, 190), MakeColor(227, 189, 229), MakeColor(226, 188, 255), MakeColor(224, 224,  35), MakeColor(223, 224, 105), MakeColor(222, 224, 144), MakeColor(222, 223, 184), MakeColor(222, 223, 224), MakeColor(220, 223, 253), MakeColor(217, 253,  28), MakeColor(217, 253,  99), MakeColor(216, 252, 139), MakeColor(216, 252, 179), MakeColor(215, 252, 218), MakeColor(215, 251, 250), MakeColor(255,  61,  30), MakeColor(255,  60, 118), MakeColor(255,  58, 159), MakeColor(255,  56, 199), MakeColor(255,  55, 238), MakeColor(255,  59, 255), MakeColor(255, 117,  29), MakeColor(255, 117, 115), MakeColor(255, 117, 155), MakeColor(255, 117, 195), MakeColor(255, 116, 235), MakeColor(254, 116, 255), MakeColor(255, 152,  27), MakeColor(255, 152, 111), MakeColor(254, 152, 152), MakeColor(255, 152, 192), MakeColor(254, 151, 231), MakeColor(253, 151, 253), MakeColor(255, 187,  33), MakeColor(253, 187, 107), MakeColor(252, 187, 148), MakeColor(253, 187, 187), MakeColor(254, 187, 227), MakeColor(252, 186, 252), MakeColor(252, 222,  34), MakeColor(251, 222, 103), MakeColor(251, 222, 143), MakeColor(250, 222, 182), MakeColor(251, 221, 222), MakeColor(252, 221, 252), MakeColor(251, 252,  15), MakeColor(251, 252,  97), MakeColor(249, 252, 137), MakeColor(247, 252, 177), MakeColor(247, 253, 217), MakeColor(254, 255, 255)]],

  // Grayscale

  [m_colors addObjectsFromArray:@[
                                  MakeColor( 52,  53,  53), MakeColor( 57,  58,  59), MakeColor( 66,  67,  67), MakeColor( 75,  76,  76), MakeColor( 83,  85,  85), MakeColor( 92,  93,  94), MakeColor(101, 102, 102), MakeColor(109, 111, 111), MakeColor(118, 119, 119), MakeColor(126, 127, 128), MakeColor(134, 136, 136), MakeColor(143, 144, 145), MakeColor(151, 152, 153), MakeColor(159, 161, 161), MakeColor(167, 169, 169), MakeColor(176, 177, 177), MakeColor(184, 185, 186), MakeColor(192, 193, 194), MakeColor(200, 201, 202), MakeColor(208, 209, 210), MakeColor(216, 218, 218), MakeColor(224, 226, 226), MakeColor(232, 234, 234), MakeColor(240, 242, 242)]];

  // Color codes

  int index = 16;

  while (index < 256) {
    [m_codes_fg addObject:[NSString stringWithFormat:@"38;5;%dm", index]];
    [m_codes_bg addObject:[NSString stringWithFormat:@"48;5;%dm", index]];

    index++;
  }

#else /* if MAP_TO_TERMINAL_APP_COLORS */

  /*!   Standard xterm colors:

   These are the colors xterm shells use in xterm-256color mode.
   In this mode, the shell supports 256 different colors, specified by 256 color codes.

   The first 16 color codes map to the original 16 color codes supported by the earlier xterm-color mode.
   These are generally configurable, and thus we ignore them for the purposes of mapping,
   as we can't rely on them being constant. They are largely duplicated anyway.

   The next 216 color codes are designed to run the spectrum, with several shades of every color.
   The last 24 color codes represent a grayscale.

   While the color codes are standardized, the actual RGB values for each color code is not.
   However most standard xterms follow a well known color chart,
   which can easily be calculated using the simple formula below.

   More information about ansi escape codes can be found online.
   http://en.wikipedia.org/wiki/ANSI_escape_code
   */

  int index = 16, r = 0, g = 0, b = 0, ri,gi,bi; // increment


  // Calculate xterm colors (using standard algorithm)

  for (ri = 0; ri < 6; ri++) {
    r = (ri == 0) ? 0 : 95 + (40 * (ri - 1));

    for (gi = 0; gi < 6; gi++) {
      g = (gi == 0) ? 0 : 95 + (40 * (gi - 1));

      for (bi = 0; bi < 6; bi++) {
        b = (bi == 0) ? 0 : 95 + (40 * (bi - 1));

        [m_codes_fg addObject:[NSString stringWithFormat:@"38;5;%dm", index]];
        [m_codes_bg addObject:[NSString stringWithFormat:@"48;5;%dm", index]];
        [m_colors addObject:MakeColor(r, g, b)];

        index++;
      }
    }
  }

  // Calculate xterm grayscale (using standard algorithm)

  r = 8;
  g = 8;
  b = 8;

  while (index < 256) {
    [m_codes_fg addObject:[NSString stringWithFormat:@"38;5;%dm", index]];
    [m_codes_bg addObject:[NSString stringWithFormat:@"48;5;%dm", index]];
    [m_colors addObject:MakeColor(r, g, b)];

    r += 10;
    g += 10;
    b += 10;

    index++;
  }

#endif /* if MAP_TO_TERMINAL_APP_COLORS */

  codes_fg = [m_codes_fg copy];
  codes_bg = [m_codes_bg copy];
  colors   = [m_colors   copy];

  NSCAssert([codes_fg count] == [codes_bg count], @"Invalid colors/codes array(s)");
  NSCAssert([codes_fg count] == [colors count],   @"Invalid colors/codes array(s)");
}

#pragma mark - XTERM

int    CUBE_STEPS[] = { 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF };

static RgbColor BASIC16[] = { {  0,   0,   0}, {205, 0,   0}, { 0, 205,   0}, { 205, 205,   0},
  {  0,   0, 238}, {205, 0, 205}, { 0, 205, 205}, { 229, 229, 229},
  {127, 127, 127}, {255, 0,   0}, { 0, 255,   0}, { 255, 255,   0},
  { 92,  92, 255}, {255, 0, 255}, { 0, 255, 255}, { 255, 255, 255} };

static RgbColor  COLOR_TABLE[256];

RgbColor xterm_to_rgb(int x)  { int calc; return

  x <   16 ? BASIC16[x] :  232 <= x && x <= 255 ? (calc = 8 + (x - 232) * 0x0A), (RgbColor){ calc, calc, calc} :
  16 <= x && x <= 231 ? (x -= 16), (RgbColor){ CUBE_STEPS[(x / 36) % 6], CUBE_STEPS[(x / 6) % 6], CUBE_STEPS[x % 6]}
  : BASIC16[0]; // (RgbColor){0, 0, 0};
}

#define sqr(x) ((x) * (x))

int rgb_to_xterm(int r, int g, int b) { /** Quantize RGB values to an xterm 256-color ID */

  int best_match = 0, smallest_distance = 100000000, c, d;

  for (c = 16; c < 256; c++)
    if ((d = sqr(COLOR_TABLE[c].rVal - r) + sqr(COLOR_TABLE[c].gVal - g) + sqr(COLOR_TABLE[c].bVal - b)) < smallest_distance) { smallest_distance = d; best_match = c;
    }
  return best_match;
}

@implementation NSColor (AtoZIO)

- _Void_ getRed:(CGFloat *)rPtr green:(CGFloat *)gPtr blue:(CGFloat *)bPtr {

#if TARGET_OS_IPHONE // iOS

  BOOL done = NO;

  if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
    done = [color getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
  }

  if (!done) {
    // The method getRed:green:blue:alpha: was only available starting iOS 5.
    // So in iOS 4 and earlier, we have to jump through hoops.

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();

    unsigned char pixel[4];
    CGContextRef context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, rgbColorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));

    if (rPtr) *rPtr = pixel[0] / 255.0f;

    if (gPtr) *gPtr = pixel[1] / 255.0f;

    if (bPtr) *bPtr = pixel[2] / 255.0f;

    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
  }

#elif !defined (COCOAPODS_POD_AVAILABLE_CocoaLumberjack_CLI) // OS X with AppKit

  [[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:rPtr green:gPtr blue:bPtr alpha:NULL];

#else /* if TARGET_OS_IPHONE */ // OS X without AppKit

  [self getRed:rPtr green:gPtr blue:bPtr alpha:NULL];

#endif /* if TARGET_OS_IPHONE */
}

/*! Maps the given color to the closest available color supported by the shell. The shell may support 256 colors, or only 16.
 This method loops through the known supported color set, and calculates the closest color.
 The array index of that color, within the colors array, is then returned.
 This array index may also be used as the index within the codes_fg and codes_bg arrays.
 */
+ (NSUInteger) codeIndex {

  CGFloat inR, inG, inB;

  [self getRed:&inR green:&inG blue:&inB fromColor:inColor];

  NSUInteger bestIndex = 0;
  CGFloat lowestDistance = 100.0f;

  NSUInteger i = 0;

  for (NSColor *color in colors) {
    // Calculate Euclidean distance (lower value means closer to given color)

    CGFloat r, g, b;
    [self getRed:&r green:&g blue:&b fromColor:color];

#if CGFLOAT_IS_DOUBLE
    CGFloat distance = sqrt(pow(r - inR, 2.0) + pow(g - inG, 2.0) + pow(b - inB, 2.0));
#else
    CGFloat distance = sqrtf(powf(r - inR, 2.0f) + powf(g - inG, 2.0f) + powf(b - inB, 2.0f));
#endif
    if (distance < lowestDistance) {
      bestIndex = i;
      lowestDistance = distance;
    }
    i++;
  }
  return bestIndex;
}




//- _Void_ clear { scrClear(); }

//- _Void_ setTinta:(Color)tinta { scrSetColors(_tinta = tinta, _papel); }
//- _Void_ setPapel:(Color)papel { scrSetColors(_tinta, _papel = papel); }
//
/**
 Indica los colores del texto a escribir
 @param color Color de la tinta y el papel
 @see scrAttributes
 */
//- _Void_ setAttributes:(scrAttributes)attributes {
//
//  scrSetColorsWithAttr(_attributes = attributes);
//}

/**
 Obtiene los atributos en uso
 @return Los colores como una estructura scrAttributes
 @see scrAttributes
 */
//scrAttributes scrGetCurrentAttributes();

/**
 Obtiene el char en una pos.
 @param La pos. como una estructura scrPosition
 @return El valor entero del char
 @see scrAttributes
 */
//- (int) scrGetCharacterAt:(scrPosition)pos { return scrGetCharacterAt(pos); }

/**
 Mover el cursor a una pos. determinada
 @param fila La fila en la que colocar el cursor
 @param columna La columna en la que colocar el cursor
 */
//- _Void_ moveCursorTo:(NSUInteger)fila column:(NSUInteger) columna {
//
//  scrMoveCursorTo(fila,columna);
//}


//- (scrPosition) cursorPosition { return scrGetCursorPosition(); }

//- _Void_ setCursorPosition:(scrPosition)c {   scrMoveCursorToPos(c); }

//- _Void_ setShowCursor:(BOOL)_ {scrShowCursor(_showCursor = _); }

