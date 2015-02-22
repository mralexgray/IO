
@import AtoZ;
@import AtoZIO;

int main(int argc, const char * argv[]) {

  @autoreleasepool {


    GBOptionsHelper * opts = GBOptionsHelper.new;

    opts.applicationVersion          = ^{ return @"1.0"; };
    opts.applicationBuild            = ^{ return @"100"; };
    opts.printValuesHeader           = ^{ return @"%APPNAME version %APPVERSION (build %APPBUILD)\n"; };
    opts.printValuesArgumentsHeader  = ^{ return @"Running with arguments:\n"; };
    opts.printValuesOptionsHeader    = ^{ return @"Running with options:\n"; };
    opts.printValuesFooter           = ^{ return @"\nEnd of values print...\n"; };
    opts.printHelpHeader = ^{ id x = @"Usage %APPNAME [OPTIONS] [COMMAND [COMMAND OPTIONS]] <arguments separated by space>"; [x setColor:NSColor.redColor]; return [x xString]; };
    opts.printHelpFooter = ^{ return @"\nSwitches that don't accept value can use negative form with --no-<name> or --<name>=0 prefix."; };


    /* registerOptions */
/*
    [opts registerSeparator:@"OPTIONS:".green];

//    REGISTER(opts,  0, GBSettingKeys.printSettings, @"Print settings for current run", GBOptionNoValue);
//    REGISTER(opts,'v', GBSettingKeys.printVersion,  @"Display version and exit",       GBValueNone|GBOptionNoPrint);
//    REGISTER(opts,'?', GBSettingKeys.printHelp,     @"Display this help and exit",     GBValueNone|GBOptionNoPrint);


    [opts registerSeparator:@"COMMANDS:".yellow];

    [opts registerGroup:@"project" description:@"[PROJECT OPTIONS]:" optionsBlock:^(GBOptionsHelper *options) {
      REGISTER(opts,'p', GBSettingKeys.projectName,@"Project name", GBOptionRequiredValue);
      REGISTER(opts,'n', GBSettingKeys.projectVersion, @"Project version", GBOptionRequiredValue);

    }];

    [opts registerGroup:@"path" description:@"[PATH OPTIONS]:" optionsBlock:^(GBOptionsHelper *options) {
      [opts registerOption:'o' long:GBSettingKeys.outputPaths description:@"Output path, repeat for multiple paths" flags:GBOptionRequiredValue];
    }];
*/
    /* REGISTER DONE */

    // Initialize command line parser and register it with all options from helper. Then parse command line.
//    GBCommandLineParser *parser = GBCommandLineParser.new;
//    [parser registerSettings:settings];
//    [parser registerOptions:opts];
//
    // parseOptionsWithArguments:argv count:argc]) {
//    if (![parser parse]) return gbprintln(@"Errors in command line parameters!".blue), [opts printHelp], 1;

    // NOTE: from here on, you can forget about GBOptionsHelper or GBCommandLineParser and only deal with GBSettings...

    // Print help or version if instructed - print help if there's no cmd line argument also...
//    return  settings.printHelp || argc == 1 ? [opts printHelp],                        0 :
//    settings.printVersion           ? [opts printVersion],                     0 :
//    settings.printSettings          ? [opts printValuesFromSettings:settings], 0 : 0; // Print settings if necessary.


    [AtoZIO.exePath echo];

    [AtoZIO readWithPrompt:@"Press return to clear console!"];

//    [[@"ArcgV is: " /stringByAppendingFormat:@"%c",_NSGetArgv()] echo];

    [[@"ArcgC is: " stringByAppendingFormat:@"%d",*_NSGetArgc()] echo];

    id z = @"DO YOU LIKE?";
    [z setColor:[RED withBG:WHITE]];
    id answer = @"None Yet!";
    for (NSC* x in [RANDOMPAL withMaxItems:5]) { // NSCL.namedColors) {

      [[x.name paddedTo:AtoZIO.terminal_width] printInColor:[x withBG:x.muchDarker]];
      answer = [AtoZIO readWithPrompt:z];

    }

    [AtoZIO clearConsole];
//    describeEnv  [AtoZ sharedInstance];
//    XX(rgb_to_xterm(3,4,255));
//    XX(nsColor_to_xterm(RED));
//    XX(nsColor_to_xterm(BLUE));

    PrintInClr("System colors:\n\n", 2); // NO
//      System16 ();
//    ClrPlus("\n");// NO
//  ClearScr();
//  printf("\x1b[0m\n\nGrey Scale:\n\n");
//    SystemGrays();

//  AZSizer * x = [AZSizer forQuantity:256 inRect:(NSRect){0,0,AtoZ.terminal_width,AtoZ.terminal_height}];
//  [x.rects eachWithIndex:^(id obj, NSInteger idx) {


//    AllColors(^(int c){  FillScreen(c); reset_cursor(); });


//        PrintInRnd(@"well, hello:%@\n", x);// nsColor_to_xterm(x));
//  }



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
