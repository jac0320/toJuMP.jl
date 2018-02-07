\ Equation counts
\     Total        E        G        L        N        X        C        B
\         1        0        0        1        0        0        0        0
\
\ Variable counts
\                  x        b        i      s1s      s2s       sc       si
\     Total     cont   binary  integer     sos1     sos2    scont     sint
\        21        1       20        0        0        0        0        0
\
\ Nonzero counts
\     Total    const       NL      DLL
\        22        2       20        0
\
Minimize
 obj: 0 b1 + 0 b2 + 0 b3 + 0 b4 + 0 b5 + 0 b6 + 0 b7 + 0 b8 + 0 b9 + 0 b10 + 0 b11 + 0 b12 + 0 b13 + 0 b14
  + 0 b15 + 0 b16 + 0 b17 + 0 b18 + 0 b19 + 0 b20 + objvar

Subject To
 e1: - 4 b1 - 4 b2 - 8 b3 - 8 b4 - 8 b5 - 8 b6 - 8 b7 - 8 b8 - 8 b9 - 8 b10 - 8 b11 - 8 b12 - 8 b13 - 8 b14
  - 8 b15 - 8 b16 - 8 b17 - 8 b18 - 4 b19 - 4 b20 - objvar + [ 8 b1 * b3 + 8 b2 * b4 + 8 b3 * b5 + 8 b4 * b6
  + 8 b5 * b7 + 8 b6 * b8 + 8 b7 * b9 + 8 b8 * b10 + 8 b9 * b11 + 8 b10 * b12 + 8 b11 * b13 + 8 b12 * b14
  + 8 b13 * b15 + 8 b14 * b16 + 8 b15 * b17 + 8 b16 * b18 + 8 b17 * b19 + 8 b18 * b20 ] <= 0

Bounds
 objvar Free

Binary
 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20

End
