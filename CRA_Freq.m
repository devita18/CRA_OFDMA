function [matriks matriksKanal] = CRA_Freq(user,timeslot,degree,K)
% user = 100;
% timeslot = 10;
% degree = [0.2 2 0.8 3];

user = round(user); %Rounding the number of user
degree = degree'; %Transpose degree matrix
matriksSlot = zeros(user,timeslot); %Create zeros matrix based on number of user as row and number of timeslot as column
userDistribution = []; %User distribution initiation
degreeDistribution = []; %Degree distribution initiation
temp = []; %Initiate temp variable
temp2 = []; %
matriks = [];
matriksKanal = [];
if mod(length(degree),2) == 0 %Check length of degree, if not even number then pop up notification
    
    %     check total of distribution
    for i=1:length(degree) %iteration based on length of degree
        
        if mod(i,2) == 1
            userDistribution = [userDistribution  degree(i)]; %fill the matrix of user
        end
        
        if mod(i,2) == 0
            degreeDistribution = [degreeDistribution  degree(i)]; %fill the matrix of degree
        end
        
    end
    
    %     check user distribution
    if sum(userDistribution) == 1 %if summation of user is equal to 1 then the process continue
        %     Generate degree distribution
        userDistribution = round(user .* userDistribution); %generate the number of each user
        %distribution based on user distribution and number of user
        if(sum(userDistribution)~=user) %check wether userDistribution is equal to number os user
            test = user - sum(userDistribution); %check the different between number of user and generated user distribution
            userDistribution(length(userDistribution)) = userDistribution(length(userDistribution)) + test;
            %the last user distribution is assumed to be incorrect, it adds
            %based on the different on test variable
        end
        for i = 1:length(userDistribution) %iteration based on the length of user distribution variable
            for j = 1:userDistribution(i) %iteration base on the i iteration user distribution
                if (degreeDistribution(i) > K)
                    multiplier = round((degreeDistribution(i)/K)+1);
                    indexFrequency = randperm(K);
                    indexFrequency = repmat(indexFrequency,[1 multiplier]);
                    temp3 = zeros(1,timeslot);
                    temp4 = randperm(timeslot);
                    temp4 = temp4(1:degreeDistribution(i));
                    temp(temp4) = 1; %fill the choosen position based on temp2 with 1
                                        
                    for k = 1:length(temp4)
                        temp3(temp4(k)) = indexFrequency(k);
                    end                    
                else
                    multiplier = (degreeDistribution(i)/K)+1;
                    indexFrequency = randperm(K);
                    %                     indexFrequency = repmat(indexFrequency,[1 multiplier]);
                    temp = zeros(1,timeslot); %temp variable is created as 1 row and timeslot column
                    temp3 = zeros(1,timeslot);
                    temp4 = randperm(timeslot);
                    temp4 = temp4(1:degreeDistribution(i));
                    
                    temp(temp4) = 1; %fill the choosen position based on temp2 with 1
                    
                    for k = 1:length(temp4)
                        temp3(temp4(k)) = indexFrequency(k);
                    end   
                end

                matriks = [matriks; temp]; %append the matriks
                matriksKanal = [matriksKanal; temp3];
            end
        end
    else
        disp('Not enough user distribution argument'); %show if user distribution input is not enough
    end
    
else
    disp('Not enough degree argument'); %show if degree input is not enough
end

end