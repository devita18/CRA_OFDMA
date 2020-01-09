clc
clear all
x=1;
degree_1=2;
lamda_1=0.2;
degree_2=3;
lamda_2=0.8;
totalTrial=500;
user=500;
timeslot=100;
Gtotal=[];
plrTotal=[];
throughputTotal=[];
K=1;
tanda=0;
frekuensi=K;
for i=50:50:user
    plrMatrix=[];
    througputMatrix=[];
    G=i/timeslot;
    Gtotal=[Gtotal G];
    
    for trial=1:totalTrial
        [matrix_cra]=CRA_Freq(i,timeslot,[lamda_1 degree_1 lamda_2 degree_2],K);
        decoded_user=[];
        
        iter=1;
        for ts=1:timeslot
            while(~isempty(find(sum(matrix_cra(:,ts)<=K & sum(matrix_cra(:,ts))>0,1))))
%                 unik=unique(matriks_kanal(:,ts));
%                 n=nonzeros(unik);
%                 unico=histc(matriks_kanal(:,ts),n);
                x=x+1;
%                 if (~isempty(find(length(unik)<=4 & sum(matriks_kanal(:,ts))>0 & sum(unico)<=frekuensi)))
%                 else
                    if sum(matrix_cra(:,ts))<=1
                    userRow=find(matrix_cra(:,ts)==1);
                    decoded_user=[decoded_user userRow'];
                    matrix_cra(:,ts)=0;
%                     matriks_kanal(:,ts)=0;
                    matrix_cra(userRow,:)= 0;
%                     matriks_kanal(userRow,:)= 0;
                    tanda=1;
                    else
                        tanda=1;
                    end
%                 end
                if tanda==1
                    break;
                end
                  
            end
%             fprintf('timeslot = %d \n',ts);
        end
        
        plrMatrix=[plrMatrix length(decoded_user)];
        fprintf(' user=%d, trial=%d  decoded_user =  %d\n ', i, trial,length(decoded_user) );

        
    end
    fprintf('timetslot=%d jumlah user terdecode = %d \n ', ts, sum(plrMatrix));

    plr=((i*totalTrial)-sum(plrMatrix))/(i*totalTrial);
    plrTotal=[plrTotal plr];
    throughputTotal=[throughputTotal G*(1-plr)];
    
        
end


semilogy (Gtotal,plrTotal)
xlabel('Offered Traffic (G)');
ylabel('Packet Loss Rate (PLR)');
% ylabel('Throughput');
grid on;