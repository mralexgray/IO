
#include <curses.h>

/*!  ∂i!!(1)/a2z/screenshots/sel.c.menu.pngƒi*/

struct menu{
  char names[10][10];
  int pos;
};

struct menu initMenu(char names[10][10]){

  struct menu ret;
  for(int i = 0; i < 10; i++)
    for(int j = 0; j < 10; j++)
      ret.names[i][j] = names[i][j];
      ret.pos = 0;
      return ret;
}

void renderMenu(struct menu input, int y, int x){
  clear();
  for(int i = 0; i < 10; i++){

    if(i != input.pos) mvprintw(y + i, x, input.names[i]);

    attron(A_BOLD);
    mvprintw(y + i, x, input.names[i]);
    attroff(A_BOLD);
  }
  refresh();
}

int main(){
  char names[10][10]={
    {"First    "},
    {"Second   "},
    {"Third    "},
    {"Fourth   "},
    {"Fifth    "},
    {"Sixth    "},
    {"Seventh  "},
    {"Eighth   "},
    {"Nineth   "},
    {"Tenth    "}
  };
  struct menu myMenu = initMenu(names);
  char in;

  initscr();
  raw();
  keypad(stdscr, TRUE);
  noecho();
  curs_set(0);

  while(in != '-'){
    in = getch();
    switch(in){
      case 'w' : myMenu.pos -= 1;
        break;
      case 's' : myMenu.pos += 1;
        break;
    }
    renderMenu(myMenu, 1, 1);
  }
  endwin();
}

/*
#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <ncurses.h>

char *read_line(FILE *stream);

int main(int argc, char *argv[])
{
	char *line;
	char *lines[20];
	int is_selected[20] = {0};
	int num_lines = 0;
	int i;
	int ch;
	int pos = 0, last_pos = 0;
	
	// read menu entries
	while ((line = read_line(stdin)) != NULL)
		lines[num_lines++] = line;

	freopen("/dev/tty", "r", stdin);
	initscr();
	cbreak();
	noecho();
	keypad(stdscr, TRUE);

	for (i = 0; i < num_lines; i++)
		printw("   %s", lines[i]);
	refresh();

	do {
		mvchgat(last_pos, 0, -1, A_NORMAL, 0, NULL);
		mvchgat(pos, 0, -1, A_REVERSE, 0, NULL);
		move(pos, 1);
		refresh();

		last_pos = pos;

		ch = getch();
		switch (ch) {
		case KEY_UP:
			pos--;
			if (pos < 0) pos = num_lines - 1;
			break;
		case KEY_DOWN:
			pos++;
			if (pos >= num_lines) pos = 0;
			break;
		case ' ':
			is_selected[pos] = 1 - is_selected[pos];
			mvprintw(pos, 1, is_selected[pos] ? "*" : " ");
			break;
		}
	} while (ch != 'q' && ch != '\n');

	endwin();

	for (i = 0; i < num_lines; i++)
		if (is_selected[i])
			fputs(lines[i], stderr);

	for (i = 0; i < num_lines; i++)
		free(lines[i]);

	return 0;
}

char *read_line(FILE *stream)
{
	char *line = NULL;
	size_t buffer_len = 0;
	
	ssize_t len = getline(&line, &buffer_len, stream);

	if (len == -1) {
		free(line);
		return NULL;
	} else {
		return line;
	}
}
*/