* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 2026 Robert Tiismus

* ======================================================
*  Project:	cardcopy
*  Description:	HP48GX Memory Card Image Copy Utility.
*		Allows direct cloning of card data
*		between physical card ports.
*  Platform:	HP48GX Calculator
*  Language:	SysRPL / Saturn Assembly
* ======================================================

ASSEMBLE
* Unsupported entries
=BankSelect	EQU	#09CFA
* Flags and bits
Slot1to2	EQU	0
Readable	EQU	3
Merged		EQU	1
RPL

::
 0LASTOWDOB! CK2NOLASTWD
 CK&DISPATCH1 # 11 ( real real )
 ::
  2DUP 
  ( Ensure that real port numbers are positive nonzero integers
    that will correctly map to BINT object )
  DUP COERCE DUP#0<> UNROT UNCOERCE EQUAL AND
  SWAPDUP COERCE DUP#0<> UNROT UNCOERCE EQUAL AND AND
  ?SKIP
  ::
   # 203 ( "Bad Argument Value" )
   ERROROUT
  ; 
  COERCE2
  2DUP#= case2DROP ( Do nothing if source == destination )
  CODE
**** Read parameters and do initial setup
	GOSBVL	=POP2#		A(A) = Port_from# C.A = Port_to#
	RSTK=C
	GOSBVL	=SAVPTR
	GOSBVL	=DisableIntr

**** Get the bank number and copying direction
	A=A-1	A
	C=RSTK
	C=C-1	A
	B=C	A		B.A - bank number
	ST=1	Slot1to2

	?A=0	A
	GOYES	++
	?C=0	A
	GOYES	+

	LCHEX	00203		"Bad Argument Value"
	GOVLNG	=GPErrjmpC

+	ST=0	Slot1to2
	B=A	A		B.A - bank number

++
**** Check slot1 card status
	D0=(5) 	(=CONFTAB)+4
	A=DAT0	P

	?ST=1	Slot1to2
	GOYES	+

	LCHEX	C		(RWS0) #C=1100, writable, not merged
	?A=C	P
	GOYES	++

	GOTO	PortErr

+	?ABIT=0	Readable	Must at least be present, not merged
	GOYES	PortErr
	?ABIT=1	Merged
	GOYES	PortErr
++
**** Check slot2 card status
	D0=D0+	2
	A=DAT0	P

	?ST=1	Slot1to2
	GOYES	+

	?A#0	P		Must at least be present
	GOYES	++

	GOTO	PortErr

+	LCHEX	C		(RWS0) #C=1100, writable, not merged
	?A#C	P
	GOYES	PortErr
++
**** Check if cards are equal size
	D0=D0-	1
	A=DAT0	P
	D0=D0+	2
	C=DAT0	P

	?A#C	P
	GOYES	PortErr

	D=C	P		Store size code in D.0

**** Is port number less or equal to number of available banks?
	D0=D0+	1
	C=DAT0	B		C=number of banks
	?B<=C	B
	GOYES	+

PortErr C=0	A
	LCHEX	A		"Port Not Available"
	GOVLNG	=GPErrjmpC
+
**** Calculate card size 32kB/128kB
	LCHEX	1
	?D#C	P
	GOYES	+

	LCHEX	F0000		Size = 32kB ( #10000 nibbles negated )
	GOTO	++

+	LCHEX	2
	?D#C	P
	GOYES	PortErr

	LCHEX	C0000		Size = 128kB ( #40000 nibbles negated )

++	D=C	A		Card size field for config

**** Select slot 2 memory bank
	C=B	B
	GOSBVL	=BankSelect

**** Configure slot 1 to the address #40000
	LCHEX	C0000
	UNCNFG			unconfig card in slot 1 (CE2) 
	C=D	A		Size mask in D.A
	CONFIG			Set slot 1 size
	LCHEX	40000
	CONFIG			Configure slot 1 at address 40000

**** Copy the slot content
	LCHEX	40000
	A=C	A
	LCHEX	C0000

	?ST=1	Slot1to2
	GOYES	+

	ACEX	A

+	D0=A
	D1=C
	C=D	A
	C=-C	A		Calculate card size from size mask
	GOSBVL	=MOVEDOWN

**** Reconfigure slot 1 to its usual #C0000 address
	LCHEX	40000
	UNCNFG			Unconfig slot 1 from 40000
	C=D	A
	CONFIG			Configure slot 1 size
	LCHEX	C0000
	CONFIG			Configure slot 1 to C0000

	GOSBVL	=AllowIntr
	GOVLNG	=GETPTRLOOP
  ENDCODE
 ;
;
