function h_obs = get_obs(para)
% 各観測地点での堆積量
    %num is last examine location point and last location ex)80
    prefix2 = para.prefix2;
%     init_x = load([prefix2 'x_init' '.txt']); %CPの読み込み    
    DistResource = para.DistResource;
    noGS = para.noGS;
    
    %% OBSのデータの取得
%     H = zeros(noGS, size(x_init, 2)); 
%     H = load([params.prefix 'H_test.txt']); %CPの読み込み
%     h_obs = zeros(noGS, size(DistResource, 2));

        h_obs(1,:) = load([prefix2 'H1_kiyo.txt']); %CPの読み込み
        h_obs(2,:) = load([prefix2 'H2_kiyo.txt']); %CPの読み込み
        h_obs(3,:) = load([prefix2 'H3_kiyo.txt']); %CPの読み込み
%     if noGS == 1
%         H1 = load([prefix2 'H1.txt']); %CPの読み込み
%         H(1,:) = H1(end,:);
%         h_obs = interp1(init_x, H, DistResource); % CPへの変更
%     elseif noGS == 2
%         H1 = load([prefix2 'H1.txt']); %CPの読み込み
%         H2 = load([prefix2 'H2.txt']); %CPの読み込み
%         H(1,:) = H1(end,:);
%         H(2,:) = H2(end,:);
%         h_obs = zeros(noGS, size(DistResource, 2)); % CPへの変更
%         for m = 1:noGS
%             h_obs(m,:) = interp1(init_x, H(m,:), DistResource);
%         end
%     elseif noGS == 3
%         H1 = load([prefix2 'H1.txt']); %CPの読み込み
%         H2 = load([prefix2 'H2.txt']); %CPの読み込み
%         H3 = load([prefix2 'H3.txt']); %CPの読み込み
%         H(1,:) = H1(end,:);
%         H(2,:) = H2(end,:);
%         H(3,:) = H3(end,:);
%         h_obs = zeros(noGS, size(DistResource, 2)); % CPへの変更
%         for m = 1:noGS
%             h_obs(m,:) = interp1(init_x, H(m,:), DistResource);
%         end
%     end
end
%% memo

%     for m = 1:noGS
%         order = num2str(m);
%         H = load([params.prefix 'H' order '.txt']); %CPの読み込み
%     end

% [H, sumH] = count_H(eta_CP, para);

%     %% 実座標の取得
%     x = load([params.prefix 'x' '.txt']); %地形
%     target.x = x;
% 
% %% OBSのデータの取得
%     for k = 1:noGS
%         order = num2str(k);
%         target.i = load([params.prefix 'eta_' order '.txt' ]); %h_sand砂の堆積物量
%         % 各観測地点での堆積量
%         h_obs(order,:) = interp1(target.x, target.i, params.xo, 'pchip', 0); %h_obs(1) = interp1(target.x,target.s,params.xo,'linear', 0);
%     end