
@import Darwin; @import AVFoundation.AVAudioPlayer;

#define _BICOLOR_ (P(Bicolor))

_PRTO Bicolor <IndexSet,  // id x = @"Apple"[2];      x == @"Apple" with fg -> 2/256
                 KeyGet>  // id x = @"Apple"[ORANGE]; x == @"Apple" with fg -> ORANGE
@concrete

_P  _ObjC fclr, bclr; // NS/UIColor or 0-255
_RO _IsIt colored;
_RC _Text x, escape;  // ansi esaped "string"

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


#define MID(X,MINI,MAXI) MAX( MIN(X,MAXI), MINI )


 //  _RO _Char** argv _ && _RO _SInt * argc _

