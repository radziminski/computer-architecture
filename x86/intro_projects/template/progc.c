#include <stdio.h>

extern char *funcName(char *s);

int main(int argc, char *argv[])
{
  char input[] = "here goes string";
  char *output = NULL;
  if (argc != 2) printf("Wrong number of input arguments.\nPlease enter ...");
  else {
	  printf("input string: %s\n", input);
	  output = funcName(input);
	  printf("output string: %s\n", output);
	}
  return 0;
}
