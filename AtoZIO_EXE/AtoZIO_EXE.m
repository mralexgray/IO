
#import <AtoZIO.h>
@import AtoZ;

int main(int argc, const char * argv[]) {
  @autoreleasepool {

//describeEnv  [AtoZ sharedInstance];
// [AtoZIO.IO readWithPrompt:@"Press return to clear console!"];
//  [AtoZIO.IO clearConsole];
//  XX(rgb_to_xterm(3,4,255));
//  XX(nsColor_to_xterm(RED));
//  XX(nsColor_to_xterm(BLUE));

  PrintInClr("System colors:\n\n", 2);
//  System16 ();
  ClrPlus("\n");
//  ClearScr();
  printf("\x1b[0m\n\nGrey Scale:\n\n");
//  SystemGrays();

//  AZSizer * x = [AZSizer forQuantity:256 inRect:(NSRect){0,0,AtoZ.terminal_width,AtoZ.terminal_height}];
//  [x.rects eachWithIndex:^(id obj, NSInteger idx) {


    AllColors(^(int c){  FillScreen(c); reset_cursor(); });

    for (NSC* x in NSCL.namedColors) {

        [[NSS withColor:[x withBG:x.muchDarker] fmt:@"well, hello:%@\n",[x name]] xPrint];

//        PrintInRnd(@"well, hello:%@\n", x);// nsColor_to_xterm(x));
  }
      


//  printf("\n\x1b[0m\nOther Colors:\n\n");
//  [[@1000 to:@1100] do:^(id obj) {  print i, unichr(i)
//

  [NSS.dicksonisms do:^(id x){  PrintInRnd(x); }];

//  }
//void PrintRandomColor(int count) { }

  //    for(color = 0; color < 8; color++) {     printf("\x1b[48;5;%dm  ",color); } printf("\x1b[0m\n");   // for(color =
  //    8; color < 16; color++) {     printf("\x1b[48;5;%dm  ",color); }


  }
    return 0;
}
