/*  
  CDDIR="/sd/dev/AtoZIO/Modules/scrutil_cpuro/test"
  clang -o "$CDDIR/test" "$CDDIR/main.m" "$CDDIR/../src/scrutil.m" -I"$CDDIR/../src" -fmodules
  ".$CDDIR/test"

  aka
    clang -o test main.m ../src/scrutil.m -I../src -fmodules

*/

#include <stdio.h>
#include "scrutil.h"

int main()
{
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

    scrSetColors(scrBlue, scrYellow);
    scrClear();

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
//    scrMoveCursorTo( 10, 10 );
//    printf( "Introduce tu nombre:" );
//    scrMoveCursorTo( 10, 50 );
    fgets( nombre, 255, stdin );

    // Mostrar el nombre
    scrSetColors( scrYellow, scrRed );
    scrMoveCursorTo( scrGetMaxRows() - 7, 50 );
    printf( "Tu nombre es %s\n", nombre );
    scrShowCursor( false );

    scrSetColors( scrWhite, scrBlack );
    return 0;
}
