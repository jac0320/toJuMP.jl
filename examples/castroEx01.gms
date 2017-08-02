*  QCP written by GAMS Convert at 03/08/17 06:09:31
*
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         34       32        0        2        0        0        0        0
*
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         28       28        0        0        0        0        0        0
*  FX      0        0        0        0        0        0        0        0
*
*  Nonzero counts
*      Total    const       NL      DLL
*         89       81        8        0
*
*  Solve m using QCP minimizing x28;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,x20,x21,x22,x23,x24,x25,x26,x27,x28;

Positive Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17
          ,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34;


e1..  - x10 + x28 =E= 0;

e2..  - x2 - x6 =E= -40;

e3..  - x3 - x7 =E= -30;

e4..  - x4 - x8 =E= -20;

e5..  - x1 - x6 - x7 - x8 + x10 =E= 0;

e6..  - x1 - x5 + x10 =E= 0;

e7..  - x2 - x3 - x4 - x5 + x9 =E= 0;

e8..  - x12 - x16 =E= -16000;

e9..  - x13 - x17 =E= -3000;

e10..  - x14 - x18 =E= -600;

e11..  - x16 + 16000*x25 =E= 0;

e12..  - x17 + 3000*x26 =E= 0;

e13..  - x18 + 600*x27 =E= 0;

e14..  - x12 + 16000*x21 =E= 0;

e15..  - x13 + 3000*x22 =E= 0;

e16..  - x14 + 600*x23 =E= 0;

e17..  - x6 + 40*x25 =E= 0;

e18..  - x7 + 30*x26 =E= 0;

e19..  - x8 + 20*x27 =E= 0;

e20..  - x2 + 40*x21 =E= 0;

e21..  - x3 + 30*x22 =E= 0;

e22..  - x4 + 20*x23 =E= 0;

e23..    x21 + x25 =E= 1;

e24..    x22 + x26 =E= 1;

e25..    x23 + x27 =E= 1;

e26..  - 400*x10 + x11 + x16 + x17 + x18 =L= 0;

e27..    0.01*x11 + 0.01*x16 + 0.01*x17 + 0.01*x18 - x19 =E= 0;

e28..  - x11 - x15 + x19 =E= 0;

e29.. x19*x20 - x11 =E= 0;

e30.. x19*x24 - x15 =E= 0;

e31.. x10*x20 - x1 =E= 0;

e32.. x10*x24 - x5 =E= 0;

e33..    x20 + x24 =E= 1;

e34..  - 20*x9 + x12 + x13 + x14 + x15 =L= 0;

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

Model m / all /;

m.limrow=0; m.limcol=0;

m.workspace  = 500;
m.optcr      = 1E-6;
m.reslim     = 3600;
m.iterlim    = 10000000;
Solve m using QCP minimizing x28;
