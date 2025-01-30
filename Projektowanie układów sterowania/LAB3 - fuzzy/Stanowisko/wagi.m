function w = wagi(u)

if u <= -0.7
    w1 = 1;
    w2 = 0;
    w3 = 0;

elseif u > -0.7 && u < -0.4
    a1 = 10/3;  b11 = -4/3; b12 = 7/3;
    w1 = -a1*u + b11;
    w2 = a1*u + b12;
    w3 = 0;

elseif u >= -0.4 && u <= -0.2
    w1 = 0;
    w2 = 1;
    w3 = 0;

elseif u > -0.35 && u < 0.2
    X = 10/4 * (u + 0.2);
    bell = 2.^(X.^3) - 1;

    w1 = 0;
    w2 = -bell +1;
    w3 = bell;

elseif u >= 0.2
    w1 = 0;
    w2 = 0;
    w3 = 1;
end
w =[w1, w2, w3];