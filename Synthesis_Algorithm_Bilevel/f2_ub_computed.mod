param Ts;
param mc;
param mp;
param g;
param L;


param lb {1..18};
param ub {1..18};

var x {i in 1..18} >= lb[i], <= ub[i];


minimize obj: -x[18];

subject to c1:  -2*(2*x[2]*x[11] + x[3]*x[12] + x[5])*(x[1]*x[12]^2 + x[2]*x[11]^2 + x[3]*x[11]*x[12] + x[4]*x[12] + x[5]*x[11]) + x[13]*(-2*x[7]*x[11] - x[8]*x[12] - x[10]) - x[14] + x[15] == 0;
subject to c2:  -2*(2*x[1]*x[12] + x[3]*x[11] + x[4])*(x[1]*x[12]^2 + x[2]*x[11]^2 + x[3]*x[11]*x[12] + x[4]*x[12] + x[5]*x[11]) + x[13]*(-2*x[6]*x[12] - x[8]*x[11] - x[9] ) - x[16] + x[17] == 0;

subject to c3: x[13]*(-x[6]*x[12]^2 - x[7]*x[11]^2 - x[8]*x[11]*x[12] - x[9]*x[12] - x[10]*x[11] - 1) == 0;
subject to c4: x[14]*(lb[11] - x[11]) == 0;
subject to c5: x[15]*(x[11]  - ub[11]) == 0;
subject to c6: x[16]*(lb[12] - x[12]) == 0;
subject to c7: x[17]*(x[12]  - ub[12]) == 0;

subject to c8: - x[6]*x[12]^2 - x[7]*x[11]^2 - x[8]*x[11]*x[12] - x[9]*x[12] - x[10]*x[11] - 1 <= 0;

subject to c9: x[18] + (  x[1]*x[12]^2 + x[2]*x[11]^2 + x[3]*x[11]*x[12] + x[4]*x[12] + x[5]*x[11]  )^2 <= 0;
