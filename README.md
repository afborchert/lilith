# Historic Material of our Modula-2 System

Because of multiple requests I make that software available that was
used to bootstrap to a Modula-2 compiler for the Lilith architecture
running on a Lilith emulator on a Perkin-Elmer 3220 machine running UNIX
Edition 7. All this happened in summer 1983.

I haven't changed any of the sources. This means that the emulator
and its associated tools can no longer be compiled with recent C
compilers and even if you manage to get rid of all the K&R style
dependencies within the C sources, it won't work because of huge
portability problems. These utilities were just developed to serve
in the development of a Modula-2 compiler for the Perkin-Elmer 3220
architecture and were no longer needed once this goal was achieved.

Following components are included in the submodules of this
repository:

 * _lilith-emulator_ (Lilith emulator, written in C)
 * _mcode-decoder_ (M-code decoder, written in C)
 * _mcode-linker_ (M-code overlay linker, written in C)
 * _lilith-multipass-modula2-compiler_ (ETH Zürich multipass Modula-2 compiler for the Lilith with adaptions for the bootstrapping process)
 * _lilith-binaries_ (binaries for _lilith_, _mcd_, and _mcl_ which can not be easily reproduced)

Please note that the Lilith emulator, the M-Code decoder, and
the M-Code linker are available under the terms of the GPL.
The Multipass Modula-2 compiler for the Lilith architecture,
however, was developed by a team under the direction of [Niklaus
Wirth](https://inf.ethz.ch/personal/wirth/) at the Institut für
Informatik at ETH Zürich. We received this software under a
[license agreement](https://github.com/afborchert/lilith-multipass-modula2-compiler/blob/master/License-Agreement)
which allows us to redistribute it. You have to consent to this
licence before you download it.

More instructions on how to play with these tools can be found at
http://www.mathematik.uni-ulm.de/modula/history/

## Downloading

If you want to clone it, you should do this recursively:

```
git clone --recursive https://github.com/afborchert/lilith.git
```

Andreas F. Borchert
