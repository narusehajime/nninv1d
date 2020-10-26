function get_grading(prefix, fname, num)
    %% 時間と初期地形を読み込むとパラメータの設定
    % eta_CP(k,l,m); eta_CP(time, x_position, noGS)
    
    para.prefix = prefix;
    para.fname = fname;
    para.time = load([prefix 'time.txt']);
    para.init_x = load([prefix 'init_x.txt']);
    para.eta_init= load([prefix 'eta_init.txt']); %init_eta = load([prefix 'init_eta.txt']);
    para.etai_init= load([prefix 'etai_init.txt']);
    para.noGS = num;
    str_noGS = num2str(para.noGS);
    Di = load(['input\' ['InitD' str_noGS] '.txt']); %堆積物の粒径(m) [1000 * 10^-6; 250 * 10^-6; 62.5 * 10^-6];%3粒径
    para.Di = Di .* 10^-6; %粒径の次元を揃える
%     Di2 = load([prefix 'Di.txt']);
    para.H_unit = 0.005; %0.02; %(m)
    para.divi = 10;

    for m = 1:para.noGS
        order = num2str(m);
        eta_CP(:,:,m) = load([prefix ['eta' order] '.txt' ]); %堆積物の厚さ　data(k,l,m) H of control points
    end
    
    %% 堆積物の厚さ計算
    [H] = count_H(eta_CP, para);
    
   %% 補間
    % eta_CP(k,l,m); eta_CP(time, x_position, noGS) 
    % time = zeros(size(para.time)+1);

    H_next = zeros(size(H,1)+1,size(H,2),size(H,3)); %1行目に0(堆積・侵食なし)を加える
    H_next(2:end,:,:) = H;
    time = zeros(size(para.time,1)+1,1);%1行目に0秒を加える
    time(2:end) = para.time; %0秒の後にtimeを加える
    sumH = sum(H_next,3); %堆積物の厚さの総和を計算
    
    for l = 2: max(find(sumH(end,:))) %upboundより下流側の次のグリッドからheadの到達距離までの空間グリッドが基準点  %size(sumH,2)
%     while(l <= size(sumH,2) || params.s > init_x(end))
        
        if sumH(end,l) == 0
            continue %ループの以下の反復へ制御を渡す
        else 
            sumH_temp =  sumH(:,l);
            blockTime = get_blockTime(sumH_temp, time, para);
            for m = 1:para.noGS
                Hi(:,l,m) = interp1(time, H_next(:,l,m), blockTime); %粒径階ごとの堆積物の厚さ補間
            end
            sumH_conp(:,l) = interp1(time, sumH_temp, blockTime); %粒径階ごとの堆積物の厚さ補間
        end
    end
    
    for l = 2: size(Hi,2)
        for m = 1:para.noGS
            for k = 1: para.divi + 1
                GSD(k,l,m) = para.Di(m) * Hi(k,l,m) / sumH_conp(k,l); %平均粒径
            end
        end
    end
    
    GSD(isnan(GSD))= 0;
    L = GSD < 0;
    GSD(L) = 0;
    
    sumGSD = sum(GSD,3);
    %% 書き出し
    dlmwrite([prefix 'sumGSD' '.txt'], sumGSD); %平均粒径
    dlmwrite([prefix 'sumHi' '.txt'], sumH_conp); %全体の堆積物の厚さ
end
%% memo
% GSD(:,:,k) = Di(k,1) * fracH(:,:,k);
