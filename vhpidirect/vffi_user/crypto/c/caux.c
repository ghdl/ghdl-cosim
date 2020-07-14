#include <assert.h>
#include <stdio.h>

#include <vffi_user.h>

extern int encrypt(
  unsigned char *plaintext,
  unsigned char *key,
  unsigned char *ciphertext,
  int plaintext_len
);

void cryptData(
  char* din,
  char* key,
  char* dout,
  int blen
) {
  int crypt_len;
  unsigned char c_din[blen];
  unsigned char c_key[blen];
  unsigned char c_dout[blen];

  vfficharArr2bitArr(din, c_din, blen);
  vfficharArr2bitArr(key, c_key, blen);

  crypt_len = encrypt(c_din, c_key, c_dout, blen);

  printf("crypt_len : %d\n", crypt_len);
  assert(crypt_len == blen);

  vffibitArr2charArr(c_dout, dout, blen);
}
