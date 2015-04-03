

@import Darwin; @import AVFoundation.AVAudioPlayer;
#import <AtoZIO/GBCommandLineParser.h>     // GBCli


_Type struct { _SInt argc; _Char * argv; } _Main _

#define _BICOLOR_ (P(Bicolor))

_PRTO Bicolor <IndexSet,  // id x = @"Apple"[2];      x == @"Apple" with fg -> 2/256
                 KeyGet>  // id x = @"Apple"[ORANGE]; x == @"Apple" with fg -> ORANGE
@concrete

_P  _ObjC fclr, bclr; // NS/UIColor or 0-255
_RO _IsIt colored;
_RC _Text ioString, escape;  // ansi esaped "string"

- _BICOLOR_ withFG:__ _
- _BICOLOR_ withBG:__ _

￭

@Xtra (Text, AtoZIO) <Bicolor>

- _Void_ print256;
+ _Text_ withColor:__ fmt:_Text_ fmt,...;

￭

@Vows CLIDelegate <NObj> @optional

- _Text_ optForMethod:(SEL)__ _   // Otherwise it is the moethod's first letter.
_RO _Meta optionClass;     // Otherwise it's YOU!
_RO _List optionMethods;   // if present, will only opt out these methods.
@concrete
_RC _List _options;
_RC _Text _usage;

￭

 //  _RO _Char** argv _ && _RO _SInt * argc _

#define MID(X,MINI,MAXI) MAX( MIN(X,MAXI), MINI )


@Kind (ProgressBar)

_NA _UInt max, value, steps, step _
_RO _SInt start                   _ // time progressbar was started
_NA _Text label                   _
_RO _Text progress_str            _ // the progress bar stored as text
_RO _List format                  _ // E.g. |###    | has @[@"|", @"#", @"|"]

- _Void_ increment                _
- _Void_ finish                   _

- initWithLabel:_Text_ words
            max:_UInt_ numSteps   _

/*! @param fmt Format strings are three-character strings indicating the left bar, fill, and right bar (in that order). 
                For example, "(.)" would result in a progress bar like "(...........)". */
- initWithLabel:_Text_ words
            max:_UInt_ numSteps
         format:_Text_ fmt;

_RO  int last_printed; // number of characters printed on last output
￭
