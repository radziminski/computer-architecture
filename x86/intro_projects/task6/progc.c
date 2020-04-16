#include <stdio.h>

extern char *leaverng(char *s, char a, char b);

int main(int argc, char *argv[])
{
  char input[] = "here goes string";
  char *output = NULL;
  if (argc != 3) printf("Wrong number of input arguments.\nPlease enter ...");
  else {
	  printf("input string: %s\n", input);
	  output = leaverng(input, *argv[1], *argv[2]);
	  printf("output string: %s\n", output);
	}
  return 0;
}
