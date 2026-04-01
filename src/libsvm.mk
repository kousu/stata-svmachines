
# --- static, vendored libsvm ---
# libsvm is tiny. the complication added by trying to install it from package managers
# especially when we're also trying to integrate with Stata's bespoke package manager,
# is not worth it. So we just build it statically and build it into the DLLs we ship.

# this is a version pin
LIBSVM_VERSION := v337

libsvm-$(LIBSVM_VERSION)/svm.cpp:
	mkdir -p libsvm-$(LIBSVM_VERSION)
	curl -fJL "https://github.com/cjlin1/libsvm/archive/refs/tags/$(LIBSVM_VERSION).tar.gz" -o "libsvm-$(LIBSVM_VERSION).tar.gz"
	tar -xz --strip-components=1 -C libsvm-$(LIBSVM_VERSION) -f libsvm-$(LIBSVM_VERSION).tar.gz


# build libsvm with its own Makefile, which is probably wiser than we could be
libsvm-$(LIBSVM_VERSION)/svm.o: libsvm-$(LIBSVM_VERSION)/svm.cpp
	$(MAKE) -C libsvm-$(LIBSVM_VERSION) lib

libsvm-$(LIBSVM_VERSION)/libsvm.a: libsvm-$(LIBSVM_VERSION)/svm.o
	ar rcs $@ $<

# _svmachines.so (DLLEXT is still 'so' at this point) causes libsvm.a to build -- as a static library
_svmachines.o: libsvm-$(LIBSVM_VERSION)/libsvm.a
CFLAGS  += -Ilibsvm-$(LIBSVM_VERSION)
LDFLAGS += -Llibsvm-$(LIBSVM_VERSION)

clean-libsvm:
	$(RM) libsvm-$(LIBSVM_VERSION).tar.gz
	$(RMDIR) libsvm-$(LIBSVM_VERSION)

clean: clean-libsvm
