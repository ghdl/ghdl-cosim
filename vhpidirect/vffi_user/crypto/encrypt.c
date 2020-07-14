#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>

void handleErrors(void) {
  ERR_print_errors_fp(stderr);
  abort();
}

int encrypt(
  unsigned char *plaintext,
  unsigned char *key,
  unsigned char *ciphertext,
  int plaintext_len
) {
  EVP_CIPHER_CTX *ctx;
  int len;
  int ciphertext_len;
  // Create and initialise the context
  if(!(ctx = EVP_CIPHER_CTX_new()))
      handleErrors();
  // Initialise the encryption operation, no IV needed in ECB mode
  if(1 != EVP_EncryptInit_ex(ctx, EVP_aes_128_ecb(), NULL, key, NULL))
      handleErrors();
  // We don't want padding
  if(1 != EVP_CIPHER_CTX_set_padding(ctx, 0))
    handleErrors();
  // Provide the message to be encrypted, and obtain the encrypted output
  if(1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len))
      handleErrors();
  ciphertext_len = len;
  //  Finalise the encryption. No further bytes are written as padding is switched off
  if(1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
      handleErrors();
  ciphertext_len += len;
  // Clean up
  EVP_CIPHER_CTX_free(ctx);
  return ciphertext_len;
}
