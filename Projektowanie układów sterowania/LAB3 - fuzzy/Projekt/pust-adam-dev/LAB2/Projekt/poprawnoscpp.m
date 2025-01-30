%{
Yk = symulacja_obiektu12y_p2(Ukm7,Ukm8,Zkm4,Zkm5,Ykm1,Ykm2)
 Parametry:
  Ukm7  -- u(k-7)
  Ukm8  -- u(k-8)
  Zkm4  -- z(k-4)
  Zkm5  -- z(k-5)
  Ykm1  -- y(k-1)
  Ykm2  -- y(k-2)
 Wartość zwracana:
  Yk    -- y(k)
%}

duration = 300;
u(1:duration) = 0;
z(1:duration) = 0;
y(1:duration) = 0;

for k=9:duration
    y(k) = symulacja_obiektu12y_p2(u(k-7), u(k-8), z(k-4), z(k-5), y(k-1), y(k-2));
end

stairs(y);