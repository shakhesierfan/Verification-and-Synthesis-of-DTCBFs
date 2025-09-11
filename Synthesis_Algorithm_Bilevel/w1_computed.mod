param Ts;
param mc;
param mp;
param g;
param L;

param k1; 
param k2;
param k3;
param k4;
param k5;

param A;
param B;
param C;
param D;
param E;

param lb {1..2};
param ub {1..2};

var x {i in 1..2} >= lb[i], <= ub[i];



minimize obj: A*(  x[2] + Ts*(-(k1*x[2]^2 + k2*x[1]^2 + k3*x[1]*x[2] + k4*x[2] + k5*x[1])*cos(x[1]) - mp*L*x[2]^2*cos(x[1])*sin(x[1]) + (mc+mp)*g*sin(x[1]))/(L*(mc + mp*sin(x[1])^2))   )^2 + B*( x[1] + x[2]*Ts  )^2 +  C*(  x[2] + Ts*(-(k1*x[2]^2 + k2*x[1]^2 + k3*x[1]*x[2] + k4*x[2] + k5*x[1])*cos(x[1]) - mp*L*x[2]^2*cos(x[1])*sin(x[1]) + (mc+mp)*g*sin(x[1]))/(L*(mc + mp*sin(x[1])^2))  )*( x[1] + x[2]*Ts  ) + D*(  x[2] + Ts*(-(k1*x[2]^2 + k2*x[1]^2 + k3*x[1]*x[2] + k4*x[2] + k5*x[1])*cos(x[1]) - mp*L*x[2]^2*cos(x[1])*sin(x[1]) + (mc+mp)*g*sin(x[1]))/(L*(mc + mp*sin(x[1])^2))  ) + E*( x[1] + x[2]*Ts  )  + 1 ;

subject to c1: -A*x[2]^2 - B*x[1]^2 - C*x[1]*x[2] - D*x[2] - E*x[1] - 1 <= 0;

