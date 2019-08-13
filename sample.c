#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

#include <zlog.h>

zlog_category_t *c;

void sig_handler(int signo) {
	if (signo == SIGINT) {
		zlog_fini();
		exit(0);
	}
}

int main(int argc, char** argv)
{
	int rc = zlog_init("test_hello.conf");
	if (rc) {
		fprintf(stderr, "init failed\n");
		return 1; 
	}

	c = zlog_get_category("my_cat");
	if (!c) {
		fprintf(stderr, "get cat fail\n");
		zlog_fini();
		return 2; 
	}

	if (signal(SIGINT, sig_handler) == SIG_ERR) {
		zlog_error(c, "Can't set signal handler\n");
		zlog_fini();
		return 3;
	}

	while (1) {
		zlog_info(c, "This is info output.");
		zlog_warn(c, "This is warning output.");
		zlog_error(c, "Variable %s should be %d.", "result", 5);
		sleep(1);
	}
	zlog_fini();

	return 0; 
} 
