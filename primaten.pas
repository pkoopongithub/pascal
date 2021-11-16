(*Windows Free Pascal is developed by dr J.Szymanda under the GPL License*)
(*************************************************************************)
PROGRAM primaten;
(**********************************************************************)
(* Paul Koop M.A. primaten                                        *)
(* Die Simulation wurde ursprunglich entwickelt,                      *)
(* um die Verwendbarkeit von Zellularautomaten                        *)
(* fuer die Algorithmisch Rekursive Sequanzanalyse                    *)
(* zu ueberpruefen								    *)
(* Modellcharakter hat allein der Quelltext. Eine Compilierung        *)
(* dient nur als Falsifikationsversuch                                *)
(**********************************************************************)
USES dos,crt;

(*------------------------------------ Datenstruktur -----------------*)
CONST
 l = char(2);
 t = ' ';
TYPE
  primat = RECORD
           status,           (* 0,1,2 leer, jungtier, erfahrenes tier   *)
           alter,            (* 0...9 *)
           geschlecht,       (* 0 1 w 2 m *)
           kultur,           (* 0..9 *)
           macht       :0..9;(* 0..9 *)
          END;  
          
 raum = array(.1..80,1..24.) of primat;
 zahl = ^inhalt;
 inhalt = RECORD
           i:integer;
           v:zahl;
           n:zahl;
          END;
VAR
 a,b:raum;
 n,x,y,xa,ya:zahl;

(*---------------------------------------- Prozeduren ---------------*)
PROCEDURE aufbau;
 VAR z:integer;
 BEGIN
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
 
PROCEDURE farbe (p:primat);
 (*
 textcolor(white);value  color
  0    Black
  1    Blue
  2    Green
  3    Cyan
  4    Red
  5    Magenta
  6    Brown
  7    White
*)
 BEGIN
 if p.status = 0 then textcolor(black)
 else
 if p.status = 1 then
  begin
   if p.geschlecht = 1 then textcolor(Cyan)
   else textcolor(Magenta);
  end
 else
  begin
   if p.geschlecht = 2 then textcolor(Green)
   else textcolor(Red);
  end 
 END;
 
FUNCTION neu (VAR r:raum; VAR x,y:zahl):primat;
VAR z:integer;
  FUNCTION umgebungleer (VAR r:raum; VAR x,y:zahl):boolean;
   VAR z:integer;
  BEGIN
   z := 0;
  IF r(.x^.v^.i,y^.v^.i.).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF r(.x^.i   ,y^.v^.i.).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF r(.x^.n^.i,y^.v^.i.).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF r(.x^.v^.i,y^.i   .).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF r(.x^.n^.i,y^.i   .).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF r(.x^.v^.i,y^.n^.i.).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF r(.x^.i   ,y^.n^.i.).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF r(.x^.n^.i,y^.n^.i.).kultur <>r(.x^.i,y^.i.).kultur THEN z := z +1;
  IF z=8
   THEN umgebungleer:= true
    ELSE umgebungleer:= false;
  END;

  FUNCTION umgebungmaennlichererwachsener (VAR r:raum; VAR x,y:zahl):boolean;
   VAR z:integer;
  BEGIN
   z := 0;
  IF (r(.x^.v^.i,y^.v^.i.).status =2) and (r(.x^.v^.i,y^.v^.i.).geschlecht =2) and (r(.x^.v^.i,y^.v^.i.).kultur<> r(.x^.i,y^.i.).kultur) THEN z := z +1;
  IF (r(.x^.i   ,y^.v^.i.).status =2) and (r(.x^.i   ,y^.v^.i.).geschlecht =2) and (r(.x^.i   ,y^.v^.i.).kultur<> r(.x^.i,y^.i.).kultur)  THEN z := z +1;
  IF (r(.x^.n^.i,y^.v^.i.).status =2) and (r(.x^.n^.i,y^.v^.i.).geschlecht =2) and (r(.x^.n^.i,y^.v^.i.).kultur<> r(.x^.i,y^.i.).kultur)  THEN z := z +1;
  IF (r(.x^.v^.i,y^.i   .).status =2) and (r(.x^.v^.i,y^.i   .).geschlecht =2) and (r(.x^.v^.i,y^.i   .).kultur<> r(.x^.i,y^.i.).kultur)  THEN z := z +1;
  IF (r(.x^.n^.i,y^.i   .).status =2) and (r(.x^.n^.i,y^.i   .).geschlecht =2) and (r(.x^.n^.i,y^.i   .).kultur<> r(.x^.i,y^.i.).kultur)  THEN z := z +1;
  IF (r(.x^.v^.i,y^.n^.i.).status =2) and (r(.x^.v^.i,y^.n^.i.).geschlecht =2) and (r(.x^.v^.i,y^.n^.i.).kultur<> r(.x^.i,y^.i.).kultur)  THEN z := z +1;
  IF (r(.x^.i   ,y^.n^.i.).status =2) and (r(.x^.i   ,y^.n^.i.).geschlecht =2) and (r(.x^.i   ,y^.n^.i.).kultur<> r(.x^.i,y^.i.).kultur)  THEN z := z +1;
  IF (r(.x^.n^.i,y^.n^.i.).status =2) and (r(.x^.i   ,y^.n^.i.).geschlecht =2) and (r(.x^.i   ,y^.n^.i.).kultur<> r(.x^.i,y^.i.).kultur)  THEN z := z +1;
  IF z=0
   THEN Umgebungmaennlichererwachsener:= false
    ELSE Umgebungmaennlichererwachsener:= true;
  END;

  PROCEDURE kind (VAR r:raum; VAR x,y:zahl);
  TYPE
  elter= RECORD
          m,w: boolean;
          macht:0..9;
         END;

  VAR
  i,ym,k:integer;
  eltern: array(.1..9.) of elter;

  BEGIN
  FOR i:=1 TO 9 DO BEGIN eltern[i].w:=false; eltern[i].m:=false;eltern[i].macht:=0; END;
  IF (r(.x^.v^.i,y^.v^.i.).status =2) THEN BEGIN IF r(.x^.v^.i,y^.v^.i.).geschlecht= 1 THEN eltern[r(.x^.v^.i,y^.v^.i.).kultur].w:=true ELSE IF r(.x^.v^.i,y^.v^.i.).geschlecht= 2 THEN BEGIN eltern[r(.x^.v^.i,y^.v^.i.).kultur].m:=true; IF r(.x^.v^.i,y^.v^.i.).macht>  eltern[r(.x^.v^.i,y^.v^.i.).kultur].macht THEN eltern[r(.x^.v^.i,y^.v^.i.).kultur].macht:=r(.x^.v^.i,y^.v^.i.).macht END; END;
  IF (r(.x^.i   ,y^.v^.i.).status =2) THEN BEGIN IF r(.x^.i   ,y^.v^.i.).geschlecht= 1 THEN eltern[r(.x^.i   ,y^.v^.i.).kultur].w:=true ELSE IF r(.x^.i   ,y^.v^.i.).geschlecht= 2 THEN BEGIN eltern[r(.x^.i   ,y^.v^.i.).kultur].m:=true; IF r(.x^.i   ,y^.v^.i.).macht>  eltern[r(.x^.i   ,y^.v^.i.).kultur].macht THEN eltern[r(.x^.i   ,y^.v^.i.).kultur].macht:=r(.x^.i   ,y^.v^.i.).macht END; END;
  IF (r(.x^.n^.i,y^.v^.i.).status =2) THEN BEGIN IF r(.x^.n^.i,y^.v^.i.).geschlecht= 1 THEN eltern[r(.x^.n^.i,y^.v^.i.).kultur].w:=true ELSE IF r(.x^.n^.i,y^.v^.i.).geschlecht= 2 THEN BEGIN eltern[r(.x^.n^.i,y^.v^.i.).kultur].m:=true; IF r(.x^.n^.i,y^.v^.i.).macht>  eltern[r(.x^.n^.i,y^.v^.i.).kultur].macht THEN eltern[r(.x^.n^.i,y^.v^.i.).kultur].macht:=r(.x^.n^.i,y^.v^.i.).macht END; END;
  IF (r(.x^.v^.i,y^.i   .).status =2) THEN BEGIN IF r(.x^.v^.i,y^.i   .).geschlecht= 1 THEN eltern[r(.x^.v^.i,y^.i   .).kultur].w:=true ELSE IF r(.x^.v^.i,y^.i   .).geschlecht= 2 THEN BEGIN eltern[r(.x^.v^.i,y^.i   .).kultur].m:=true; IF r(.x^.v^.i,y^.i   .).macht>  eltern[r(.x^.v^.i,y^.i   .).kultur].macht THEN eltern[r(.x^.v^.i,y^.i   .).kultur].macht:=r(.x^.v^.i,y^.i   .).macht END; END;
  IF (r(.x^.n^.i,y^.i   .).status =2) THEN BEGIN IF r(.x^.n^.i,y^.i   .).geschlecht= 1 THEN eltern[r(.x^.n^.i,y^.i   .).kultur].w:=true ELSE IF r(.x^.n^.i,y^.i   .).geschlecht= 2 THEN BEGIN eltern[r(.x^.n^.i,y^.i   .).kultur].m:=true; IF r(.x^.n^.i,y^.i   .).macht>  eltern[r(.x^.n^.i,y^.i   .).kultur].macht THEN eltern[r(.x^.n^.i,y^.i   .).kultur].macht:=r(.x^.n^.i,y^.i   .).macht END; END;
  IF (r(.x^.v^.i,y^.n^.i.).status =2) THEN BEGIN IF r(.x^.v^.i,y^.n^.i.).geschlecht= 1 THEN eltern[r(.x^.v^.i,y^.n^.i.).kultur].w:=true ELSE IF r(.x^.v^.i,y^.n^.i.).geschlecht= 2 THEN BEGIN eltern[r(.x^.v^.i,y^.n^.i.).kultur].m:=true; IF r(.x^.v^.i,y^.n^.i.).macht>  eltern[r(.x^.v^.i,y^.n^.i.).kultur].macht THEN eltern[r(.x^.v^.i,y^.n^.i.).kultur].macht:=r(.x^.v^.i,y^.n^.i.).macht END; END;
  IF (r(.x^.i   ,y^.n^.i.).status =2) THEN BEGIN IF r(.x^.i   ,y^.n^.i.).geschlecht= 1 THEN eltern[r(.x^.i   ,y^.n^.i.).kultur].w:=true ELSE IF r(.x^.i   ,y^.n^.i.).geschlecht= 2 THEN BEGIN eltern[r(.x^.i   ,y^.n^.i.).kultur].m:=true; IF r(.x^.i   ,y^.n^.i.).macht>  eltern[r(.x^.i   ,y^.n^.i.).kultur].macht THEN eltern[r(.x^.i   ,y^.n^.i.).kultur].macht:=r(.x^.i   ,y^.n^.i.).macht END; END;
  IF (r(.x^.n^.i,y^.n^.i.).status =2) THEN BEGIN IF r(.x^.n^.i,y^.n^.i.).geschlecht= 1 THEN eltern[r(.x^.n^.i,y^.n^.i.).kultur].w:=true ELSE IF r(.x^.n^.i,y^.n^.i.).geschlecht= 2 THEN BEGIN eltern[r(.x^.n^.i,y^.n^.i.).kultur].m:=true; IF r(.x^.n^.i,y^.n^.i.).macht>  eltern[r(.x^.n^.i,y^.n^.i.).kultur].macht THEN eltern[r(.x^.n^.i,y^.n^.i.).kultur].macht:=r(.x^.n^.i,y^.n^.i.).macht END; END;
  ym:=0;k:=0;
  FOR i:=1 TO 9 DO
   BEGIN
   IF (eltern[i].w=true and  eltern[i].m=true)
    THEN
     BEGIN
      IF eltern[i].macht >ym THEN BEGIN ym:=eltern[i].macht;k:=i END
     END
   END;
   IF ((ym>0)and(k>0)) THEN
   BEGIN
   neu.Status:= 1;
   neu.alter:=0;
   neu.macht:=ym;
   neu.geschlecht:=random(2)+1;
   neu.kultur:=k;
   END
  ELSE
  neu:=r(.x^.i,y^.i.);

  END;

  FUNCTION kulturstaerkstesmaennchenannehmen (VAR r:raum; VAR x,y:zahl):integer;
   VAR z:integer;
  BEGIN
   z := 0;
  IF (r(.x^.v^.i,y^.v^.i.).status =2) and (r(.x^.v^.i,y^.v^.i.).macht>z) and (r(.x^.v^.i,y^.v^.i.).geschlecht=2) THEN z := r(.x^.v^.i,y^.v^.i.).kultur;
  IF (r(.x^.i   ,y^.v^.i.).status =2) and (r(.x^.i   ,y^.v^.i.).macht>z) and (r(.x^.i   ,y^.v^.i.).geschlecht=2) THEN z := r(.x^.i   ,y^.v^.i.).kultur;
  IF (r(.x^.n^.i,y^.v^.i.).status =2) and (r(.x^.n^.i,y^.v^.i.).macht>z) and (r(.x^.n^.i,y^.v^.i.).geschlecht=2) THEN z := r(.x^.n^.i,y^.v^.i.).kultur;
  IF (r(.x^.v^.i,y^.i   .).status =2) and (r(.x^.v^.i,y^.i   .).macht>z) and (r(.x^.v^.i,y^.i   .).geschlecht=2) THEN z := r(.x^.v^.i,y^.i   .).kultur;
  IF (r(.x^.n^.i,y^.i   .).status =2) and (r(.x^.n^.i,y^.i   .).macht>z) and (r(.x^.n^.i,y^.i   .).geschlecht=2) THEN z := r(.x^.n^.i,y^.i   .).kultur;
  IF (r(.x^.v^.i,y^.n^.i.).status =2) and (r(.x^.v^.i,y^.n^.i.).macht>z) and (r(.x^.v^.i,y^.n^.i.).geschlecht=2) THEN z := r(.x^.v^.i,y^.n^.i.).kultur;
  IF (r(.x^.i   ,y^.n^.i.).status =2) and (r(.x^.i   ,y^.n^.i.).macht>z) and (r(.x^.i   ,y^.n^.i.).geschlecht=2) THEN z := r(.x^.i   ,y^.n^.i.).kultur;
  IF (r(.x^.n^.i,y^.n^.i.).status =2) and (r(.x^.n^.i,y^.n^.i.).macht>z) and (r(.x^.n^.i,y^.n^.i.).geschlecht=2) THEN z := r(.x^.n^.i,y^.n^.i.).kultur;
  IF z=0
   THEN kulturstaerkstesmaennchenannehmen:= 0
    ELSE kulturstaerkstesmaennchenannehmen:= z;
  END;

  FUNCTION staerkeresmaennchen (VAR r:raum; VAR x,y:zahl):boolean;
   VAR i,z:integer;
  BEGIN
   i:=0;z := r(.x^.i,y^.i.).macht;
  IF (r(.x^.v^.i,y^.v^.i.).status =2) and (r(.x^.v^.i,y^.v^.i.).macht>z) and (r(.x^.v^.i,y^.v^.i.).geschlecht=2) THEN i:=i+1;
  IF (r(.x^.i   ,y^.v^.i.).status =2) and (r(.x^.i   ,y^.v^.i.).macht>z) and (r(.x^.i   ,y^.v^.i.).geschlecht=2) THEN i:=i+1;
  IF (r(.x^.n^.i,y^.v^.i.).status =2) and (r(.x^.n^.i,y^.v^.i.).macht>z) and (r(.x^.n^.i,y^.v^.i.).geschlecht=2) THEN i:=i+1;
  IF (r(.x^.v^.i,y^.i   .).status =2) and (r(.x^.v^.i,y^.i   .).macht>z) and (r(.x^.v^.i,y^.i   .).geschlecht=2) THEN i:=i+1;
  IF (r(.x^.n^.i,y^.i   .).status =2) and (r(.x^.n^.i,y^.i   .).macht>z) and (r(.x^.n^.i,y^.i   .).geschlecht=2) THEN i:=i+1;
  IF (r(.x^.v^.i,y^.n^.i.).status =2) and (r(.x^.v^.i,y^.n^.i.).macht>z) and (r(.x^.v^.i,y^.n^.i.).geschlecht=2) THEN i:=i+1;
  IF (r(.x^.i   ,y^.n^.i.).status =2) and (r(.x^.i   ,y^.n^.i.).macht>z) and (r(.x^.i   ,y^.n^.i.).geschlecht=2) THEN i:=i+1;
  IF (r(.x^.n^.i,y^.n^.i.).status =2) and (r(.x^.n^.i,y^.n^.i.).macht>z) and (r(.x^.n^.i,y^.n^.i.).geschlecht=2) THEN i:=i+1;
  IF I=0
   THEN  staerkeresmaennchen:= false
    ELSE staerkeresmaennchen:= true;
  END;

 BEGIN
   r(.x^.i,y^.i.).alter:=r(.x^.i,y^.i.).alter+1;
   neu:=r(.x^.i,y^.i.);

    IF r(.x^.i,y^.i.).status = 0 (* status leeres feld*)
     THEN
      BEGIN
        kind (r,x,y);
      END
     ELSE
     BEGIN
      IF umgebungleer(r,x,y) or (neu.alter>8)  (* vereinzeltes individuum umgebung leer vereinsamt oder hoechtlebensalter errecht *)
       THEN
        BEGIN
          neu.status:=0;
          neu.alter:=0;
          neu.geschlecht:=0;
          neu.kultur:=0;
          neu.macht:=0;
        END
       ELSE
       BEGIN
        IF r(.x^.i,y^.i.).status = 1 (* jungtier weiblich m�nnlich*)
         THEN
          BEGIN
           (* wenn umgebung m�nnlicher silberr�cken anderer kultur dann status auf leer*)
           IF umgebungmaennlichererwachsener(r,x,y)
            THEN
             BEGIN
              neu.status:=0;
              neu.alter:=0;
              neu.geschlecht:=0;
              neu.kultur:=0;
              neu.macht:=0;
             END
         ELSE
          BEGIN                      (* erfahrene Tiere *)
           (* wenn weiblich dann Kultur des silberr�cken annehmen*)
            IF (r(.x^.i,y^.i.).geschlecht=1)
             THEN
              BEGIN
               neu.status:=2;
               neu.geschlecht:=1;
               neu.kultur:=kulturstaerkstesmaennchenannehmen (r,x,y);
               neu.macht:=r(.x^.i,y^.i.).macht;
               IF neu.kultur=0
                 THEN
                  BEGIN
                   neu.status:=0;
                   neu.alter:=0;
                   neu.geschlecht:=0;
                   neu.kultur:=0;
                   neu.macht:=0;
                  END
              END;

           (* wenn m�nnliches tier *)
           IF (r(.x^.i,y^.i.).geschlecht=2)
              (* und st�rkere m�nnchen  dann leer*)
              THEN
               BEGIN
                IF (staerkeresmaennchen (r,x,y))
                 THEN
                  BEGIN
                   neu.status:=0;
                   neu.alter:=0;
                   neu.geschlecht:=0;
                   neu.kultur:=0;
                   neu.macht:=0;
                  END
                  (* sonst randomisiere macht machtkampf*)
                  ELSE
                  BEGIN
                   neu.status:=2;
                   neu.geschlecht:=2;
                   neu.kultur:=r(.x^.i,y^.i.).kultur;
                   z:=random(15);
                   IF z>9 THen z:=0; neu.macht:=z;
                  END;
                  IF neu.macht=0
                   THEN
                    BEGIN
                    neu.status:=0;
                    neu.alter:=0;
                    neu.geschlecht:=0;
                    neu.kultur:=0;
                    neu.macht:=0;
                  END
                 END
          END
        END
      END
   END
 END;




PROCEDURE text_anfang;
 BEGIN
  window(1,25,80,25);
  textbackground(red);
  textcolor(white);
  clrscr;
  write('Koop Editor <F10>Zufall <Pfeil>Cursor <Einfg>lebendig <Entf>tot <Return>Start');
  gotoxy(1,1);
  textcolor(2);
  textbackground(blue);
  window(1,1,80,24);clrscr;window(1,1,80,25);
 END;

PROCEDURE text_ende;
 BEGIN
  gotoxy(1,25);
  textbackground(red);
  textcolor(white);
  write('Koop  Primaten                                                  <RETURN> Ende');
  gotoxy(1,1);
  textcolor(2);
  textbackground(blue);
 END;

PROCEDURE zufall(VAR von:raum);
 VAR x,y,z:integer;
 BEGIN
   FOR y := 1 TO 24
   DO
   FOR x := 1 TO 80
    DO
     BEGIN
      von(.x,y.).status:=random(3);
      IF von(.x,y.).status=0
      THEN
      BEGIN
       von(.x,y.).geschlecht:=0;
       von(.x,y.).macht:=0;
       von(.x,y.).kultur:=0;
      END
      ELSE
      BEGIN
       von(.x,y.).geschlecht:=random(2)+1;
       von(.x,y.).macht:=random(9)+1;
       von(.x,y.).kultur:=random(9)+1;
      END;
     END;
 END; 




PROCEDURE spiel(VAR von,nach :raum);
 BEGIN
  y :=ya;
  x :=xa;
  REPEAT
   REPEAT
    nach(.x^.i,y^.i.):=neu(von,x,y);
    IF nach(.x^.i,y^.i.).status=0 
    THEN WRITE(t) ELSE BEGIN farbe (nach(.x^.i,y^.i.)); WRITE(nach(.x^.i,y^.i.).kultur) end;
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
   zufall(a);
   repeat
     gotoxy(1,1);
     spiel(a,b);
     gotoxy(1,1);
     spiel(b,a);

   until keypressed;
 END;

(*-------------------------------------- Hauptprogramm -----------------*)
BEGIN
 checkbreak := false;
 aufbau;
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
(************************************************** ENDE ****************)

