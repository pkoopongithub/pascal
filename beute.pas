
PROGRAM beute;
(******************************************************************)
(* Paul Koop M.A. Raeuber Beute System                            *)
(* Die Simulation wurde ursprunglich entwickelt,                  *)
(* um die Verwendbarkeit von Zellularautomaten                     *)
(* fuer die Algorithmisch Rekursive Sequanzanalyse                *)
(* zu ueberpruefen								*)
(* Modellcharakter hat allein der Quelltext. Eine Compilierung    *)
(* dient nur als Falsifikationsversuch                            *)
(******************************************************************)

USES dos,crt;
(*---------------------------- Datenstruktur ---------------------*)
CONST

 l = char(2);

TYPE
  s = 0..10;
 raum = array(.1..80,1..24.) of s;
 zahl = ^inhalt;
 inhalt = RECORD
           i:integer;
           v:zahl;
           n:zahl;
          END;
VAR
 a,b:raum;
 n,x,y,xa,ya:zahl;

(*---------------------------- Prozeduren -----------------------*)
PROCEDURE aufbau;
 VAR z:integer;
 BEGIN
  randomize;
  z := 1;
  new(n);
  xa := n;
  x := n;
  x^.i := z;
  REPEAT
   z := z +1;
   new(n);
   x^.n := n;
   n^.v := x;
   x := n;
   x^.i := z;
  UNTIL z = 80;
  x^.n := xa;
  xa^.v := x;

  z := 1;
  new(n);
  ya := n;
  y := n;
  y^.i := z;
  REPEAT
   z := z +1;
   new(n);
   y^.n := n;
   n^.v := y;
   y := n;
   y^.i := z;
  UNTIL z = 24;
  y^.n := ya;
  ya^.v := y;
 END;

PROCEDURE abbaux(x:zahl);
 BEGIN
  IF x^.n <> xa THEN abbaux(x^.n);
  dispose(x);
 END;

PROCEDURE abbauy(y:zahl);
 BEGIN
  IF y^.n <> ya THEN abbauy(y^.n);
  dispose(y);
 END;

PROCEDURE farbe (z:integer);
 BEGIN
  CASE z OF
   0:textcolor(0);
   1:textcolor(2);
   10:textcolor(12);
  END;
 END;

FUNCTION neu (VAR r:raum; VAR x,y:zahl):s;
 VAR z1,z2,z:integer;
 BEGIN
  z:=(
   r(.x^.v^.i,y^.v^.i.)+
   r(.x^.i   ,y^.v^.i.)+
   r(.x^.n^.i,y^.v^.i.)+
   r(.x^.v^.i,y^.i   .)+
   r(.x^.n^.i,y^.i   .)+
   r(.x^.v^.i,y^.n^.i.)+
   r(.x^.i   ,y^.n^.i.)+
   r(.x^.n^.i,y^.n^.i.));

  z2 := z div 10;
  z1 := z mod 10;

  IF (r(.x^.i,y^.i.) =0)
   THEN
    BEGIN
     IF z1 > 1
      THEN neu:= 1
      ELSE neu := 0
    END
   ELSE
    BEGIN
     IF (r(.x^.i,y^.i.) =1)
      THEN
       BEGIN
        IF z2  > 1
         THEN neu := 10
          ELSE
           BEGIN
            IF z1 in (.2,3.)
             THEN neu := 1
             ELSE neu := 0
           END
       END
      ELSE
       IF z1 <1
        THEN
          neu := 0
        ELSE
         BEGIN
          IF z2 in (.2,3.)
           THEN neu := 10
           ELSE neu := 0
         END
    END
 END;

PROCEDURE text_anfang;
 BEGIN
  window(1,25,80,25);
  textbackground(red);
  textcolor(white);
  clrscr;
  write('Koop Editor <F10>Zufall <Pfeil>Cursor <Einfg> Tier    <Entf> Tier <Return>Start');
  gotoxy(1,1);
  textcolor(2);
  textbackground(black);
  window(1,1,80,24);clrscr;window(1,1,80,25);
 END;

PROCEDURE text_ende;
 BEGIN
  gotoxy(1,25);
  textbackground(red);
  textcolor(white);
  write('Koop Status      <F1>neu       <F2>Editieren                      <RETURN> Ende');
  gotoxy(1,1);
  textcolor(2);
  textbackground(black);
 END;

PROCEDURE zufall(VAR von:raum);
 VAR x,y,z:integer;
 BEGIN
  randomize;gotoxy(1,1);
  FOR y := 1 TO 24
   DO
   FOR x := 1 TO 80
    DO
     BEGIN
      z := random(3);
      IF z = 2 THEN
         z := 10;
      von(.x,y.):=z;
      farbe(von(.x,y.));
      write(l)
     END;
 END;

PROCEDURE editor (VAR von:raum);
 var
    ch1,ch2 : char;
    xz,yz,z:integer;
  begin
  z :=0;
  x := xa;
  y:=ya;
  randomize;
  text_anfang;
  gotoxy(1,1);
  textcolor(0);
 FOR yz := 1 TO 24
   DO
   FOR xz := 1 TO 80
    DO
     BEGIN
     von(.xz,yz.) := 0;
     write(l);
     END;
   gotoxy(1,1);
   repeat
   ch1 := readkey;
   IF ch1 =#0
    THEN
    BEGIN
     ch2 := readkey;
     CASE ch2 OF
      #68 : BEGIN
             zufall(von);
            END;
      #72 : y :=y^.v;
      #80 : y :=y^.n;
      #75 : x :=x^.v;
      #77 : x :=x^.n;
      #71 : BEGIN
                y := y^.v;
                x := x^.v;
            END;
      #73 : BEGIN
                y := y^.v;
                x := x^.n;
            END;
      #81 : BEGIN
                y := y^.n;
                x := x^.n;
            END;
      #79 : BEGIN
                y := y^.n;
                x := x^.v;
            END;

      #82 : IF z = 0 THEN z := 1 ELSE
            IF z = 1 THEN z := 10 ELSE write(char(7));
      #83 : IF z = 10 THEN z := 1 ELSE
            IF z = 1  Then z := 0 ELSE write(char(7));
     ELSE
      write(char(7))
     END;
    gotoxy(x^.i,y^.i);
    von(.x^.i,y^.i.) := z;
    farbe(z);
    write(l);
    gotoxy(x^.i,y^.i);
    END
    ELSE write(char(7));
   until ch1 = #13;
   text_ende;
 END;


PROCEDURE korrektor (VAR von:raum);
 var
    ch1,ch2 : char;
    xz,yz,z:integer;
  begin;
  randomize;
  x:=xa;y:=ya;
  text_anfang;
  gotoxy(1,1);
  z := 0;
 FOR yz := 1 TO 24
   DO
   FOR xz := 1 TO 80
    DO
     BEGIN
     farbe(von(.xz,yz.));
     write(l);
     END;
   gotoxy(1,1);
   repeat
   ch1 := readkey;
   IF ch1 =#0
    THEN
    BEGIN
     ch2 := readkey;
     CASE ch2 OF
      #68 : BEGIN
             zufall(von);
            END;
      #72 : y :=y^.v;
      #80 : y :=y^.n;
      #75 : x :=x^.v;
      #77 : x :=x^.n;
      #71 : BEGIN
                y := y^.v;
                x := x^.v;
            END;
      #73 : BEGIN
                y := y^.v;
                x := x^.n;
            END;
      #81 : BEGIN
                y := y^.n;
                x := x^.n;
            END;
      #79 : BEGIN
                y := y^.n;
                x := x^.v;
            END;

      #82 : IF z = 0 THEN z := 1 ELSE
            IF z = 1 THEN z := 10 ELSE write(char(7));
      #83 : IF z = 10 THEN z := 1 ELSE
            IF z = 1  Then z := 0 ELSE write(char(7));

     ELSE
      write(char(7))
     END;
    gotoxy(x^.i,y^.i);
    von(.x^.i,y^.i.) := z;
    farbe(z);
    write(l);
    gotoxy(x^.i,y^.i);

    END
    ELSE write(char(7));
   until ch1 = #13;
   text_ende;
 END;



PROCEDURE spiel(VAR von,nach :raum);
 BEGIN
  y :=ya;
  x :=xa;
  REPEAT
   REPEAT
    nach(.x^.i,y^.i.) :=neu(von,x,y);
    farbe(nach(.x^.i,y^.i.));
    write(l);
    x := x^.n
   UNTIL x =xa;
   y := y^.n
  UNTIL y =ya;
 END;

PROCEDURE hauptprogramm;
 var
    ch1,ch2 : char;
    xz,yz:integer;
  begin
   IF keypressed THEN REPEAT ch1 := readkey UNTIL not(keypressed);
   repeat
   IF keypressed
    THEN
     BEGIN
      ch1 := readkey;
      IF ch1 =#0
       THEN
        BEGIN
         ch2 := readkey;
          CASE ch2 OF
           #59: BEGIN
                 x := xa;
                 abbaux(x);
                 y := ya;
                 abbauy(y);
                 aufbau;
                 editor(a);
                END;
           #60: korrektor(a);
          ELSE
          END;
         END
        ELSE;
     END
    ELSE
    BEGIN
     gotoxy(1,1);
     spiel(a,b);
     gotoxy(1,1);
     spiel(b,a);
    END
   until ch1 = #13;
 END;

(*------------------------------ Hauptprogramm -----------------*)
BEGIN
 checkbreak := false;
 aufbau;
 editor(a);
 hauptprogramm;
 x := xa;
 abbaux(x);
 y := ya;
 abbauy(y);
 textbackground(black);
 textcolor(white);
 clrscr;
 checkbreak := true;
END.
(************************************** ENDE ************)

