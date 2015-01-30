FLEX_SDK = C:\Users\Jonathon\Desktop\Flex
ADL = $(FLEX_SDK)\bin\adl
AMXMLC = $(FLEX_SDK)\bin\amxmlc
SOURCES = src\*.hx assets\loading.png

all: game.swf

game.swf: $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 \
	-swf-header 650:650:60:ffffff \
	-main Startup \
	-swf game.swf \
	-swf-lib vendor\starling_1_6.swc --macro "patchTypes('vendor/starling.patch')"

clean:
	del game.swf *~ src\*~

test: game.swf
	$(ADL) -profile tv -screensize 650x650:650x650 game.xml