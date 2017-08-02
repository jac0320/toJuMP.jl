*  QCP written by GAMS Convert at 03/08/17 06:10:30
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         45       42        0        3        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         42       42        0        0        0        0        0        0
*  FX      0        0        0        0        0        0        0        0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        143      119       24        0
*
*  Solve m using QCP minimizing x42;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34,x35,x36
          ,x37,x38,x39,x40,x41,x42;

Positive Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,x32,x33,x34
          ,x35,x36,x37,x38,x39,x40,x41;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36
          ,e37,e38,e39,e40,e41,e42,e43,e44,e45;


e1..  - x14 - x15 + x42 =E= 0;

e2..  - x5 - x9 - x10 =E= -60;

e3..  - x6 - x11 - x12 =E= -20;

e4..  - x1 - x3 - x9 - x11 + x14 =E= 0;

e5..  - x2 - x4 - x10 - x12 + x15 =E= 0;

e6..  - x1 - x2 - x7 + x14 =E= 0;

e7..  - x3 - x4 - x8 + x15 =E= 0;

e8..  - x5 - x6 - x7 - x8 + x13 =E= 0;

e9..  - x20 - x24 - x25 =E= -24000;

e10..  - x21 - x26 - x27 =E= -16000;

e11..  - x24 + 24000*x38 =E= 0;

e12..  - x25 + 24000*x39 =E= 0;

e13..  - x26 + 16000*x40 =E= 0;

e14..  - x27 + 16000*x41 =E= 0;

e15..  - x20 + 24000*x34 =E= 0;

e16..  - x21 + 16000*x35 =E= 0;

e17..  - x9 + 60*x38 =E= 0;

e18..  - x10 + 60*x39 =E= 0;

e19..  - x11 + 20*x40 =E= 0;

e20..  - x12 + 20*x41 =E= 0;

e21..  - x5 + 60*x34 =E= 0;

e22..  - x6 + 20*x35 =E= 0;

e23..    x34 + x38 + x39 =E= 1;

e24..    x35 + x40 + x41 =E= 1;

e25..  - 200*x14 + x16 + x18 + x24 + x26 =L= 0;

e26..  - 1000*x15 + x17 + x19 + x25 + x27 =L= 0;

e27..    0.01*x16 + 0.01*x18 + 0.01*x24 + 0.01*x26 - x28 =E= 0;

e28..    0.2*x17 + 0.2*x19 + 0.2*x25 + 0.2*x27 - x29 =E= 0;

e29..  - x16 - x17 - x22 + x28 =E= 0;

e30..  - x18 - x19 - x23 + x29 =E= 0;

e31.. x28*x30 - x16 =E= 0;

e32.. x28*x31 - x17 =E= 0;

e33.. x29*x32 - x18 =E= 0;

e34.. x29*x33 - x19 =E= 0;

e35.. x28*x36 - x22 =E= 0;

e36.. x29*x37 - x23 =E= 0;

e37.. x14*x30 - x1 =E= 0;

e38.. x14*x31 - x2 =E= 0;

e39.. x15*x32 - x3 =E= 0;

e40.. x15*x33 - x4 =E= 0;

e41.. x14*x36 - x7 =E= 0;

e42.. x15*x37 - x8 =E= 0;

e43..    x30 + x31 + x36 =E= 1;

e44..    x32 + x33 + x37 =E= 1;

e45..  - 10*x13 + x20 + x21 + x22 + x23 =L= 0;

* set non-default bounds
x1.up = 1000000;
x2.up = 1000000;
x3.up = 1000000;
x4.up = 1000000;
x5.up = 1000000;
x6.up = 1000000;
x7.up = 1000000;
x8.up = 1000000;
x9.up = 1000000;
x10.up = 1000000;
x11.up = 1000000;
x12.up = 1000000;
x13.up = 1000000;
x14.up = 1000000;
x15.up = 1000000;
x16.up = 1000000;
x17.up = 1000000;
x18.up = 1000000;
x19.up = 1000000;
x20.up = 1000000;
x21.up = 1000000;
x22.up = 1000000;
x23.up = 1000000;
x24.up = 1000000;
x25.up = 1000000;
x26.up = 1000000;
x27.up = 1000000;
x28.up = 1000000;
x29.up = 1000000;
x30.up = 1000000;
x31.up = 1000000;
x32.up = 1000000;
x33.up = 1000000;
x34.up = 1000000;
x35.up = 1000000;
x36.up = 1000000;
x37.up = 1000000;
x38.up = 1000000;
x39.up = 1000000;
x40.up = 1000000;
x41.up = 1000000;

Model m / all /;

m.limrow=0; m.limcol=0;

m.workspace  = 500;
m.optcr      = 1E-6;
m.reslim     = 3600;
m.iterlim    = 10000000;
Solve m using QCP minimizing x42;
