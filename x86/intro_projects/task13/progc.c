#include <stdio.h>

extern char *replnum(char *s, char a);

int main(int argc, char *argv[])
{
  char input[] = "123a123 here 12asdas34 goes 123 string 15432";
  char *output = NULL;
  if (argc != 2) printf("Wrong number of input arguments.\nPlease enter 1 character.");
  else {
	  printf("input string: %s\n", input);
	  output = replnum(input, *argv[1]);
	  printf("output string: %s\n", output);
	}
  return 0;
}
