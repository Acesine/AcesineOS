void main() {
  char background = 0x0C;
  char message[] = "Welcome!";
  char* video_memory = 0xB8000;
  for (int i=0; i<sizeof(message); i++) {
    *(video_memory++) = message[i];
    *(video_memory++) = background;
  }
}
