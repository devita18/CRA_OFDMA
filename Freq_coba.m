clc
clear all
x=1;
degree_1=2;
lamda_1=0.2;
degree_2=3;
lamda_2=0.8;
totalTrial=99;
user=200;
timeslot=20;
Gtotal=[];
plrTotal=[];
throughputTotal=[];
K=5;
tanda=0;
frekuensi=K;
for i=10:10:user
    plrMatrix=[];
    througputMatrix=[];
    G=i/timeslot;
    Gtotal=[Gtotal G];
    
    for trial=1:totalTrial
        [matrix_cra matriks_kanal]=CRA_Freq(i,timeslot,[lamda_1 degree_1 lamda_2 degree_2],K);
        decoded_user=[];
        
        iter=1;
        for ts=1:timeslot
            while(~isempty(find(sum(matrix_cra(:,ts)<=K & sum(matrix_cra(:,ts))>0,1))))
                unik=unique(matriks_kanal(:,ts));
                n=nonzeros(unik);
                unico=histc(matriks_kanal(:,ts),n);
                x=x+1;
                if (~isempty(find(length(n)<=K & sum(matriks_kanal(:,ts))>0 & sum(unico)<=frekuensi)))
                    posAB=find(matriks_kanal(:,ts));
                    decodefreq=[];
                    for iter=1:length(posAB)
                    posA=posAB(iter);
                    posB=unique(matriks_kanal(:,ts));
                    posB2=length(nonzeros(posB));
                    posC=nonzeros(matriks_kanal(:,ts));
                    if setdiff(matriks_kanal(posAB(iter),ts),decodefreq)==matriks_kanal(posAB(iter),ts)
                        userRow=posAB(iter);
                        decoded_user=[decoded_user userRow];
                        matrix_cra(userRow,:)= 0;
                        matriks_kanal(userRow,:)= 0;
                    end
                    if iter==length(posAB)
                       matrix_cra(:,ts)=0;
                       matriks_kanal(:,ts)=0;
                       tanda=1;
                    end
                    end
                else
                    cek=unique(matrix_cra(:,ts));
                    cek12=nonzeros(cek);
                    cek1=[];
                    for c=1:length(cek12)
                        cek1=[cek1 nnz(matrix_cra(:,ts)==cek12(c))];
                    end
                    if cek1<=K
                    userRow=find(matrix_cra(:,ts)==1);
                    decoded_user=[decoded_user userRow'];
                    matrix_cra(:,ts)=0;
                    matriks_kanal(:,ts)=0;
                    matrix_cra(userRow,:)= 0;
                    matriks_kanal(userRow,:)= 0;
                    tanda=1;
                    else
                        tanda=1;
                    end
                end
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

% plot(Gtotal,throughputTotal)
semilogy (Gtotal,plrTotal)
xlabel('Offered Traffic (G)');
ylabel('Packet Loss Rate (PLR)');
% ylabel('Throughput');
grid on;