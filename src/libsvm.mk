
# --- static, vendored libsvm ---
# libsvm is tiny. the complication added by trying to install it from package managers
# especially when we're also trying to integrate with Stata's bespoke package manager,
# is not worth it. So we just build it statically and build it into the DLLs we ship.

# this is a version pin
LIBSVM_VERSION := 325

libsvm-v$(LIBSVM_VERSION)/svm.cpp:
	mkdir -p libsvm-v$(LIBSVM_VERSION)
	curl -fJL "https://github.com/cjlin1/libsvm/archive/refs/tags/v$(LIBSVM_VERSION).tar.gz" -o "libsvm-v$(LIBSVM_VERSION).tar.gz"
	tar -xz --strip-components=1 -C libsvm-v$(LIBSVM_VERSION) -f libsvm-v$(LIBSVM_VERSION).tar.gz


# build libsvm with its own Makefile, which is probably wiser than we could be
libsvm-v$(LIBSVM_VERSION)/svm.o: libsvm-v$(LIBSVM_VERSION)/svm.cpp
	$(MAKE) -C libsvm-v$(LIBSVM_VERSION) lib

libsvm-v$(LIBSVM_VERSION)/libsvm.a: libsvm-v$(LIBSVM_VERSION)/svm.o
	ar rcs $@ $<

# _svmachines.so (DLLEXT is still 'so' at this point) causes libsvm.a to build -- as a static library
_svmachines.o: libsvm-v$(LIBSVM_VERSION)/libsvm.a
CFLAGS  += -Ilibsvm-v$(LIBSVM_VERSION)
LDFLAGS += -Llibsvm-v$(LIBSVM_VERSION)

clean-libsvm:
	$(RM) libsvm-v$(LIBSVM_VERSION).tar.gz
	$(RMDIR) libsvm-v$(LIBSVM_VERSION)

clean: clean-libsvm
