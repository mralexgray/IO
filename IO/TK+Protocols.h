
#pragma once

@import AtoZUniversal;

@Vows IO_Helper <NObj>
+ _Kind_ shared ___
￭
@Vows          IO_Opts @Optn  // Public interface to IO options parsing methods.

_RC  _Dict    getOpts ___
_RO  _IsIt  wantsHelp ___
_RC  _Text       help ___
_RO  mDict      rules ___

_VD getOpt __Text_ usageThenKeyThenShortOpts __ ... ___

_VD finalize ___

_VD   test __List_ args ___

￭

@Vows         IO_Edit @Optn  // Public interface to IO options parsing methods.

_NA _Text historyLoadPath
__        historySavePath
___
_AT _List    history ___

_VD saveHistory ___

_VD setCompletionHandler _ (_List(^)(_Text input))comps;

_VD prompt __Text_ promt withBlock _ (_IsIt(^)(_Text line))cmd ___   /// AKA RUN!

_VD clearScreen ___
_VD printKeyCodes ___
￭

#define Ⅲ JREnumDeclare

Ⅲ ( ioEnv, io_UNSET      = 0,
            io_TTY        = 0x00000001,
            io_XCODE      = 0x00000010,
            io_ASL        = 0x00000100,
            io_COLOR      = 0x00001000,
            io_OTHER      = 0x11111111,

            io_CLR_XC     = 0x00001010,
            io_CLR_TTY    = 0x00001001    )

_Type struct { _UInt  col ___ _UInt    row ___ } _Cell ___
_Type struct { _SInt argc ___ _Char * argv ___ } _Main ___

#define _BICOLOR_ _Ｐ(Bicolor)
#define _REAL @concrete

_PRTO Bicolor < IndexSet,     // id x = @"Apple"[2];      x == @"Apple" with fg -> 2/256
                  KeyGet >    // id x = @"Apple"[ORANGE]; x == @"Apple" with fg -> ORANGE
_REAL
_RO _IsIt      colored ___
_RC _Text      ioString
            __ escape
           ___                 // ansi esaped "string"
_AT _ObjC      fclr
            __ bclr ___            // NS/UIColor or 0-255

- _BICOLOR_ withFG _ f ___
- _BICOLOR_ withBG _ b ___

￭

@Xtra (Text, IO_Text) <Bicolor>

- _Void_ print256 ___
+ _Text_ withColor _ c fmt __Text_ fmt,... ___

￭

@class   AVAudioPlayer;

#define MID(X,MINI,MAXI) MAX( MIN(X,MAXI), MINI )
/*! Documentation 
 */
@Kind (ProgressBar)

_NA _UInt          max __
                 value __
                 steps __
                  step ___
_RO _SInt        start ___ // time progressbar was started
_NA _Text        label ___
_RO _Text progress_str ___ // the progress bar stored as text
_RO _List       format ___ // E.g. |###    | has @[@"|", @"#", @"|"]

- _Void_ increment ___
- _Void_    finish ___

- initWithLabel _ _Text_ words
            max _ _UInt_ numSteps ___

/*! @param fmt Format strings are three-character strings indicating the left bar, fill, and right bar (in that order). 
                For example, "(.)" would result in a progress bar like "(...........)". */
- initWithLabel _ _Text_ words
            max _ _UInt_ numSteps
         format _ _Text_ fmt ___

_RO  int last_printed ___ // number of characters printed on last output
￭

// IO_Protocol_h

/*

#define IO_MAIN int main(int argc, const char **argv

_PRTO CLIDelegate ____ NObj _____

@Optn
-   _Text_ optForMethod _ _Meth_ s ___   // Otherwise it is the moethod's first letter.
_RO _Meta optionClass ___     // Otherwise it's YOU!
_RO _List optionMethods ___   // if present, will only opt out these methods.

_REAL
_RC _List _options ___
_RC _Text _usage ___

￭
   _RO _Char** argv _ && _RO _SInt * argc ___

 #import <IO/GBCommandLineParser.h>     // GBCli
 ___ @Incl Darwin ___

*/