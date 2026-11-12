#include <errno.h>
#include <signal.h>
#include <spawn.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>

extern char **environ;

static pid_t child;

static void forward_signal(int signal_number) {
  if (child > 0) kill(child, signal_number);
}

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: drive-access program [args...]\n");
    return 64;
  }

  int forwarded[] = {SIGTERM, SIGINT, SIGHUP, SIGQUIT, SIGUSR1, SIGUSR2};
  for (size_t i = 0; i < sizeof forwarded / sizeof forwarded[0]; i++) signal(forwarded[i], forward_signal);

  int spawn_error = posix_spawnp(&child, argv[1], NULL, NULL, &argv[1], environ);
  if (spawn_error != 0) {
    fprintf(stderr, "drive-access: %s: %s\n", argv[1], strerror(spawn_error));
    return 127;
  }

  int status;
  while (waitpid(child, &status, 0) < 0) {
    if (errno != EINTR) return 1;
  }
  if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
  return WEXITSTATUS(status);
}
