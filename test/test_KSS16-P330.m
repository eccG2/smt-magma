/*The parameters of KSS16-P330*/
z:=-2^34+2^27-2^23+2^20-2^11+1;
r:=(z^8+48*z^4+625) div 61250;
t:=(2*z^5+41*z+35)div 35;
p:=(z^10+2*z^9+5*z^8+48*z^6+152*z^5+240*z^4+625*z^2+2398*z+3125) div 980;
Fp:=GF(p);
F4<u>:=ExtensionField<Fp,u|u^4-2>;
F8<v>:=ExtensionField<F4,v|v^2-u>;
F16<w>:=ExtensionField<F8,w|w^2-v>;
E:=EllipticCurve([Fp|1,0]);
E16:=EllipticCurve([F16|1,0]);
Et:=EllipticCurve([F4|1/u,0]);
w2:=w^2;w3:=w^3;w2_inv:=1/w^2;w3_inv:=1/w^3;
cof1:=#E div r;
cof2:=#Et div r;
coft:=(p^8+1) div r;
/*GLV endmorphism: (x,y)->(-x, w1*y)*/
w1:=1397526673901221633252361236831912010293633274947582434767626117420921301179434\
231476966992563652766;
//cof1;cof2;coft;
cof1:=18175286779415363072500;
cof2:=1737088188345553764757045758765702588830041260581523160930168501985570452952324\
1627189098016772116258650563057168661783726656302979599862596052241004728368219\
0808848120582558164080548244166438733867914138417549122781213224649802580880218\
1618401459399747635790918043882804422916775029577011815998790000606928177053954\
70434;
coft:=3523243510908766799289284573538791007202442855313941443532121790582899679806570\
1386095754698357987148473239801356042755300598361053727086539987683048583174153\
4162348510234219487711727126942730550181085130023084890802021309801456321184186\
9449152321411115513019484142871686834970557010464823282075712841442061887243759\
6780011100400883524557045900896950974835336288537876173246187617273533268657887\
5710479532352379472546177256570003666961829376008544823759296752013779083338304\
8161124925428423704258373299919527837816379662611429093398826070276190131375946\
3199234987138906002034225670540088564670419931115917088689216938459668920895706\
6434237846871151695609262091235303554523454412770256314536186743230235765580801\
0880194;
function endmo(Q,i)
        R:=Q;
        for t:=1 to i do
        R:=E16![w2*R[1],w3*R[2],1];
        R:=E16![R[1]^p,R[2]^p,1];
        R:=Et![w2_inv*R[1],w3_inv*R[2],1];
        end for;
        return R;
end function;
//*********************************G1 memebrship testing***************************//
//********************[a0, a1]=[(31z^4+625)/8750, -(17x^4+625)/8750]***************//
//*we use [17a0, 17a1] for the short vector*//

a1:=-(17*z^4+625) div 8750;
repeat
Q:=cof1*Random(E);
until Q[3] eq 1;
time_begin:=Cputime();
for i:=1 to 100 do
R:=a1*Q;
R2:=2*R;R4:=2*R2;R8:=2*R4;R16:=2*R8;R17:=R16+R;R32:=2*R16;R31:=R32-R;
R:=E![-R17[1], w1*R17[2],1]-R31;
end for;
T:=Cputime(time_begin);
if R[1] eq Q[1] and R[2] eq Q[2] then 
printf"PASS! The point is a member of G1\n";
else 
printf"REJECT! The point is NOT a member of G1\n";
end if;  
printf"Timing of the G1 memerbship testing  is %o*10^-2\n",T;
//****************G2 memebrship testing*************//
//****************the vector C=[c0,c1,..c7]*************//
//*c6=(-z-25)/70, c2=c3=3c6+1,c1=-3c2, c5=2c2+c6+1,c4=-2c5+c6+1,c0=c_7=2c6-c1+1*//
u:=(-z-25) div 70;
c6:=u;c2:=3*c6+1;c1:=-3*c2;c5:=2*c2+c6+1;c4:=-2*c5+c6+1;c0:=2*c6-c1+1;
repeat
Q:=cof2*Random(Et);
until Q[3] ne 0;
time_begin:=Cputime();
for i:=1 to 100 do
R6:=u*Q;T1:=R6+Q;T2:=T1+R6;
R3:=R6+T2;R2:=R3;T3:=2*R2;
R1:=-T3-R2;
R5:=T1+T3;
R4:=T1-2*R5;
R0:=T2-R1;
R7:=endmo(R0,7);
R0:=R0+endmo(R1,1)+endmo(R2,2)+endmo(R3,3)+endmo(R4,4)+endmo(R5,5)+endmo(R6,6);
end for;
T:=Cputime(time_begin);
if R0[1] eq  R7[1] and R0[2] eq -R7[2] then 
printf"PASS! The point is a member of G2\n";
else 
printf"REJECT! The point is NOT a member of G2\n";
end if;  
printf"Timing of the G2 memerbship testing  is %o*100^-2\n",T;


