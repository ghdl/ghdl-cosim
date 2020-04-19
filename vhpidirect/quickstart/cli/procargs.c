#include <stdio.h>
#include <string.h>
#include <malloc.h>

extern int ghdl_main(int argc, void** argv);

int main(int argc, void** argv) {

  printf("Hello procargs!\n");

  int gargc = argc+1;
  char** gargv = malloc(gargc*sizeof(char*));

  gargv[0] = malloc((strlen(argv[0])+1)*sizeof(char));
  strcpy(gargv[0], argv[0]);

  if (argc > 1) {

    printf("Has args\n", argc);

    gargv[1] = malloc((strlen(argv[1])+1)*sizeof(char));
    strcpy(gargv[1], argv[1]);

    gargv[2] = "-ggenStr=A CLI arg was provided";

    gargc = 3;

  } else {

    printf("No args!\n");

    gargv[1] = "-ggenStr=No CLI args were provided";

    gargc = 2;

  }

  printf("Call ghdl_main...\n");
  ghdl_main(gargc, (void**)gargv);

}
