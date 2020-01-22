# Historic Lilith emulator and Modula-2 compiler

## Introduction

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

The binaries in _lilith-binaries/bin_, i.e. _lilith_, _mcd_, and _mcl_,
were compiled from the corresponding sources in 1984. Unfortunately
they cannot be reproduced using the simulation system (see below) as
the C compiler shipped with the provided instance of UNIX Edition 7 has
bugs which were already fixed on our system at that time.

## Instructions

If you intend to play with these tools, you will need to setup an
environment that is close enough to our system we used at that time. I
recommend to use the most recent simulator of the [Computer History
Simulation Project](http://simh.trailing-edge.com/) along with a copy
of [Unix Edition 7 for the Interdata architecture](http://simh.trailing-edge.com/kits/iu7swre.zip) which is available under a license provided by
Caldera Corporation. The Interdata is a predecessor of the Perkin-Elmer
architecture we had. This is no problem for the Lilith emulator and the
compiler running on it but for our Modula-2 compiler for that
architecture which took advantage of instructions the Interdata didn't
have.

Here is a step-by-step instruction how this can be set up:

 * Download the newest release of the simulator (at the time of this
   writing this is
   [simhv311-0.zip](http://simh.trailing-edge.com/sources/simhv311-0.zip),
   compile, and install it. We need the id32 binary that simulates an
   Interdata 8/32.

 * Download [iu7swre.zip](http://simh.trailing-edge.com/kits/iu7swre.zip)
   and unpack it. (The license by Caldera is to be found in the file
   _AncientUnix.pdf_). The associated documentation is to be found
   [here](http://simh.trailing-edge.com/pdf/id_doc.pdf).

 * The most efficient method to transfer files to this system is by
   preparing a tar file that is made available as a disk. Under the
   UNIX system, we do not mount this disk but let tar unpack this
   archive from the raw device. This, however, works only reliably if
   we restrict all file and directory names to a maximal length of 14
   characters as longer names weren't supported by UNIX Edition 7.
   A shell script named _prepare-tarfile.sh_ is provided that does
   this for you:

   ```
   sh prepare-tarfile.sh
   ```

   You have now a tar archive named _modula.tar_.

 * Create a working directory and prepare a file named _id32.ini_
   in it:

   ```
   set ttp ena
   set pas dev=12
   att -e dp0 iu7_dp0.dsk
   att -e dp1 iu7_dp1.dsk
   att -e dp2 modula.tar
   set console brk=3
   boot dp0
   ```

 * Copy or symlink _iu7_dp0.dsk_, _iu7_dp1.dsk_, and _modula.tar_
   into the working directory.

 * Start the simulator of the Interdata 8/32:

   ```
   theon$ id32

   Interdata 32b simulator V3.11-0

   Boot
   : dsk(1,0)unix
   Memory = 248.0 K
   # ^D
   Restricted rights: Use, duplication, or disclosure is subject
   to restrictions stated in your contracts with Western Electric
   Company, Inc. and the University of Wollongong.
   Fri Jan  2 18:12:57 EST 1970

   login: root
   Password:
   #
   ```

   (Please note that ^D represents CTRL-d and that the root password
   is not echoed.)

 * In the next step we unpack the prepared tar archive into the _/tmp_
   directory. This is the only location where sufficient space is left.
   The _modula.tar_ archive is available through _/dev/dr2_ (block device)
   and _/dev/rdr2_ (raw device) which need to be created first:

   ```
   # cd /dev
   # /etc/mknod dr2 b 0 4
   # /etc/mknod rdr2 c 2 4
   # cd /tmp
   # tar xf /dev/rdr2
   Tar: blocksize = 20
   tar: modula/ - cannot create
   tar: modula/src/ - cannot create
   tar: modula/src/mcd/ - cannot create
   tar: modula/src/lilith/ - cannot create
   tar: modula/src/mll/ - cannot create
   tar: modula/src/mcl/ - cannot create
   tar: modula/bin/ - cannot create
   tar: modula/work/ - cannot create
   #
   ```

   (The error messages of tar can be ignored.)

 * Now we can add _/tmp/modula/bin_ to our path and attempt
   to compile a first “hello world” program in the
   directory _/tmp/modula/work_ which serves as working directory:

   ```
   # PATH=$PATH:/tmp/modula/bin:$PATH
   # export PATH
   # cd /tmp/modula/work
   # ls
   C18.Base
   C18.Init
   C18.Lister
   C18.Pass1
   C18.Pass2
   C18.Pass3
   C18.Pass4
   C18.Symfile
   OBJECTS
   SYM
   # ed HelloWorld.m2
   ?HelloWorld.m2
   a
   MODULE HelloWorld;

      FROM Terminal IMPORT WriteString, WriteLn;

   BEGIN
      WriteString("Hello, world!"); WriteLn;
   END HelloWorld.
   .
   w
   131
   q
   # mc HelloWorld.m2
    source file> HelloWorld.m2
   p1
    Terminal: Terminal.sy
   p2
   p3
   p4
   end compilation
   #
   ```

   _ed_ is the original text editor which works like the
   shell with command lines. “a” allows you to append text
   until a line consisting just of a “.” is entered. “w”
   saves the text into the filename which was specified
   to _ed_ at invocation time, and “q” leaves the editor.
   _mc_ is a wrapper script that invokes the Modula-2
   compiler using the Lilith emulator. This script expects
   the files _C18.Base_ etc. to be present in the current
   directory or at some obscure path.

 * If the compilation was successful (as shown above), we got an
   object file named _HelloWorld.o_ which by itself alone is not
   yet executable on the Lilith emulator. We can, however, decode
   it if we like to:

   ```
   # mcd HelloWorld.o
   decode of `HelloWorld.o' :

   codekey    = 3
   module name:  HelloWorld
   datasize   = 12
   key          0 0 0
   import  Terminal
    is #   1
           HelloWorld
    is #   2

   data, relative to G
       1:      0B
       2:      0B

   procedure  #   0 at   2 bytes relative to F
   data, relative to G
       3:  44145B
       4:  66154B
       5:  67454B
       6:  20167B
       7:  67562B
      10:  66144B
      11:  20400B

   code at F +   1 words
       1     2   353       ENTR      0
       2     4    25       LGA       1
       3     6   224       TS
       3     7    32       JPFC  [  2]   ->    12
       4    11   354       RTN
       5    12    25       LGA       3
       6    14   122       SGW2
       6    15   355       CX      1   0
      10    20   102       LGW2
      10    21    14       LI12
      11    22   355       CX      1   6
      12    25   355       CX      1   5
      14    30   354       RTN
      14    31   336       NOP
   fixups at    26    23    16

   #
   ```

   The module body begins with a test whether this module was already
   initialized by loading the address of the first global variable
   (_LGA 1_) and performing a test-and-set operation on it (_TS_). If this flag
   was false, we jump to position 12, continuing the body, otherwise we
   return (_RTN_) immediately. Next follows the storage of a pointer to
   the hello world string in the global variable 2 (_LGA 3_ and _SGW2_).
   Next follows the invocation of the module body of Terminal (_CX 1 0_,
   i.e. call external module 1, procedure 0). Then we are ready to
   invoke _WriteString_ and _WriteLn_. An open array parameter requires two
   values to be passed, the address of the array (_LGW2_ = load global
   word 2) and its length (_LI12_ = load immediate constant 12). Finally,
   we return. The _NOP_ instruction is used to fill up to a word boundary
   of 16 bits. Some of the instructions require one byte only (like
   _RTN_), others are longer (_CX_, for example, requires three bytes).

 * In the next step we can attempt to create a binary which is
   actually executable on the Lilith emulator. For this we will need
   the _Terminal.o_ object out of the _OBJECTS_ archive:

   ```
   # ar x OBJECTS Terminal.o
   # mcl -o HelloWorld HelloWorld.o Terminal.o
   # lilith HelloWorld
   Hello, world!
   #
   ```

   You might wonder why no other library modules were needed or why the
   source for _Terminal.m2_ is missing. It may be interesting to decode
   _Terminal.o_:

   ```
   # mcd Terminal.o
   decode of `Terminal.o' :

   codekey    = 3
   module name:  Terminal
   datasize   = 3
   key          123373 745 152654
   import  Terminal
    is #   1

   data, relative to G
       1:      0B
       2:      0B

   procedure  #   1 at  16 bytes relative to F
   code at F +   7 words
       7    16   246       SVC      74
      10    20   354       RTN
      10    21   336       NOP

   procedure  #   2 at  22 bytes relative to F
   code at F +  11 words
      11    22   246       SVC      75
      12    24   354       RTN
      12    25   336       NOP

   procedure  #   3 at  26 bytes relative to F
   code at F +  13 words
      13    26   246       SVC      76
      14    30   354       RTN
      14    31   336       NOP

   procedure  #   4 at  32 bytes relative to F
   code at F +  15 words
      15    32   246       SVC      77
      16    34   354       RTN
      16    35   336       NOP

   procedure  #   5 at  36 bytes relative to F
   code at F +  17 words
      17    36   246       SVC     100
      20    40   354       RTN
      20    41   336       NOP

   procedure  #   6 at  42 bytes relative to F
   code at F +  21 words
      21    42   246       SVC     101
      22    44   354       RTN
      22    45   336       NOP

   procedure  #   0 at  46 bytes relative to F
   code at F +  23 words
      23    46   353       ENTR      0
      24    50    25       LGA       1
      25    52   224       TS
      25    53    32       JPFC  [  2]   ->    56
      26    55   354       RTN
      27    56    25       LGA       3
      30    60   122       SGW2
      30    61   354       RTN

   #
   ```

   As you can see, most of these procedures are implemented with the
   help of a _SVC_ (super visor call) instruction which doesn't belong to
   the original instruction set of the Lilith architecture. I added
   this instruction as a hook that allowed me to implement these
   procedures within the Lilith emulator. You'll find the
   implementations of this within the l_svc.c source file of the Lilith
   emulator (in the _/tmp/modula/src/lilith_ subdirectory. _SVC 101_,
   for example, is implemented here (note that 101 is octal which is 65
   in decimal notation):

   ```C
	   case 65 :       /* PROCEDURE WriteString(s: ARRAY OF CHAR); */
		   len = pop() + 1;
		   index = pop();
		   ptr = (char *) &stack[index];
   #ifdef TRACE
		   trace("WriteString(\"");
   #endif TRACE
		   while ( len && *ptr ) {
   #ifdef TRACE
			   trace("%c",*ptr);
   #endif TRACE
			   putchar(*ptr++);
			   --len;
			   }
   #ifdef TRACE
		   trace("\")\n");
   #endif TRACE
		   break;
   ```

   These objects were not derived from the original sources but from
   stripped-down variants where the procedure bodies were replaced by
   _CODE_-constructs, a language-extension which was supported by the
   Modula-2 compiler for the Lilith. This allowed the inclusion of
   native machine code. These stripped-down sources existed on the
   PDP-11/40 only and were not transferred with the other files.

   In general, the surviving library modules are quite minimalistic in
   their selection, even _InOut_ is missing as I considered strictly
   those sources only which were required for bootstrapping.

 * If you want to save the current state of this simulated UNIX system
   for further experiments, you will need a clean shutdown procedure.
   Commands like shutdown or halt didn't exist at that time. Hence we
   have only _sync_. Type it twice and let some seconds pass. Type CTRL-e
   afterwards to return to the prompt of the simulator:

   ```
   # sync
   # sync
   # ^E
   Simulation stopped, PC: 00D20 (EPSR R1,R0)
   sim> exit
   Goodbye
   theon$
   ```

   Next time, you just need to boot the system again, following
   the instructions above, and you will find everything back again
   including the installed directories below _/tmp_.

## Downloading

If you want to clone it, you should do this recursively:

```
git clone --recursive https://github.com/afborchert/lilith.git
```

Andreas F. Borchert
