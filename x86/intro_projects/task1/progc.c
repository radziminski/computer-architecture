#include <stdio.h>

extern char *removerng(char *s, char a, char b);

int main(int argc, char *argv[])
{
  char input[] = "1234";
  char *output = NULL;
  if (argc != 3) printf("Wrong number of input arguments.\nPlease enter 2 characters.");
  else {
	  printf("Input string: %s\n", input);
	  output = removerng(input, argv[1][0], argv[2][0]);
	  printf("After reverse: %s\n", output);
	}
  return 0;
}
