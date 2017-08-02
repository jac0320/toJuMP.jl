$offlisting
*  
*  Equation counts
*      Total        E        G        L        N        X        C        B
*         35       16        0       19        0        0        0        0
*  
*  Variable counts
*                   x        b        i      s1s      s2s       sc       si
*      Total     cont   binary  integer     sos1     sos2    scont     sint
*        136       31      105        0        0        0        0        0
*  FX      0        0        0        0        0        0        0        0
*  
*  Nonzero counts
*      Total    const       NL      DLL
*        503      338      165        0
*
*  Solve m using MINLP minimizing objvar;


Variables  x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19
          ,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,b31,b32,b33,b34,b35,b36
          ,b37,b38,b39,b40,b41,b42,b43,b44,b45,b46,b47,b48,b49,b50,b51,b52,b53
          ,b54,b55,b56,b57,b58,b59,b60,b61,b62,b63,b64,b65,b66,b67,b68,b69,b70
          ,b71,b72,b73,b74,b75,b76,b77,b78,b79,b80,b81,b82,b83,b84,b85,b86,b87
          ,b88,b89,b90,b91,b92,b93,b94,b95,b96,b97,b98,b99,b100,b101,b102,b103
          ,b104,b105,b106,b107,b108,b109,b110,b111,b112,b113,b114,b115,b116
          ,b117,b118,b119,b120,b121,b122,b123,b124,b125,b126,b127,b128,b129
          ,b130,b131,b132,b133,b134,b135,objvar;

Positive Variables  x2,x27;

Binary Variables  b31,b32,b33,b34,b35,b36,b37,b38,b39,b40,b41,b42,b43,b44,b45
          ,b46,b47,b48,b49,b50,b51,b52,b53,b54,b55,b56,b57,b58,b59,b60,b61,b62
          ,b63,b64,b65,b66,b67,b68,b69,b70,b71,b72,b73,b74,b75,b76,b77,b78,b79
          ,b80,b81,b82,b83,b84,b85,b86,b87,b88,b89,b90,b91,b92,b93,b94,b95,b96
          ,b97,b98,b99,b100,b101,b102,b103,b104,b105,b106,b107,b108,b109,b110
          ,b111,b112,b113,b114,b115,b116,b117,b118,b119,b120,b121,b122,b123
          ,b124,b125,b126,b127,b128,b129,b130,b131,b132,b133,b134,b135;

Equations  e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19
          ,e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35;


e1.. sqrt(sqr(x1 - x3) + sqr(x2 - x4))*b31 + sqrt(sqr(x1 - x5) + sqr(x2 - x6))*
     b32 + sqrt(sqr(x1 - x7) + sqr(x2 - x8))*b33 + sqrt(sqr(x1 - x9) + sqr(x2
      - x10))*b34 + sqrt(sqr(x1 - x11) + sqr(x2 - x12))*b35 + sqrt(sqr(x1 - x13
     ) + sqr(x2 - x14))*b36 + sqrt(sqr(x1 - x15) + sqr(x2 - x16))*b37 + sqrt(
     sqr(x1 - x17) + sqr(x2 - x18))*b38 + sqrt(sqr(x1 - x19) + sqr(x2 - x20))*
     b39 + sqrt(sqr(x1 - x21) + sqr(x2 - x22))*b40 + sqrt(sqr(x1 - x23) + sqr(
     x2 - x24))*b41 + sqrt(sqr(x1 - x25) + sqr(x2 - x26))*b42 + sqrt(sqr(x1 - 
     x27) + sqr(x2 - x28))*b43 + sqrt(sqr(x1 - x29) + sqr(x2 - x30))*b44 + 
     sqrt(sqr(x3 - x5) + sqr(x4 - x6))*b45 + sqrt(sqr(x3 - x7) + sqr(x4 - x8))*
     b46 + sqrt(sqr(x3 - x9) + sqr(x4 - x10))*b47 + sqrt(sqr(x3 - x11) + sqr(x4
      - x12))*b48 + sqrt(sqr(x3 - x13) + sqr(x4 - x14))*b49 + sqrt(sqr(x3 - x15
     ) + sqr(x4 - x16))*b50 + sqrt(sqr(x3 - x17) + sqr(x4 - x18))*b51 + sqrt(
     sqr(x3 - x19) + sqr(x4 - x20))*b52 + sqrt(sqr(x3 - x21) + sqr(x4 - x22))*
     b53 + sqrt(sqr(x3 - x23) + sqr(x4 - x24))*b54 + sqrt(sqr(x3 - x25) + sqr(
     x4 - x26))*b55 + sqrt(sqr(x3 - x27) + sqr(x4 - x28))*b56 + sqrt(sqr(x3 - 
     x29) + sqr(x4 - x30))*b57 + sqrt(sqr(x5 - x7) + sqr(x6 - x8))*b58 + sqrt(
     sqr(x5 - x9) + sqr(x6 - x10))*b59 + sqrt(sqr(x5 - x11) + sqr(x6 - x12))*
     b60 + sqrt(sqr(x5 - x13) + sqr(x6 - x14))*b61 + sqrt(sqr(x5 - x15) + sqr(
     x6 - x16))*b62 + sqrt(sqr(x5 - x17) + sqr(x6 - x18))*b63 + sqrt(sqr(x5 - 
     x19) + sqr(x6 - x20))*b64 + sqrt(sqr(x5 - x21) + sqr(x6 - x22))*b65 + 
     sqrt(sqr(x5 - x23) + sqr(x6 - x24))*b66 + sqrt(sqr(x5 - x25) + sqr(x6 - 
     x26))*b67 + sqrt(sqr(x5 - x27) + sqr(x6 - x28))*b68 + sqrt(sqr(x5 - x29)
      + sqr(x6 - x30))*b69 + sqrt(sqr(x7 - x9) + sqr(x8 - x10))*b70 + sqrt(sqr(
     x7 - x11) + sqr(x8 - x12))*b71 + sqrt(sqr(x7 - x13) + sqr(x8 - x14))*b72
      + sqrt(sqr(x7 - x15) + sqr(x8 - x16))*b73 + sqrt(sqr(x7 - x17) + sqr(x8
      - x18))*b74 + sqrt(sqr(x7 - x19) + sqr(x8 - x20))*b75 + sqrt(sqr(x7 - x21
     ) + sqr(x8 - x22))*b76 + sqrt(sqr(x7 - x23) + sqr(x8 - x24))*b77 + sqrt(
     sqr(x7 - x25) + sqr(x8 - x26))*b78 + sqrt(sqr(x7 - x27) + sqr(x8 - x28))*
     b79 + sqrt(sqr(x7 - x29) + sqr(x8 - x30))*b80 + sqrt(sqr(x9 - x11) + sqr(
     x10 - x12))*b81 + sqrt(sqr(x9 - x13) + sqr(x10 - x14))*b82 + sqrt(sqr(x9
      - x15) + sqr(x10 - x16))*b83 + sqrt(sqr(x9 - x17) + sqr(x10 - x18))*b84
      + sqrt(sqr(x9 - x19) + sqr(x10 - x20))*b85 + sqrt(sqr(x9 - x21) + sqr(x10
      - x22))*b86 + sqrt(sqr(x9 - x23) + sqr(x10 - x24))*b87 + sqrt(sqr(x9 - 
     x25) + sqr(x10 - x26))*b88 + sqrt(sqr(x9 - x27) + sqr(x10 - x28))*b89 + 
     sqrt(sqr(x9 - x29) + sqr(x10 - x30))*b90 + sqrt(sqr(x11 - x13) + sqr(x12
      - x14))*b91 + sqrt(sqr(x11 - x15) + sqr(x12 - x16))*b92 + sqrt(sqr(x11 - 
     x17) + sqr(x12 - x18))*b93 + sqrt(sqr(x11 - x19) + sqr(x12 - x20))*b94 + 
     sqrt(sqr(x11 - x21) + sqr(x12 - x22))*b95 + sqrt(sqr(x11 - x23) + sqr(x12
      - x24))*b96 + sqrt(sqr(x11 - x25) + sqr(x12 - x26))*b97 + sqrt(sqr(x11 - 
     x27) + sqr(x12 - x28))*b98 + sqrt(sqr(x11 - x29) + sqr(x12 - x30))*b99 + 
     sqrt(sqr(x13 - x15) + sqr(x14 - x16))*b100 + sqrt(sqr(x13 - x17) + sqr(x14
      - x18))*b101 + sqrt(sqr(x13 - x19) + sqr(x14 - x20))*b102 + sqrt(sqr(x13
      - x21) + sqr(x14 - x22))*b103 + sqrt(sqr(x13 - x23) + sqr(x14 - x24))*
     b104 + sqrt(sqr(x13 - x25) + sqr(x14 - x26))*b105 + sqrt(sqr(x13 - x27) + 
     sqr(x14 - x28))*b106 + sqrt(sqr(x13 - x29) + sqr(x14 - x30))*b107 + sqrt(
     sqr(x15 - x17) + sqr(x16 - x18))*b108 + sqrt(sqr(x15 - x19) + sqr(x16 - 
     x20))*b109 + sqrt(sqr(x15 - x21) + sqr(x16 - x22))*b110 + sqrt(sqr(x15 - 
     x23) + sqr(x16 - x24))*b111 + sqrt(sqr(x15 - x25) + sqr(x16 - x26))*b112
      + sqrt(sqr(x15 - x27) + sqr(x16 - x28))*b113 + sqrt(sqr(x15 - x29) + sqr(
     x16 - x30))*b114 + sqrt(sqr(x17 - x19) + sqr(x18 - x20))*b115 + sqrt(sqr(
     x17 - x21) + sqr(x18 - x22))*b116 + sqrt(sqr(x17 - x23) + sqr(x18 - x24))*
     b117 + sqrt(sqr(x17 - x25) + sqr(x18 - x26))*b118 + sqrt(sqr(x17 - x27) + 
     sqr(x18 - x28))*b119 + sqrt(sqr(x17 - x29) + sqr(x18 - x30))*b120 + sqrt(
     sqr(x19 - x21) + sqr(x20 - x22))*b121 + sqrt(sqr(x19 - x23) + sqr(x20 - 
     x24))*b122 + sqrt(sqr(x19 - x25) + sqr(x20 - x26))*b123 + sqrt(sqr(x19 - 
     x27) + sqr(x20 - x28))*b124 + sqrt(sqr(x19 - x29) + sqr(x20 - x30))*b125
      + sqrt(sqr(x21 - x23) + sqr(x22 - x24))*b126 + sqrt(sqr(x21 - x25) + sqr(
     x22 - x26))*b127 + sqrt(sqr(x21 - x27) + sqr(x22 - x28))*b128 + sqrt(sqr(
     x21 - x29) + sqr(x22 - x30))*b129 + sqrt(sqr(x23 - x25) + sqr(x24 - x26))*
     b130 + sqrt(sqr(x23 - x27) + sqr(x24 - x28))*b131 + sqrt(sqr(x23 - x29) + 
     sqr(x24 - x30))*b132 + sqrt(sqr(x25 - x27) + sqr(x26 - x28))*b133 + sqrt(
     sqr(x25 - x29) + sqr(x26 - x30))*b134 + sqrt(sqr(x27 - x29) + sqr(x28 - 
     x30))*b135 - objvar =E= 0;

e2.. 0.0625*sqr(x1) - 8.875*x1 + 0.0177777777777778*sqr(x2) - 0.266666666666667
     *x2 =L= -315.0625;

e3.. 0.015625*sqr(x3) - 0.84375*x3 + 0.0625*sqr(x4) - 11.25*x4 =L= -516.640625;

e4.. 0.0330578512396694*sqr(x5) - 0.826446280991736*x5 + 0.0816326530612245*
     sqr(x6) - 6.61224489795918*x6 =L= -138.063248439872;

e5.. 0.0493827160493827*sqr(x7) - 8.44444444444444*x7 + 0.0277777777777778*sqr(
     x8) - 3.77777777777778*x8 =L= -488.444444444444;

e6.. 0.111111111111111*sqr(x9) - 16.2222222222222*x9 + sqr(x10) - 204*x10
      =L= -10995.1111111111;

e7.. 0.04*sqr(x11) - 4.64*x11 + 0.25*sqr(x12) - 23*x12 =L= -662.56;

e8.. 0.04*sqr(x13) - 3.76*x13 + sqr(x14) - 144*x14 =L= -5271.36;

e9.. 0.0816326530612245*sqr(x15) - 16.5714285714286*x15 + 0.0625*sqr(x16) - 2.5
     *x16 =L= -865;

e10.. 0.0493827160493827*sqr(x17) - 4.88888888888889*x17 + 0.015625*sqr(x18) - 
      2.375*x18 =L= -210.25;

e11.. 0.04*sqr(x19) - 6.48*x19 + 0.0330578512396694*sqr(x20) - 2.87603305785124
      *x20 =L= -323.993719008264;

e12.. 0.0204081632653061*sqr(x21) - 0.693877551020408*x21 + 0.0816326530612245*
      sqr(x22) - 7.91836734693877*x22 =L= -196.918367346939;

e13.. 0.0625*sqr(x23) - 11.375*x23 + 0.444444444444444*sqr(x24) - 
      76.8888888888889*x24 =L= -3842.00694444444;

e14.. 4*sqr(x25) - 52*x25 + 0.015625*sqr(x26) - 1.1875*x26 =L= -190.5625;

e15.. 0.0816326530612245*sqr(x27) - 0.571428571428571*x27 + 0.0330578512396694*
      sqr(x28) - 6.57851239669422*x28 =L= -327.280991735537;

e16.. 0.0625*sqr(x29) - 10.125*x29 + 0.04*sqr(x30) - 2.72*x30 =L= -455.3025;

e17..    b31 + b32 + b33 + b34 + b35 + b36 + b37 + b38 + b39 + b40 + b41 + b42
       + b43 + b44 =E= 2;

e18..    b31 + b45 + b46 + b47 + b48 + b49 + b50 + b51 + b52 + b53 + b54 + b55
       + b56 + b57 =E= 2;

e19..    b32 + b45 + b58 + b59 + b60 + b61 + b62 + b63 + b64 + b65 + b66 + b67
       + b68 + b69 =E= 2;

e20..    b33 + b46 + b58 + b70 + b71 + b72 + b73 + b74 + b75 + b76 + b77 + b78
       + b79 + b80 =E= 2;

e21..    b34 + b47 + b59 + b70 + b81 + b82 + b83 + b84 + b85 + b86 + b87 + b88
       + b89 + b90 =E= 2;

e22..    b35 + b48 + b60 + b71 + b81 + b91 + b92 + b93 + b94 + b95 + b96 + b97
       + b98 + b99 =E= 2;

e23..    b36 + b49 + b61 + b72 + b82 + b91 + b100 + b101 + b102 + b103 + b104
       + b105 + b106 + b107 =E= 2;

e24..    b37 + b50 + b62 + b73 + b83 + b92 + b100 + b108 + b109 + b110 + b111
       + b112 + b113 + b114 =E= 2;

e25..    b38 + b51 + b63 + b74 + b84 + b93 + b101 + b108 + b115 + b116 + b117
       + b118 + b119 + b120 =E= 2;

e26..    b39 + b52 + b64 + b75 + b85 + b94 + b102 + b109 + b115 + b121 + b122
       + b123 + b124 + b125 =E= 2;

e27..    b40 + b53 + b65 + b76 + b86 + b95 + b103 + b110 + b116 + b121 + b126
       + b127 + b128 + b129 =E= 2;

e28..    b41 + b54 + b66 + b77 + b87 + b96 + b104 + b111 + b117 + b122 + b126
       + b130 + b131 + b132 =E= 2;

e29..    b42 + b55 + b67 + b78 + b88 + b97 + b105 + b112 + b118 + b123 + b127
       + b130 + b133 + b134 =E= 2;

e30..    b43 + b56 + b68 + b79 + b89 + b98 + b106 + b113 + b119 + b124 + b128
       + b131 + b133 + b135 =E= 2;

e31..    b44 + b57 + b69 + b80 + b90 + b99 + b107 + b114 + b120 + b125 + b129
       + b132 + b134 + b135 =E= 2;

e32..    b35 + b37 + b39 + b44 + b92 + b94 + b99 + b109 + b114 + b125 =L= 4;

e33..    b37 + b39 + b44 + b109 + b114 + b125 =L= 3;

e34..    b31 + b33 + b34 + b35 + b36 + b37 + b38 + b39 + b41 + b43 + b44 + b46
       + b47 + b48 + b49 + b50 + b51 + b52 + b54 + b56 + b57 + b70 + b71 + b72
       + b73 + b74 + b75 + b77 + b79 + b80 + b81 + b82 + b83 + b84 + b85 + b87
       + b89 + b90 + b91 + b92 + b93 + b94 + b96 + b98 + b99 + b100 + b101
       + b102 + b104 + b106 + b107 + b108 + b109 + b111 + b113 + b114 + b115
       + b117 + b119 + b120 + b122 + b124 + b125 + b131 + b132 + b135 =L= 11;

e35..    b33 + b34 + b35 + b36 + b37 + b38 + b39 + b41 + b44 + b70 + b71 + b72
       + b73 + b74 + b75 + b77 + b80 + b81 + b82 + b83 + b84 + b85 + b87 + b90
       + b91 + b92 + b93 + b94 + b96 + b99 + b100 + b101 + b102 + b104 + b107
       + b108 + b109 + b111 + b114 + b115 + b117 + b120 + b122 + b125 + b132
       =L= 9;

* set non-default bounds
x1.lo = 67; x1.up = 75;
x2.up = 15;
x3.lo = 19; x3.up = 35;
x4.lo = 86; x4.up = 94;
x5.lo = 7; x5.up = 18;
x6.lo = 37; x6.up = 44;
x7.lo = 81; x7.up = 90;
x8.lo = 62; x8.up = 74;
x9.lo = 70; x9.up = 76;
x10.lo = 101; x10.up = 103;
x11.lo = 53; x11.up = 63;
x12.lo = 44; x12.up = 48;
x13.lo = 42; x13.up = 52;
x14.lo = 71; x14.up = 73;
x15.lo = 98; x15.up = 105;
x16.lo = 16; x16.up = 24;
x17.lo = 45; x17.up = 54;
x18.lo = 68; x18.up = 84;
x19.lo = 76; x19.up = 86;
x20.lo = 38; x20.up = 49;
x21.lo = 10; x21.up = 24;
x22.lo = 45; x22.up = 52;
x23.lo = 87; x23.up = 95;
x24.lo = 85; x24.up = 88;
x25.lo = 6; x25.up = 7;
x26.lo = 30; x26.up = 46;
x27.up = 7;
x28.lo = 94; x28.up = 105;
x29.lo = 77; x29.up = 85;
x30.lo = 29; x30.up = 39;

* set non-default levels
x1.l = 67;
x3.l = 19;
x4.l = 86;
x5.l = 7;
x6.l = 37;
x7.l = 81;
x8.l = 62;
x9.l = 70;
x10.l = 101;
x11.l = 53;
x12.l = 44;
x13.l = 42;
x14.l = 71;
x15.l = 98;
x16.l = 16;
x17.l = 45;
x18.l = 68;
x19.l = 76;
x20.l = 38;
x21.l = 10;
x22.l = 45;
x23.l = 87;
x24.l = 85;
x25.l = 6;
x26.l = 30;
x28.l = 94;
x29.l = 77;
x30.l = 29;

Model m / all /;

m.limrow=0; m.limcol=0;

$if NOT '%gams.u1%' == '' $include '%gams.u1%'

$if not set MINLP $set MINLP MINLP
Solve m using %MINLP% minimizing objvar;
