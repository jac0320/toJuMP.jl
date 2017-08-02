$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         40        2       21       17        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         18       18        0        0        0        0        0        0
*  FX      0        0        0        0        0        0        0        0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        121       35       86        0
*
*  Solve m using QCP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,objvar;

Positive Variables  x16,x17;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40;


e1..  - x1 + objvar =E= -23.9703519468901;

e2.. -x16*x17 + x1 =E= 0;

e3.. (x2 - x4)*(x2 - x4) + (x3 - x5)*(x3 - x5) =G= 3.24;

e4.. (x2 - x6)*(x2 - x6) + (x3 - x7)*(x3 - x7) =G= 4;

e5.. (x2 - x8)*(x2 - x8) + (x3 - x9)*(x3 - x9) =G= 8.41;

e6.. (x2 - x10)*(x2 - x10) + (x3 - x11)*(x3 - x11) =G= 2.89;

e7.. (x2 - x12)*(x2 - x12) + (x3 - x13)*(x3 - x13) =G= 6.25;

e8.. (x2 - x14)*(x2 - x14) + (x3 - x15)*(x3 - x15) =G= 3.24;

e9.. (x4 - x6)*(x4 - x6) + (x5 - x7)*(x5 - x7) =G= 1.96;

e10.. (x4 - x8)*(x4 - x8) + (x5 - x9)*(x5 - x9) =G= 5.29;

e11.. (x4 - x10)*(x4 - x10) + (x5 - x11)*(x5 - x11) =G= 1.21;

e12.. (x4 - x12)*(x4 - x12) + (x5 - x13)*(x5 - x13) =G= 3.61;

e13.. (x4 - x14)*(x4 - x14) + (x5 - x15)*(x5 - x15) =G= 1.44;

e14.. (x6 - x8)*(x6 - x8) + (x7 - x9)*(x7 - x9) =G= 6.25;

e15.. (x6 - x10)*(x6 - x10) + (x7 - x11)*(x7 - x11) =G= 1.69;

e16.. (x6 - x12)*(x6 - x12) + (x7 - x13)*(x7 - x13) =G= 4.41;

e17.. (x6 - x14)*(x6 - x14) + (x7 - x15)*(x7 - x15) =G= 1.96;

e18.. (x8 - x10)*(x8 - x10) + (x9 - x11)*(x9 - x11) =G= 4.84;

e19.. (x8 - x12)*(x8 - x12) + (x9 - x13)*(x9 - x13) =G= 9;

e20.. (x8 - x14)*(x8 - x14) + (x9 - x15)*(x9 - x15) =G= 5.29;

e21.. (x10 - x12)*(x10 - x12) + (x11 - x13)*(x11 - x13) =G= 3.24;

e22.. (x10 - x14)*(x10 - x14) + (x11 - x15)*(x11 - x15) =G= 1.21;

e23.. (x12 - x14)*(x12 - x14) + (x13 - x15)*(x13 - x15) =G= 3.61;

e24..    x2 - x16 =L= -1.2;

e25..    x3 - x17 =L= -1.2;

e26..    x4 - x16 =L= -0.6;

e27..    x5 - x17 =L= -0.6;

e28..    x6 - x16 =L= -0.8;

e29..    x7 - x17 =L= -0.8;

e30..    x8 - x16 =L= -1.7;

e31..    x9 - x17 =L= -1.7;

e32..    x10 - x16 =L= -0.5;

e33..    x11 - x17 =L= -0.5;

e34..    x12 - x16 =L= -1.3;

e35..    x13 - x17 =L= -1.3;

e36..    x14 - x16 =L= -0.6;

e37..    x15 - x17 =L= -0.6;

e38..    x2 =L= 4;

e39..    x3 =L= 2;

e40..    x4 - x14 =L= 0;

* set non-default bounds
x1.lo = 2.89; x1.up = 32;
x2.lo = 1.2; x2.up = 6.8;
x3.lo = 1.2; x3.up = 2.8;
x4.lo = 0.6; x4.up = 7.4;
x5.lo = 0.6; x5.up = 3.4;
x6.lo = 0.8; x6.up = 7.2;
x7.lo = 0.8; x7.up = 3.2;
x8.lo = 1.7; x8.up = 6.3;
x9.lo = 1.7; x9.up = 2.3;
x10.lo = 0.5; x10.up = 7.5;
x11.lo = 0.5; x11.up = 3.5;
x12.lo = 1.3; x12.up = 6.7;
x13.lo = 1.3; x13.up = 2.7;
x14.lo = 0.6; x14.up = 7.4;
x15.lo = 0.6; x15.up = 3.4;
x16.up = 8;
x17.up = 4;
objvar.lo = 0; objvar.up = 32;

* set non-default levels
x1.l = 2.89;
x2.l = 1.2;
x3.l = 1.2;
x4.l = 0.6;
x5.l = 0.6;
x6.l = 0.8;
x7.l = 0.8;
x8.l = 1.7;
x9.l = 1.7;
x10.l = 0.5;
x11.l = 0.5;
x12.l = 1.3;
x13.l = 1.3;
x14.l = 0.6;
x15.l = 0.6;

Model m / all /;

m.limrow=0; m.limcol=0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set NLP $set NLP NLP
Solve m using %NLP% minimizing objvar;
