function X = DAMF(A)

B=(~(A==0 | A==255));
pA=padarray(A,[3 3],'symmetric');
pB=(~(pA==0 | pA==255));
[m,n]=size(B);
for i=1:m
    for j=1:n
        if(B(i,j)==0)
            if(sum(sum(pB(i+2:i+4,j+2:j+4)))~=0)
                R1=pA(i+2:i+4,j+2:j+4);
                R1=R1(R1>0 & R1<255);
                mR=median(R1);
                A(i,j)=mR;
            elseif(sum(sum(pB(i+1:i+5,j+1:j+5)))~=0)
                R1=pA(i+1:i+5,j+1:j+5);
                R1=R1(R1>0 & R1<255);
                mR=median(R1);
                A(i,j)=mR;
            elseif(sum(sum(pB(i:i+6,j:j+6)))~=0)
                R1=pA(i:i+6,j:j+6);
                R1=R1(R1>0 & R1<255);
                mR=median(R1);
                A(i,j)=mR;
            end
        end
    end
end
B=(~(A==0 | A==255));
pA=padarray(A,[1 1],'symmetric');
pB=(~(pA==0 | pA==255));
[m,n]=size(B);
for i=1:m
    for j=1:n
        if(B(i,j)==0)
            if(sum(sum(pB(i:i+2,j:j+2)))~=0)
                R1=pA(i:i+2,j:j+2);
                R1=R1(R1>0 & R1<255);
                mR=median(R1);
                A(i,j)=mR;
            end
        end
    end
end
X=A;

end