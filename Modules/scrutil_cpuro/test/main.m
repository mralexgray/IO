/*  
  CDDIR="/sd/dev/IO/Modules/scrutil_cpuro/test"; \
  clang -o "$CDDIR/test" -fmodules -F $USER_FWKS "$CDDIR/main.m" -std=c11; \
  "$CDDIR/test"

  "$CDDIR/main.m" "$CDDIR/../src/scrutil.m" -I"$CDDIR/../src" -fmodules; \
  aka
    clang -o test main.m ../src/scrutil.m -I../src -fmodules

*/

#import <IO/IO.h>

//#include <stdio.h>
//#include "scrutil.h"

MAIN(
  
    char nombre[255];

    // Iniciar
    scrSetColors(scrYellow, scrBlue);
    scrClear();
//    sleep(1);
    fgets( nombre, 255, stdin );

    scrSetColors(scrBlue, scrRed);
    scrClear();
//    sleep(1);
    fgets( nombre, 255, stdin );

    scrSetColors(scrGreen, scrWhite);

      scrMoveCursorTo( 10, 10 );
      printf( "Tu nombre es %s\n", nombre );

//      scrClear();

//
//    // Mostrar info consola
//    scrShowCursor( true );
//    scrMoveCursorTo( 0, 0 );
//    printf( "scrutil Demo" );
//    scrMoveCursorTo( 5, 10 );
//    printf( "Max Filas: %d\n", scrGetMaxRows() );
//    scrMoveCursorTo( 6, 10 );
//    printf( "Max Columnas: %d\n", scrGetMaxColumns() );
//
//    // Pedir el nombre
//  //    printf( "Introduce tu nombre:" );
//    scrMoveCursorTo( 10, 50 );
    fgets( nombre, 255, stdin );

    // Mostrar el nombre
    scrSetColors( scrYellow, scrRed );
    scrMoveCursorTo( scrGetMaxRows() - 7, 50 );
    printf( "Tu nombre es %s\n", nombre );
    scrShowCursor( false );

    scrSetColors( scrWhite, scrBlack );
    return 0;
)
