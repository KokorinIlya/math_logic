.PHONY: pack all run clean src/parcer src/sources
GENERATED=src/parser.mli src/parser.ml src/lexer.ml
SOURCE=src/utils.ml src/evaluator.ml src/proofs.ml src/lemm_proover.ml src/proover.ml src/deductor.ml
OCAMLC=ocamlc # ocamlopt for speed
PACKAGE=hw3.zip

ifeq ($(OS),Windows_NT)
	DEL=del /f
else
	DEL=rm -f
endif

all: main.exe

run: main.exe
	./main.exe

src/parser: src/tree.cmi
	cd src && $(OCAMLC) -c $(GENERATED:src/%=%)

src/tree.cmi:
	cd src && $(OCAMLC) -c tree.ml

src/sources: src/parser
	cd src && $(OCAMLC) -c $(SOURCE:src/%=%)

main.exe: $(GENERATED) src/tree.cmi src/sources
	cd src && $(OCAMLC) str.cma tree.ml $(GENERATED:src/%=%) $(SOURCE:src/%=%) main.ml -o ../main.exe

pack: $(GENERATED)
	zip $(PACKAGE) -r Makefile src

$(GENERATED): src/lexer.mll src/parser.mly
	ocamllex src/lexer.mll 
	ocamlyacc src/parser.mly

clean:
	cd src && $(DEL) $(GENERATED:src/%=%) *.c* *.o*
	$(DEL) main.exe $(PACKAGE)

