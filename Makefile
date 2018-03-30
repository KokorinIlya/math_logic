SOURCES = $(shell find src -type f -name "*.java")
CLASSES = $(patsubst src/%.java,out/%.class,$(SOURCES))
ANTLR_SOURCES = $(shell find src -type f -name "*.g4")
ANTLR_RESULTS = $(patsubst %.g4,%Parser.java,$(ANTLR_SOURCES))
ANTLR = lib/antlr-4.7.1-complete.jar
MAINCLASS = hw1.HW1

all: $(ANTLR_RESULTS) $(CLASSES)

run:
	java -cp out:${ANTLR} ${MAINCLASS}

pack:
	zip hw1.zip -r Makefile src lib

clean:
	rm -rf out
	rm -f src/parser/*.java

%Parser.java: %.g4
	java -jar ${ANTLR} $< 

out/%.class: src/%.java out
	javac -cp src:${ANTLR} $< -d out

out:
	mkdir -p out
