#include <stdio.h>
char *s = "#include <stdio.h>%cchar *s = %c%s%c; int main(void){ printf( s, 10, 34, s, 34 );return 0; }"; int main(void){ printf( s, 10, 34, s, 34 );return 0; }