void sleep() {
  int i=0;
  while (i < 25000000) i ++;
}

void change_background(char* c) {
  if (++(*c) > 15) *c = 0;
}

void main() {
  char message[] = "Hello World!";
  char* video_memory = 0xB8000;
  char background = 0;
  while (1) {
    for (int i=0; i<sizeof(message); i++) {
      *(video_memory++) = message[i];
      *(video_memory++) = background;
      change_background(&background);
    }
    video_memory = 0xB8000;
    sleep();
  }
}
