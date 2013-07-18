FLEX_SDK_DIR     = vendor/flex_sdk_4.8.0
OUT_DIR          = build/spellFlash
FLEX_SDK_OUT_DIR = $(OUT_DIR)/vendor/flex_sdk

.PHONY: flash clean all

all: clean flash

flash:
	mkdir -p $(FLEX_SDK_OUT_DIR)/bin $(FLEX_SDK_OUT_DIR)/lib

	# 3rd party libraries
	cp -R lib src $(OUT_DIR)

	# mxmlc and dependencies
	mkdir -p $(FLEX_SDK_OUT_DIR)/frameworks
	mkdir -p $(FLEX_SDK_OUT_DIR)/frameworks/libs/player/11.1
	mkdir -p $(FLEX_SDK_OUT_DIR)/frameworks/themes/Spark

	cp $(FLEX_SDK_DIR)/bin/mxmlc* $(FLEX_SDK_OUT_DIR)/bin
	cp $(FLEX_SDK_DIR)/frameworks/localFonts.ser $(FLEX_SDK_OUT_DIR)/frameworks
	cp $(FLEX_SDK_DIR)/frameworks/libs/core.swc $(FLEX_SDK_OUT_DIR)/frameworks/libs
	cp $(FLEX_SDK_DIR)/frameworks/libs/player/11.1/playerglobal.swc $(FLEX_SDK_OUT_DIR)/frameworks/libs/player/11.1
	cp $(FLEX_SDK_DIR)/frameworks/themes/Spark/spark.css $(FLEX_SDK_OUT_DIR)/frameworks/themes/Spark
	cp $(FLEX_SDK_DIR)/lib/asc.jar $(FLEX_SDK_OUT_DIR)/lib
	cp $(FLEX_SDK_DIR)/lib/fxgutils.jar $(FLEX_SDK_OUT_DIR)/lib
	cp $(FLEX_SDK_DIR)/lib/mxmlc* $(FLEX_SDK_OUT_DIR)/lib
	cp $(FLEX_SDK_DIR)/lib/swfutils.jar $(FLEX_SDK_OUT_DIR)/lib
	cp $(FLEX_SDK_DIR)/lib/velocity-dep-1.4-flex.jar $(FLEX_SDK_OUT_DIR)/lib

clean:
	rm -rf $(OUT_DIR) || true
