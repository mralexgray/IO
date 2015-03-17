
@import AtoZUniversal;
@import Darwin;
@import AVFoundation.AVAudioPlayer;

#define _BICOLOR_ (id<Bicolor>)

_PRTO Bicolor <IndexSet,  // id x = @"Apple"[2];      x == @"Apple" with fg -> 2/256
                 KeyGet>  // id x = @"Apple"[ORANGE]; x == @"Apple" with fg -> ORANGE
@concrete

@prop_      _ObjC fclr, bclr; // NS/UIColor or 0-255
@prop_RO    _IsIt colored;
@prop_RC    _Text x, escape;  // ansi esaped "string"

- _BICOLOR_ withFG:_;
- _BICOLOR_ withBG:_;

_FINI

_IFCE Text (AtoZIO) <Bicolor>

- _Void_ print256;
+ _Text_ withColor:_ fmt: _Text_ fmt,...;

_FINI

_PRTO CLIDelegate <NObj> @optional

- _Text_ optForMethod:(SEL)_;   // Otherwise it is the moethod's first letter.
@prop_RO _Meta optionClass;     // Otherwise it's YOU!
@prop_RO _List optionMethods;   // if present, will only opt out these methods.
@concrete
@prop_RC _List _options;
@prop_RC _Text _usage;
@end


#define MID(X,MINI,MAXI) MAX( MIN(X,MAXI), MINI )
