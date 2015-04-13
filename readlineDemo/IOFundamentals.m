
#import <AtoZIO/AtoZIO.h>

void usage(void);
void process_args(int ac, char *av[]);
int menu_main();

MAIN({

//  process_args(argc, argv);
  [@"hello" print];

  menu_main();


})


// http://www.cs.swarthmore.edu/~newhall/unixhelp/C_cool_utils.html

/*  getopt: parse command line options */
/* `getopt` is very useful for writing programs that take optional and/or required command line options.
    It can be used to parse command line arguments of the form:

  -o opt_arg  -o  ...

  the man page for getopt has an example (man 3 getopt), 
  also here is an example from one of my programs (it shows one way of handling required command line options):
  
  prints out error message when user tries to run with bad command line args or when user runs with the -h command line arg
*/

void usage(void){
  fprintf(stderr, " usage:\n"
                  "    ./server -p portnum [-h] [-c] [-f configfile] [-n secs]\n"
                  "       -p  portnum:   use portnum as the listen port for server\n"
                  "       -h:            print out this help message\n"
                  "       -c:            run this server deamon in collector-only mode\n"
                  "       -f conf_file:  run w/conf_file instead of /etc/server.config\n"
                  "       -n secs:  how often damon sends its info to peers (default 5)\n\n");
}

void process_args(int ac, char *av[]){

/*  parse command line arguments ac: argc value passed into main av: argv value passed into main
    this function may set the value of global vars based on what command line options are present
*/

  int c, p=0, sleep_secs;  // p is a flag that we set if we get the -p command line option
  char * port_num;

  while(1){
    c = getopt(ac, av, "p:chf:n:");   // "p:"  p option has an arg  "c"  does not

    switch(c){
      case 'h': usage(); exit(0); break;
      case 'p': port_num=optarg; p = 1; break;
//      case 'c': collector_only = 1; break;
//      case 'f': config_file=optarg; break;
      case 'n':
        sleep_secs=atoi(optarg);  // atoi converts a string to an int
        if(sleep_secs <= 0){	    // (ex) atoi("1234") to int 1234
          sleep_secs = 5;
        }
        break;
      case ':': fprintf(stderr, "-%c missing arg\n", optopt);
        usage(); exit(1); break;
      case '?': fprintf(stderr, "unknown arg %c\n", optopt);
        usage(); exit(1); break;
    }
    if(c==-1) break;
  }
  if(!p) {
    fprintf(stderr,"Error: server must be run with command line option -p\n");
    usage();
    exit(1);
  }
}

/*   readline */
/*

int main(int argc, char *argv[]) {

  process_args(argc, argv);
  ...
  An example command line (assuming server is name of executable file):
  $ ./server -p 1288 -c
  readline

  readline is a GNU library for reading in user input. It has support for all kinds of line editing capabilities that the user can use to edit the input line. For example, the user can move the curser to different positions in the line, and modify parts of the input string. See the readline man page and the readline homepage for complete information about the readline library: GNU readline homepage
    One very nice feature of readline is that it mallocs up the space for the returned string. Thus, a program can easily support reading in any sized user input string by simply calling readline. Thus, even if you don't care about any of the line editing features of readline, it is still a handy way to read in user input.

      To use readline, you need to include readline header files and explicitly link with the readline library:

      $ gcc -o myprog  myprog.c -lreadline
      Here is a very simple example program:
*/
/*
//#include <stdlib.h>
//#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>

int main(){

  char* line;

  line = readline("enter a string:  ");  // readline allocates space for returned string
  if(line != NULL) {
    printf("You entered: %s\n", line);
    free(line);   // but you are responsible for freeing the space
  }
}

//  As you run this, type in a line and before you hit ENTER try some of these commands to change the input string:
//  CNTRL-a   move curser to begining of input string
//  CNTRL-e   move curser to end of input string
//  CNTRL-b   move curser back one character
//  CNTRL-f   move curser forward one character
//  CNTRL-d   delete the character under the curser
//  CNTRL-k   kill the string from the curser to the end of the line
//  CNTRL-l   clear the screen and re-print the prompt and input string at the top

*/

/* ncurses */
/*
  ncurses is a library for terminal-independent I/O to character screens. It can be used to create character-based user interfaces to terminal windows.
    See the man page for ncurses for more information. Also, here is an ncurses HOWTO

      To use ncurses library in your program, you need to include the ncurses.h header file, and link in the ncurses library:

      gcc -o myprog myprog.c -lncurses
      Here is a very simple example of printing to the terminal using different colors:
#include <ncurses.h>

      int main(){

        initscr();  // initialize the ternimal in curses mode

        start_color(); // start color mode

        init_pair(1, COLOR_RED, COLOR_BLUE); // define a forground, background pair
        attron(COLOR_PAIR(1));   // enable for/back ground color to use
        printw("Hello World\n"); // print string to curses window
        attroff(COLOR_PAIR(1));
        refresh();               // forces printw output to curses window
        getch();  // just wait for user input

        init_pair(2, COLOR_YELLOW, COLOR_MAGENTA); // another for/background pair
        attron(COLOR_PAIR(2));   // enable for/back ground color to pair # 2
        printw("Hello World\n"); // print string to curses window
        attroff(COLOR_PAIR(2));
        refresh();               // forces printw output to curses window
        getch();  // just wait for user input

        printw("Hello World\n");  // print using default for/backround colors
        refresh();               // forces printw output to curses window
        getch();  // just wait for user input
        
        endwin();  // end curses mode
      }
int main(int argc, const char * argv[]) {
  @autoreleasepool {
      // insert code here...
      NSLog(@"Hello, World!");
  }
    return 0;
}
*/


/* libedit or editline */
/*
  libedit is a replacement or alternative to the GNU readline commandline editing functionality. libedit is released under a BSD style licence, so you can use it in your proprietary code.

I found it difficult to get information on libedit, so I decided to write this page to have a central location for all the information I've found.

Where to get it

The main web site that has the latest version can be found at http://www.thrysoee.dk/editline. This seems to be the location of the most recent version (2.10), though I haven't tested anything past version 2.6. I also found versions at sourceforge (http://sourceforge.net/projects/libedit/ ), but this version is 0.3 and it appears the maintainer simply posted the version and hasn't done any work to update it. I have also found a 1.12 version at http://packages.qa.debian.org/e/editline.htmlwhich implements the readline function, but I haven't been able to compile it (it was made for a 2001 debian system).

libedit vs editline

Editline appears to be the decendent of libedit. In the sourceforge version I've found an implementation of the readline function to provide compatibility with the readline library. Newer versions of libedit don't implement this interface, but still provide much of the same functionality. The man page for libedit is however still referred to as editline.

How to Use libedit

The only documentation comes in a man page without being very informative to how to use it. I was able to piece together a simple program using this man page and code from a package which was developed to use libedit called eltclsh. Most of what I wanted was a history with emacs line editing functionality. Below you will find simple code that sits in a loop and echos the command you entered.
*/

/*
 // cc -g test.c -o test -ledit -ltermcap

 // This will include all our libedit functions.  If you use C++ don't forget to use the C++ extern "C" to get it to compile.
#include <histedit.h>


// To print out the prompt you need to use a function.  This could be made to do something special, but I opt to just have a static prompt.

char * prompt(EditLine *e) {
  return "test> ";
}

int main(int argc, char *argv[]) {

   HistEvent   ev;            // Temp variables
  const char * line;
         int   keepreading = 1,
               count;

//  This holds all the state for our line editor Initialize the EditLine state to use our prompt function and emacs style editing.

  EditLine * el = el_init(argv[0], stdin, stdout, stderr);

  el_set(el, EL_PROMPT, &prompt);
  el_set(el, EL_EDITOR, "emacs");


  History * myhistory;   // This holds the info for our history

  if (!(myhistory = history_init())) return fprintf(stderr, "history could not be initialized\n"), 1;

  history(myhistory, &ev, H_SETSIZE, 800);   // Set the size of the history

  el_set(el, EL_HIST, history, myhistory);   // This sets up the call back functions for history functionality

  while (keepreading) {                      // count is the number of chars. read.

    line = el_gets(el, &count);              // @c line is a `const char*` of our command line WITH the tailing \n

    if (!count) continue;                   // In order to use our history we have to explicitly add commands to the history

    history(myhistory, &ev, H_ENTER, line); printf("You typed \"%s\"\n", line);
  }

  // Clean up our memory
  history_end(myhistory);
  el_end(el);

  return 0;
}

*/


/*
#define USE_TINFO
//#include <test.priv.h>
//#if HAVE_SETUPTERM

#include <time.h>
#include <term.h>
#include <curses.h>

#define valid(s) ((s != 0) && s != (char *)-1)


#if defined(sun) && !defined(_XOPEN_CURSES) && !defined(NCURSES_VERSION_PATCH)
#undef TPUTS_ARG
#define TPUTS_ARG char
extern char *tgoto(char *, int, int);	// available, but not prototyped
#endif

#define CATCHALL(handler) { \
int nsig; \
for (nsig = SIGHUP; nsig < SIGTERM; ++nsig) \
if (nsig != SIGKILL) \
signal(nsig, handler); \
}

#define tparm3(a,b,c) tparm(a,b,c,0,0,0,0,0,0,0)
#define tparm2(a,b)   tparm(a,b,0,0,0,0,0,0,0,0)


static bool interrupted = FALSE;
static long total_chars = 0;
static time_t started;

static int outc(int c)
{
  int rc = c;

  if (interrupted) {
    char tmp = (char) c;
    if (write(STDOUT_FILENO, &tmp, (size_t) 1) == -1)
      rc = EOF;
  } else {
    rc = putc(c, stdout);
  }
  return rc;
}

static bool outs(const char *s){ return valid(s) ? tputs(s, 1, outc), TRUE : FALSE; }

static void cleanup(void) {

  outs(exit_attribute_mode);
  outs(orig_colors) ? (void) nil : outs(orig_pair);
  outs(clear_screen); outs(cursor_normal);
  printf("\n\n%ld total chars, rate %.2f/sec\n", total_chars, ((double)total_chars/(double)time((time_t *) 0) - started));
}

static void onsig(int n) { interrupted = TRUE; }

static double ranf(void) { long r = (rand() & 077777); return ((double) r / 32768.); }

int
main(int argc __unused,
     char *argv[] __unused)
{
  int x, y, z, p;
  double r;
  double c;
  int my_colors;

  CATCHALL(onsig);

  srand((unsigned) time(0));
  setupterm((char *) 0, 1, (int *) 0);
  outs(clear_screen);
  outs(cursor_invisible);
  my_colors = max_colors;
  if (my_colors > 1) {
    if (!valid(set_a_foreground)
        || !valid(set_a_background)
        || (!valid(orig_colors) && !valid(orig_pair)))
      my_colors = -1;
  }

  r = (double) (lines - 4);
  c = (double) (columns - 4);
  started = time((time_t *) 0);

  while (!interrupted) {
    x = (int) (c * ranf()) + 2;
    y = (int) (r * ranf()) + 2;
    p = (ranf() > 0.9) ? '*' : ' ';

    tputs(tparm3(cursor_address, y, x), 1, outc);
    if (my_colors > 0) {
      z = (int) (ranf() * my_colors);
      if (ranf() > 0.01) {
        tputs(tparm2(set_a_foreground, z), 1, outc);
      } else {
        tputs(tparm2(set_a_background, z), 1, outc);
        napms(1);
      }
    } else if (valid(exit_attribute_mode)
               && valid(enter_reverse_mode)) {
      if (ranf() <= 0.01) {
        outs((ranf() > 0.6)
             ? enter_reverse_mode
             : exit_attribute_mode);
        napms(1);
      }
    }
    outc(p);
    fflush(stdout);
    ++total_chars;
  }
  cleanup();
  exit(EXIT_SUCCESS);
}

*/
/// BEGIN MENU BASICS

#include <curses.h>
#include <menu.h>

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
#define CTRLD 	4


#include <menu.h>

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
#define CTRLD 	4

char *choices[] = {
  "Choice 1",
  "Choice 2",
  "Choice 3",
  "Choice 4",
  "Choice 5",
  "Choice 6",
  "Choice 7",
  "Exit",
};

int menu_main() {

  ITEM **my_items;
  int c;
  MENU *my_menu;
  int n_choices, i;
  __unused ITEM *cur_item;

  /* Initialize curses */
  initscr();
  start_color();
  cbreak();
  noecho();
  keypad(stdscr, TRUE);
  init_pair(1, COLOR_RED, COLOR_BLACK);
  init_pair(2, COLOR_GREEN, COLOR_BLACK);
  init_pair(3, COLOR_MAGENTA, COLOR_BLACK);

  /* Initialize items */
  n_choices = ARRAY_SIZE(choices);
  my_items = (ITEM **)calloc(n_choices + 1, sizeof(ITEM *));
  for(i = 0; i < n_choices; ++i)
    my_items[i] = new_item(choices[i], choices[i]);
  my_items[n_choices] = (ITEM *)NULL;
  item_opts_off(my_items[3], O_SELECTABLE);
  item_opts_off(my_items[6], O_SELECTABLE);

  /* Create menu */
  my_menu = new_menu((ITEM **)my_items);

  /* Set fore ground and back ground of the menu */
  set_menu_fore(my_menu, COLOR_PAIR(1) | A_REVERSE);
  set_menu_back(my_menu, COLOR_PAIR(2));
  set_menu_grey(my_menu, COLOR_PAIR(3));

  /* Post the menu */
  mvprintw(LINES - 3, 0, "Press <ENTER> to see the option selected");
  mvprintw(LINES - 2, 0, "Up and Down arrow keys to naviage (F1 to Exit)");
  post_menu(my_menu);
  refresh();

  while((c = getch()) != KEY_F(1))
  {       switch(c)
    {	case KEY_DOWN:
        menu_driver(my_menu, REQ_DOWN_ITEM);
        break;
      case KEY_UP:
        menu_driver(my_menu, REQ_UP_ITEM);
        break;
      case 10: /* Enter */
        move(20, 0);
        clrtoeol();
        mvprintw(20, 0, "Item selected is : %s",
                 item_name(current_item(my_menu)));
        pos_menu_cursor(my_menu);
        break;
    }
  }
  unpost_menu(my_menu);
  for(i = 0; i < n_choices; ++i) free_item(my_items[i]); free_menu(my_menu);
  endwin();
  return 1;
}




/*
char *choices[] = {
  "Choice 1",
  "Choice 2",
  "Choice 3",
  "Choice 4",
  "Exit",
};

int main()
{

   int i, c;   ITEM __unused *cur_item;


  initscr();
  cbreak();
  noecho();
  keypad(stdscr, TRUE);

  int n_choices = ARRAY_SIZE(choices);
  ITEM **my_items = (ITEM **)calloc(n_choices + 1, sizeof(ITEM *));

  for(i = 0; i < n_choices; ++i)
    my_items[i] = new_item(choices[i], choices[i]);
  my_items[n_choices] = (ITEM *)NULL;

  MENU *my_menu = new_menu((ITEM **)my_items);
  mvprintw(LINES - 2, 0, "F1 to Exit");
  post_menu(my_menu);
  refresh();

  while((c = getch()) != KEY_F(1))
    c == KEY_DOWN ? menu_driver(my_menu, REQ_DOWN_ITEM) :
    c == KEY_UP   ? menu_driver(my_menu, REQ_UP_ITEM) : (void)nil;

  free_item(my_items[0]);
  free_item(my_items[1]);
  free_menu(my_menu);
  endwin();
}
*//// supers simple

// END MENU BASICS