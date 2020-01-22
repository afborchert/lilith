#!/bin/bash
(
   rm -fr modula modula.tar &&
   mkdir -p modula/src modula/work modula/bin && cd modula &&
   ln -s ../../lilith-binaries/bin/{lilith,mcd,mcl} bin &&
   ln -s ../../mcode-decoder/src src/mcd &&
   ln -s ../../mcode-linker/src src/mcl &&
   ln -s ../../lilith-multipass-modula2-compiler/src src/mll &&
   ln -s ../../lilith-multipass-modula2-compiler/src/mc bin &&
   ln -s ../../lilith-emulator/src src/lilith &&
   cd work &&
   ln ../src/mll/{C18.*,SYM,OBJECTS} .
) &&
tar chf modula.tar modula
