PACKAGE_NAME = gcc-arm-none-eabi_10-2020q4

ifeq (postpackaging,$(findstring $(MAKECMDGOALS),postpackaging))
  WIN_PACKAGE_FILENAME = gcc-arm-none-eabi-10-2020-q4-major-win32.zip
  WIN_PACKAGE_CHKSUM := $(firstword $(shell shasum -a 256 "$(WIN_PACKAGE_FILENAME)"))
  WIN_PACKAGE_SIZE := $(firstword $(shell wc -c "$(WIN_PACKAGE_FILENAME)"))

  L64_PACKAGE_FILENAME = gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
  L64_PACKAGE_CHKSUM := $(firstword $(shell shasum -a 256 "$(L64_PACKAGE_FILENAME)"))
  L64_PACKAGE_SIZE := $(firstword $(shell wc -c "$(L64_PACKAGE_FILENAME)"))

  LA64_PACKAGE_FILENAME = gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2
  LA64_PACKAGE_CHKSUM := $(firstword $(shell shasum -a 256 "$(LA64_PACKAGE_FILENAME)"))
  LA64_PACKAGE_SIZE := $(firstword $(shell wc -c "$(LA64_PACKAGE_FILENAME)"))

  OSX_PACKAGE_FILENAME = gcc-arm-none-eabi-10-2020-q4-major-mac.tar.bz2
  OSX_PACKAGE_CHKSUM := $(firstword $(shell shasum -a 256 "$(OSX_PACKAGE_FILENAME)"))
  OSX_PACKAGE_SIZE := $(firstword $(shell wc -c "$(OSX_PACKAGE_FILENAME)"))
endif

.PHONY: all clean print_info postpackaging

all: clean print_info
	@echo ----------------------------------------------------------
	@echo "Downloading files."
	wget -O gcc-arm-none-eabi-10-2020-q4-major-win32.zip https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-win32.zip
	wget -O gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
	wget -O gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-aarch64-linux.tar.bz2
	wget -O gcc-arm-none-eabi-10-2020-q4-major-mac.tar.bz2 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-mac.tar.bz2
	$(MAKE) --no-builtin-rules postpackaging -C .
	@echo ----------------------------------------------------------

clean:
	@echo ----------------------------------------------------------
	@echo  Cleanup
	-$(RM) package_$(PACKAGE_NAME)_*.json test_package_$(PACKAGE_NAME)_*.json
	@echo ----------------------------------------------------------

print_info:
	@echo ----------------------------------------------------------
	@echo Building $(PACKAGE_NAME) using
	@echo "CURDIR              = $(CURDIR)"
	@echo "OS                  = $(OS)"
	@echo "SHELL               = $(SHELL)"
	@echo "PACKAGE_NAME        = $(PACKAGE_NAME)"

postpackaging:
	@echo "WIN_PACKAGE_CHKSUM      = $(WIN_PACKAGE_CHKSUM)"
	@echo "WIN_PACKAGE_SIZE        = $(WIN_PACKAGE_SIZE)"
	@echo "WIN_PACKAGE_FILENAME    = $(WIN_PACKAGE_FILENAME)"

	@echo "LA64_PACKAGE_CHKSUM     = $(LA64_PACKAGE_CHKSUM)"
	@echo "LA64_PACKAGE_SIZE       = $(LA64_PACKAGE_SIZE)"
	@echo "LA64_PACKAGE_FILENAME   = $(LA64_PACKAGE_FILENAME)"

	@echo "L64_PACKAGE_CHKSUM      = $(L64_PACKAGE_CHKSUM)"
	@echo "L64_PACKAGE_SIZE        = $(L64_PACKAGE_SIZE)"
	@echo "L64_PACKAGE_FILENAME    = $(L64_PACKAGE_FILENAME)"

	@echo "OSX_PACKAGE_CHKSUM      = $(OSX_PACKAGE_CHKSUM)"
	@echo "OSX_PACKAGE_SIZE        = $(OSX_PACKAGE_SIZE)"
	@echo "OSX_PACKAGE_FILENAME    = $(OSX_PACKAGE_FILENAME)"

	cat extras/package_index.json.template | sed s/%%WIN_FILENAME%%/$(WIN_PACKAGE_FILENAME)/ | sed s/%%WIN_CHECKSUM%%/$(WIN_PACKAGE_CHKSUM)/ | sed s/%%WIN_SIZE%%/$(WIN_PACKAGE_SIZE)/ | sed s/%%OSX_FILENAME%%/$(OSX_PACKAGE_FILENAME)/ | sed s/%%OSX_CHECKSUM%%/$(OSX_PACKAGE_CHKSUM)/ | sed s/%%OSX_SIZE%%/$(OSX_PACKAGE_SIZE)/ | sed s/%%L64_FILENAME%%/$(L64_PACKAGE_FILENAME)/ | sed s/%%L64_CHECKSUM%%/$(L64_PACKAGE_CHKSUM)/ | sed s/%%L64_SIZE%%/$(L64_PACKAGE_SIZE)/ | sed s/%%LA64_FILENAME%%/$(LA64_PACKAGE_FILENAME)/ | sed s/%%LA64_CHECKSUM%%/$(LA64_PACKAGE_CHKSUM)/ | sed s/%%LA64_SIZE%%/$(LA64_PACKAGE_SIZE)/ > package_$(PACKAGE_NAME)_index.json
	@echo "package_$(PACKAGE_NAME)_index.json created"