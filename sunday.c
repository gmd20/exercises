#include <stdint.h>
#include <stdio.h>
#include <string.h>

// http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/sundayen.htm
// http://www-igm.univ-mlv.fr/~lecroq/string/
// http://www-igm.univ-mlv.fr/~lecroq/string/node19.html#SECTION00190

const int ASIZE = 256;
void sunday_prepare(const char * str2, uint8_t shift_table[ASIZE]) {
  const uint8_t *x = (const uint8_t*)str2;
  int m = strlen(str2);
  int i;

  for (i = 0; i < ASIZE; i++) {
    shift_table[i] = m + 1;
  }
  for (i = 0; i < m; i++) {
    shift_table[x[i]] = m - i;
    // printf("%c = %d\n", x[i], m - i);
  }
}

// 1. shift_table should be prepared using sunday_pre(str2, shift_table);
// 2. len(str2) < 255(max uint8_t)
char * sunday_strstr(const char * str1, const char * str2, uint8_t shift_table[ASIZE]) {
  const uint8_t *x = (const uint8_t *)str2;
  const uint8_t *y = (const uint8_t *)str1;
  int m = strlen(str2);
  int n = strlen(str1);
  int i = 0;

  while (i + m <= n) {
    // printf("i = %d\n", i);
    if (memcmp(x, y + i, m) == 0) {
      return (char *)&y[i];
    }
    i += shift_table[y[i+m]];
  }

  return NULL;
}

void main()
{
  const char *y = "aabacdedf";
  const char *x[] = {"ac", "de", "f", "df", "acd", "a", "aa"};
  char table[256];
  char *p;

  int i = 0;

  printf("\t\t%s\n",  y);
  for (i = 0; i < sizeof(x)/sizeof(char *); i++) {
    sunday_prepare(x[i], table);
    p = sunday_strstr(y, x[i], table);
    if (p != NULL) {
      printf("%d\t%s\t%s\n", i, x[i], p);
    } else {
      printf("%d\t%s\n", i, x[i]);
    }
  }
}
