\ Equation counts
\     Total        E        G        L        N        X        C        B
\         7        2        0        5        0        0        0        0
\
\ Variable counts
\                  x        b        i      s1s      s2s       sc       si
\     Total     cont   binary  integer     sos1     sos2    scont     sint
\         8        4        4        0        0        0        0        0
\
\ Nonzero counts
\     Total    const       NL      DLL
\        23       20        3        0
\
Minimize
 obj: 0 x1 + 0 x2 + 0 x3 + 0 x4 + 0 b6 + 0 b7 + 0 b8 + 0 b9 + [ 8 x1^2 + 12 x1 * x2 - 4 x1 * x3 + 12 x2^2
  + 4 x2 * x3 + 20 x3^2 ]/2

Subject To
 e1: x1 + x2 + x3 + x4 = 1
 e2: 8 x1 + 9 x2 + 12 x3 + 7 x4 = 10
 e4: x1 - b6 <= 0
 e5: x2 - b7 <= 0
 e6: x3 - b8 <= 0
 e7: x4 - b9 <= 0
 e8: b6 + b7 + b8 + b9 <= 3

Binary
 b6 b7 b8 b9

End
