% oszczędna wersja DMC - parametry
Ke = 0;
for i = 1 : N
    Ke = Ke + K(1, i);
end
ku = K(1, :)*Mp

ku_str = "double ku[] = {"
for i = 1:length(ku)
    if i < length(ku)
        ku_str = ku_str + ku(i) + ",";
    else
        ku_str = ku_str + ku(i);
    end
end
ku_str = ku_str + "};"+newline;

ku_str = ku_str+"double ke = "+Ke+";"
