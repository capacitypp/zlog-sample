CC=gcc -Wall

.c.o:
	$(CC) $(CFLAGS) -c $<

all: sample

sample: sample.o
	$(CXX) -o $@ $^ -lzlog

clean:
	rm -f sample
	rm -f *.o
	rm -f *.gch
	rm -f *.dat
	rm -f *.so

