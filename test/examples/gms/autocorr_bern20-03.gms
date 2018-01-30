$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*          1        0        0        1        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*         21        1       20        0        0        0        0        0
*  FX      0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*         21        1       20        0
*
*  Solve m using MINLP minimizing objvar;


Variables  b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19
          ,b20,objvar;

Binary Variables  b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17
          ,b18,b19,b20;

Equations  e1;


e1.. 8*b1*b3 - 4*b1 - 8*b3 + 8*b2*b4 - 4*b2 - 8*b4 + 8*b3*b5 - 8*b5 + 8*b4*b6
      - 8*b6 + 8*b5*b7 - 8*b7 + 8*b6*b8 - 8*b8 + 8*b7*b9 - 8*b9 + 8*b8*b10 - 8*
     b10 + 8*b9*b11 - 8*b11 + 8*b10*b12 - 8*b12 + 8*b11*b13 - 8*b13 + 8*b12*b14
      - 8*b14 + 8*b13*b15 - 8*b15 + 8*b14*b16 - 8*b16 + 8*b15*b17 - 8*b17 + 8*
     b16*b18 - 8*b18 + 8*b17*b19 - 4*b19 + 8*b18*b20 - 4*b20 - objvar =L= 0;

Model m / all /;

m.limrow=0; m.limcol=0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
