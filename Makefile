PREFIX=/usr/local/iimlab2
BINPREFIX=$(PREFIX)/bin
LIBPREFIX=$(PREFIX)/lib
INCLUDEPREFIX=$(PREFIX)/include
OPENCVFLAGS=$(shell pkg-config --cflags opencv)
OPENCVLIBS=$(shell pkg-config --libs opencv)
CXX=ccache g++ -Wall -Wno-int-in-bool-context -O2 -DEIGEN_NO_DEBUG

.cpp.o:
	$(CXX) $(OPENCVFLAGS) -fPIC -c $<

all: libfmatrix.so FundamentalMatrix FindEssentialMat

libfmatrix.so: fmatrix.o
	$(CXX) -shared -fPIC -o $@ $^

FundamentalMatrix: FundamentalMatrix.o
	$(CXX) -o $@ $^ -leigenutil -L./ -lfmatrix

FindEssentialMat: FindEssentialMat.o
	$(CXX) -o $@ $^ $(OPENCVLIBS) -leigenutil -L./ -lfmatrix

install:
	@mkdir -p $(BINPREFIX)
	@install FundamentalMatrix $(BINPREFIX)
	@install FindEssentialMat $(BINPREFIX)
	@mkdir -p $(LIBPREFIX)
	@install libfmatrix.so $(LIBPREFIX)
	@mkdir -p $(INCLUDEPREFIX)
	@install fmatrix.h $(INCLUDEPREFIX)

clean:
	rm -f FundamentalMatrix
	rm -f FindEssentialMat
	rm -f *.o
	rm -f *.gch
	rm -f *.dat
	rm -f *.so

