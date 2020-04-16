#include <stdio.h>

extern char *remlastnum(char *s);

int main(int argc, char *argv[])
{
  char input[] = "1234a1234b";
  char *output = NULL;
	printf("input string: %s\n", input);
	output = remlastnum(input);
	printf("output string: %s\n", output);
  return 0;
}
