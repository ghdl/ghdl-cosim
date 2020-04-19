extern int wrapper(int argc, void** argv);

int main(int argc, void** argv) {
  return wrapper(argc, argv);
}
