#include <stdio.h>

extern char *removenth(char *s, int n);

int main(int argc, char *argv[])
{
  char input[] = "abc 1234 xyz";
  char *output = NULL;
  int n = argv[1][0] - '0';
  if (argc != 2) printf("Wrong number of input arguments.\nPlease enter 1 number.");
  else {
	  printf("Input string: %s\n", input);
	  output = removenth(input, n);
	  printf("After reverse: %s\n", output);
	}
  return 0;
}
