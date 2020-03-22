program project1;
uses graph, wincrt;

const
  sirka = 550;
  vyska = 400;

type
  hrac = record
    meno: string;
    vyhrateMedzihry, vyhrateHry, tah, celkVyhrateMedzihry: integer;
  end;

var gd, gm, x0Plocha, y0Plocha,
    pocetMedzihier, pocetHier: smallint;
  hrac1, hrac2: hrac;
  koniec: boolean;
  ch: char;

procedure pozadie(); 
var okraj: integer;
begin  
  okraj := 5;

  setfillstyle(1, lightgray);
  bar(x0Plocha - okraj, y0Plocha - okraj,
      x0Plocha + sirka + okraj, y0Plocha + vyska + okraj);

  setfillstyle(1, black);
  bar(x0Plocha, y0Plocha, x0Plocha + sirka, y0Plocha + vyska);
end;

procedure plocha();
var s1, s2: string;
begin
  pozadie();

  // mena hracov
  outtextxy(x0Plocha + 10, y0Plocha + 10, hrac1.meno);
  outtextxy(x0Plocha + sirka - length(hrac2.meno) * 10 - 5, y0Plocha + 10, hrac2.meno);
                             
  // cislo hry   
  str(pocetHier, s1);
  outtextxy(x0Plocha + sirka div 2 - 70, y0Plocha + 10, 'Hra c.' + s1);

  // priebezne medzi-skore
  str(hrac1.vyhrateMedzihry, s1); 
  str(hrac2.vyhrateMedzihry, s2);
  outtextxy(x0Plocha + sirka div 2 - 70, y0Plocha + 30, 'Medzi-skore: ' + s1 + ' : ' + s2);

  // skore
  str(hrac1.vyhrateHry, s1);
  str(hrac2.vyhrateHry, s2);
  outtextxy(x0Plocha + sirka div 2 - 70, y0Plocha + 50, 'Skore: ' + s1 + ' : ' + s2);

end;

procedure kamen(x, y: integer);
var i: integer;
begin
  setcolor(lightgray);

  circle(x, y, 15);
  for i := 1 to 6 do
  begin
    line(x + random(20) - 10, y + random(20) - 10,
         x + random(20) - 10, y + random(20) - 10)
  end;
                                      
  setcolor(white);
  outtextxy(x - 15, y + 20, 'kamen');
end;

procedure papier(x0, y0: integer);
begin  
  rectangle(x0, y0, x0 + 30, y0 + 40);
  outtextxy(x0 - 5, y0 + 50, 'papier');
end;

procedure noznice(x0, y0: integer);
begin
  line(x0, y0, x0 + 30, y0 - 10);
  line(x0, y0 - 10, x0 + 30, y0);
  circle(x0, y0 + 5, 5);
  circle(x0, y0 - 15, 5);
  outtextxy(x0 - 10, y0 + 15, 'noznice');
end;

procedure menoHraca(x0, y0, cislo: integer; var meno: string);
var ch: char;
  s: string;
begin
  str(cislo, s);
  outtextxy(x0, y0, 'Meno hraca c.' + s + ':');
  repeat
    ch := readkey;

    if((ch >= 'a') and (ch <= 'z')) or ((ch >= 'A') and (ch <= 'Z')) or
      (ch = chr(32)) then
      meno := meno + ch

    else if(ch = chr(8)) then
    begin
      setcolor(black);
      outtextxy(x0, y0 + 15, meno);
      setcolor(white);

      meno := copy(meno, 1, length(meno) - 1);
    end;

    outtextxy(x0, y0 + 15, meno);
  until (ch = chr(13)) and (length(meno) > 0);
end;

procedure nakresliTah(x, y, tah: integer);
begin
  case tah of 
    0: kamen(x, y);
    1: papier(x, y);
    2: noznice(x + 10, y);
  end;
end;

function zistiVitaza(tah1, tah2: integer): integer;
begin
  zistiVitaza := 1;

  if(tah1 = tah2) then zistiVitaza := 0
  else if((tah1 = 0) and (tah2 = 1)) or
         ((tah1 = 1) and (tah2 = 2)) or
         ((tah1 = 2) and (tah2 = 0)) then zistiVitaza := 2;
end;

procedure hracStat(x0, y0: integer; hr: hrac);
var s: string;
begin 
  outtextxy(x0, y0, hr.meno);

  str(hr.vyhrateHry, s);
  outtextxy(x0, y0 + 20, 'Vyhrate hry: ' + s);

  str(hr.celkVyhrateMedzihry, s);
  outtextxy(x0, y0 + 40, 'Vyhrate medzi-hry: ' + s);
end;

procedure sumar(x0, y0: integer);
begin
  pozadie();
  hracStat(x0, y0, hrac1); 
  hracStat(x0 + 300, y0, hrac2);

  outtextxy(x0, y0 + 200, 'Stlacte lubovolnu klaves.');
  repeat until keypressed;
end;

begin
  randomize;
  gd := detect;
  initgraph(gd, gm, '');
                       
  pocetHier := 0;
  pocetMedzihier := 0;

  x0Plocha := getmaxx div 2 - sirka div 2;
  y0Plocha := getmaxy div 2 - vyska div 2;
                             
  pozadie();
  menoHraca(x0Plocha + 5, y0Plocha + 10, 1, hrac1.meno);
  menoHraca(x0Plocha + 5, y0Plocha + 40, 2, hrac2.meno);

  repeat
    pocetHier := pocetHier + 1;
    hrac1.vyhrateMedzihry := 0; 
    hrac2.vyhrateMedzihry := 0; 

    // 1 hra
    repeat
      pocetMedzihier := pocetMedzihier + 1;

      hrac1.tah := random(3);
      hrac2.tah := random(3);

      if(zistiVitaza(hrac1.tah, hrac2.tah) = 1) then
        hrac1.vyhrateMedzihry:= hrac1.vyhrateMedzihry + 1

      else if(zistiVitaza(hrac1.tah, hrac2.tah) = 2) then
        hrac2.vyhrateMedzihry:= hrac2.vyhrateMedzihry + 1;

      plocha();
      nakresliTah(x0Plocha + 50, y0Plocha + 100, hrac1.tah);
      nakresliTah(x0Plocha + sirka - 100, y0Plocha + 100, hrac2.tah);
      delay(2000);

    until (hrac1.vyhrateMedzihry = 3) or (hrac2.vyhrateMedzihry = 3);

    hrac1.celkVyhrateMedzihry := hrac1.celkVyhrateMedzihry + hrac1.vyhrateMedzihry;
    hrac2.celkVyhrateMedzihry := hrac2.celkVyhrateMedzihry + hrac2.vyhrateMedzihry;

    // vyhodnotenie hry
    if(hrac1.vyhrateMedzihry = 3) then
    begin
      outtextxy(x0Plocha + 5, y0Plocha + vyska - 30, 'Vitaz tejto hry: ' + hrac1.meno);
      hrac1.vyhrateHry := hrac1.vyhrateHry + 1;
    end

    else
    begin
      outtextxy(x0Plocha + 5, y0Plocha + vyska - 30, 'Vitaz tejto hry: ' + hrac2.meno);
      hrac2.vyhrateHry := hrac2.vyhrateHry + 1;
    end;

    outtextxy(x0Plocha + 5, y0Plocha + vyska - 10, 'Nova hra? y/n');

    ch := readkey;
    if(ch = 'y') then koniec := False
    else if(ch = 'n') then
    begin
      koniec := True;
      sumar(x0Plocha + 10, y0Plocha + 10);
    end;

  until koniec;

  closegraph();
end.

