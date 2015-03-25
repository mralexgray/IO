/*    Manejo de la consola */

#include "scrutil.h"
//#include <string.h>
//#include <stdio.h>

#import <AtoZIO/AtoZIO.h>


/* Detectar el sistema operativo */
#define SO_UNIX
// Commands
static const short int MaxCmdBuffer = 32;
/// Caracts. por el que empiezan todos los comandos
static const char *CSI = "\33[",
       *CmdClearScreen = "2J";
static char cmd[MaxCmdBuffer];

// Colors
/// Colores para la tinta
static NSArray *cmdUnixInkColors, *cmdUnixPaperColors;

//  char cmdUnixInkColors[scrUndefinedColor + 1][MaxCmdBuffer];
/// Colores para el fondo
//static char cmdUnixPaperColors[scrUndefinedColor + 1][MaxCmdBuffer];
/// Max. filas en pantalla
static const short int UnixLastLine = 25, UnixLastColumn = 80;

static void initUnixColors()
/**
    Linux sigue los códigos de control ANSI que comienzan con
    ESC, y con ellos se puede limpiar la pantalla, cambiar los colores, ...
*/
{
//  sprintf(cmdUnixInkColors[scrBlack], "%s%s", CSI, "30m");
//  sprintf(cmdUnixInkColors[scrBlue], "%s%s", CSI, "34m");
//  sprintf(cmdUnixInkColors[scrRed], "%s%s", CSI, "31m");
//  sprintf(cmdUnixInkColors[scrMagenta], "%s%s", CSI, "35m");
//  sprintf(cmdUnixInkColors[scrGreen], "%s%s", CSI, "32m");
//  sprintf(cmdUnixInkColors[scrCyan], "%s%s", CSI, "36m");
//  sprintf(cmdUnixInkColors[scrYellow], "%s%s", CSI, "93m");
//  sprintf(cmdUnixInkColors[scrWhite], "%s%s", CSI, "37m");
//  sprintf(cmdUnixInkColors[scrUndefinedColor], "%s%s", CSI, "30m");
//
//$(@"%s%s", CSI, "40m");
//  sprintf(cmdUnixPaperColors[scrBlue], "%s%s", CSI, "44m");
//  sprintf(cmdUnixPaperColors[scrRed], "%s%s", CSI, "41m");
//  sprintf(cmdUnixPaperColors[scrMagenta], "%s%s", CSI, "45m");
//  sprintf(cmdUnixPaperColors[scrGreen], "%s%s", CSI, "42m");
//  sprintf(cmdUnixPaperColors[scrCyan], "%s%s", CSI, "46m");
//  sprintf(cmdUnixPaperColors[scrYellow], "%s%s", CSI, "103m");
//  sprintf(cmdUnixPaperColors[scrWhite], "%s%s", CSI, "47m");
//  sprintf(cmdUnixPaperColors[scrUndefinedColor], "%s%s", CSI, "40m");

  cmdUnixInkColors = @[ $(@"%s%s", CSI, "30m"),
                        $(@"%s%s", CSI, "34m"),
                        $(@"%s%s", CSI, "31m"),
                        $(@"%s%s", CSI, "35m"),
                        $(@"%s%s", CSI, "32m"),
                        $(@"%s%s", CSI, "36m"),
                        $(@"%s%s", CSI, "93m"),
                        $(@"%s%s", CSI, "37m"),
                        $(@"%s%s", CSI, "30m")];

cmdUnixPaperColors = @[ $(@"%s%s", CSI, "40m"),
                        $(@"%s%s", CSI, "44m"),
                        $(@"%s%s", CSI, "41m"),
                        $(@"%s%s", CSI, "45m"),
                        $(@"%s%s", CSI, "42m"),
                        $(@"%s%s", CSI, "46m"),
                        $(@"%s%s", CSI, "103m"),
                        $(@"%s%s", CSI, "47m"),
                        $(@"%s%s", CSI, "40m")];
}

static scrAttributes libAttrs;
static bool inited = false;

static inline void scrInit() {

  if (inited) return;
  initUnixColors();
  libAttrs.ink    = scrBlack;
  libAttrs.paper  = scrWhite;
  inited = true;
}

void scrClear() {

  scrInit();
  strcpy(cmd, CSI);
  strcat(cmd, CmdClearScreen);
  printf("%s", cmd);
  scrMoveCursorTo(0, 0);
}

void scrSetColorsWithAttr(scrAttributes colors) {

  scrInit();
  libAttrs.paper = colors.paper;
  libAttrs.ink = colors.ink;

  printf("%s%s", [cmdUnixInkColors[colors.ink] UTF8String],
               [cmdUnixPaperColors[colors.paper]UTF8String]);
}

void scrSetColors(scrColor tinta, scrColor papel) {

    scrSetColorsWithAttr((scrAttributes){papel, tinta});
}

void scrMoveCursorToPos(scrPosition pos) {
  scrMoveCursorTo(pos.row, pos.column);
}

void scrMoveCursorTo(NSUInteger fila, NSUInteger columna) {
  scrInit();

  printf("%s%lu;%luH", CSI, fila + 1, columna + 1);
}

scrPosition scrGetConsoleSize() {
  scrPosition pos;

  pos.row = pos.column = -1;
  scrInit();

  pos.row = UnixLastLine;
  pos.column = UnixLastColumn;
  return pos;
}

scrAttributes scrGetCurrentAttributes() { return scrInit(), libAttrs; }

unsigned short int scrGetMaxRows()      { return scrGetConsoleSize().row; }

unsigned short int scrGetMaxColumns()   { return scrGetConsoleSize().column; }

scrPosition scrGetCursorPosition() {

  scrPosition toret;

  scrInit();
  memset(&toret, 0, sizeof(scrPosition));
  toret.row    = -1;
  toret.column = -1;

  return toret;
}

void scrShowCursor(bool see) { scrInit(); printf("%s?25%c", CSI, see ? 'h' : 'l'); }
