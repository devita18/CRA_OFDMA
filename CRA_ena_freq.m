clc
clear all
x=1;
s=0;
degree_1=2;
lamda_1=0.95;
degree_2=16;
lamda_2=0.05;
totalTrial=999;
user=200;
timeslot=20;
Gtotal=[];
plrTotal=[];
throughputTotal=[];
K=4;
frekuensi=K;
for i=5:5:user
    plrMatrix=[];
    througputMatrix=[];
    G=i/timeslot;
    Gtotal=[Gtotal G];
    
    for trial=1:totalTrial
        [matrix_cra matriks_kanal]=CRA_Freq(i,timeslot,[lamda_1 degree_1 lamda_2 degree_2],K);
        decoded_user=[];
        x=0;
while true
        tanda=0;
        for ts=1:timeslot
                unik=unique(matriks_kanal(:,ts));
                n=nonzeros(unik);
%                 unico=histc(matriks_kanal(:,ts),n);
%                 x=x+1;
%                 if (~isempty(find(length(unik)<=4 & sum(matriks_kanal(:,ts))>0 & sum(unico)<=frekuensi)))
%                 else
% && isempty(find(unico>1))
                if (~isempty(find(length(n)<=K & sum(matriks_kanal(:,ts))>0, 1)) )  
                    posAB=find(matriks_kanal(:,ts));
%                     posAB2=length(unique(posAB));
                    decodefreq=[];
                    for iter=1:length(posAB)
                    posA=posAB(iter);
                    posB=unique(matriks_kanal(:,ts));
                    posB2=length(nonzeros(posB));
                    posC=nonzeros(matriks_kanal(:,ts));
                  if histc(matriks_kanal(:,ts),matriks_kanal(posAB(iter),ts))==1
                    userRow=posAB(iter);
                    decoded_user=[decoded_user userRow];
%                     decodefreq=[decodefreq n(iter)];
                    matrix_cra(userRow,:)= 0;
                    matriks_kanal(userRow,:)= 0;
                    tanda=tanda+1;

                  end
                    end
%                 else
%                     cek=unique(matrix_cra(:,ts));
%                     cek12=nonzeros(cek);
%                     cek1=[];
%                     for c=1:length(cek12)
%                         cek1=[cek1 nnz(matrix_cra(:,ts)==cek12(c))];
%                     end
%                     if cek1<=K
%                     userRow=find(matrix_cra(:,ts)==1);
%                     decoded_user=[decoded_user userRow'];
%                     matrix_cra(userRow,:)= 0;
%                     matriks_kanal(userRow,:)= 0;
%                     tanda=tanda+1;
%                     end
                end
                
%     
%                   if sum(matrix_cra(:,ts))==K
%                     userRow=find(matrix_cra(:,ts)==1);
%                     decoded_user=[decoded_user userRow'];
%                     s=s+1;
% %                     matrix_cra(:,ts)=0;
% %                     matriks_kanal(:,ts)=0;
%                     matrix_cra(userRow',:)= 0;
% %                     matriks_kanal(userRow,:)= 0;
%                     tanda=tanda+1;
%                 
%                   end
                
%         while(~isempty(find(sum(matrix_cra)<=K & sum(matrix_cra)>0,1)))
%             s=s+1;
%             posT= find(sum(matrix_cra)<=K & sum(matrix_cra)>0,1); %untuk timeslot
%             posU= find(matrix_cra(:,posT)); %user
%             posU = posU';
%             decoded_user=[decoded_user posU];
%             matrix_cra(posU,:)=0;
%         end
%             end
%             fprintf('timeslot = %d \n',ts);
        end
     if tanda==0
         break;
     end
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