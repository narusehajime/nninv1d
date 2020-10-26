function [t_interp] = timeInterp(H, para)
    %% ŠÔ•âŠÔ
    % eta_CP(k,l,m); eta_CP(time, x_position, noGS) 
%     time = zeros(size(para.time)+1);

    time = zeros(size(para.time,1)+1,1);
    time(2:end) = para.time;
    H_unit = para.H_unit; %(m)
    
    %‘ÍÏ•¨‚ÌŒú‚³‚Ì‘˜a‚ğŒvZ
    tmp_sumH = sum(H,3); %‘ÍÏ•¨‚Ì‘˜a
    sumH = zeros(size(tmp_sumH,1)+1, size(tmp_sumH,2)); %1s‚É0‚ğ‰Á‚¦‚é
    sumH(2:end, :) = tmp_sumH;

    for l = 1:size(sumH,2)
        sumH_temp =  sumH(:,l);
        blockTime = get_blockTime(sumH_temp, time, para);
        
    end
    
%         for l = 1:size(sumH,2)
%         blockTime = interp1(sumH(:,l), time, H_range); %, 'previous'
%     end
    

end
%% memo
%     sumH(end+1, :) = H_range(end);
%     time(end+1,:) = 200;
    
%     L = sumH < 0;
%     sumH(L) = 0.001;
%     L2 = sumH == 0;
%     sumH(L2) = 0.001;
%     sumH(1,:) =zeros;
% 
%     time = repmat(time, 1, size(sumH,2));
%     H_range = repmat(H_range, 1, size(sumH,2));
%     blockTime = zeros(size(H_range,1), size(sumH,2));

%     blockTime = interp1(sumH1, time, H_range); %, 'previous'




%     
%     time_tem2 = zeros(size(sumH,1), size(sumH,2));
%     sumH_tem2 = zeros(size(sumH,1), size(sumH,2));
%     
%     for l = 1:size(sumH,2)
%         time = zeros(size(para.time,1)+1,1);
%         time(2:end) = para.time;
%         
%         sumH_tem = sumH(:,l);
%         
%         L = sumH(:,l) > sumH(end,l);
%         time(L) = [];
%         time_tem2(:,l) = time; 
%         sumH_tem(L) = [];
%         sumH_tem2(:,l) = sumH_tem;
%     end