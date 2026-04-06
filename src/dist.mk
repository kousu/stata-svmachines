# --- Distribution ---
#
# Two main targets:
#   dist    - collects and creates the files necessary for an online Stata repo
#     unfortunately, because it is impossible to do all the building on one machine,
#     this only collects whatever it finds. You will need to manually merge the various builds.
#   package - zips up the source

## 'make dist':

# scan the list of files to distribute and aim them at dist/$(PKG).
# note: this is somewhat loose: it grabs EVERYTHING in certain folders
DIST:=$(wildcard *.ado *.sthlp *.ihlp bin/*/* ancillary/*)
DIST:=$(patsubst %,dist/$(PKG)/%,$(DIST))
DIST+=dist/$(PKG).pkg dist/stata.toc
#$(info DIST=$(DIST)) #DEBUG
dist: $(DIST)

# actually copy listed files into the distribution directory
dist/$(PKG)/%: %
	$(MKDIR) $(call FixPath,$(dir $@))
	$(CP) $(call FixPath,$<) $(call FixPath,$@)

# special cases: stata.toc and $(PKG).pkg
ifneq ($(OS),Windows_NT)
 # These scripts don't work under Windows, so simply don't define them on Windows
.PHONY: dist/stata.toc
dist/stata.toc: ../scripts/maketoc
	$(MKDIR) $(dir $@)
	"$<" $(dir $@) "$(DESCRIPTION)"
dist/stata.toc: DESCRIPTION:=Stata repo

.PHONY: dist/$(PKG).pkg
dist/$(PKG).pkg: ../scripts/makepluginpkg
	$(MKDIR) $(dir $@)
	"$<" "$@" "$(DESCRIPTION)" "$(AUTHOR)"
endif

## 'make package'

ifndef PACKAGE_FORMAT
  PACKAGE_FORMAT:=zip
endif
.PHONY: package
package: ../$(PKG).$(PACKAGE_FORMAT)

../svmachines.zip: $(DIST)
	(cd dist && zip -r ../../svmachines.zip .)
	@echo " "
	@echo "--------------------------------------------------------------------------"
	@echo package has been constructed.  Was your repository clean before you did this?
	@echo         DOUBLE CHECK THAT IT CONTAINS WHAT YOU INTEND TO SUBMIT.
	@echo "--------------------------------------------------------------------------"


# --- cleaning ---
clean: dist-clean

.PHONY: dist-clean
dist-clean:
	-$(RMDIR) dist
