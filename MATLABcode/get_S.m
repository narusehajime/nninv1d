%% S（傾斜）の取得
function slope = get_S(params)
  %Sを算出する関数
  
  x_real = params.x .* params.s .* params.ho;%実空間でのグリッド座標を取得 %
  slope = zeros(size(x_real));%斜面勾配を格納する配列
  eta = params.eta;%地形高さ
  
  %実空間での斜面勾配を計算
  S = zeros(1,size(eta,2)); 
%   eta = params.eta;
  topodx = params.topodx;
  gnum = size(S,2);
  Sx = [0:topodx:(gnum - 1) * topodx];
  
  for i = 2:gnum-1
     S(i) = - ( ( eta(i+1) - eta(i-1) ) / ( 2 .* topodx ) ); %斜面勾配
  end
  S(1) = - ( (eta(3) - eta(1)) / ( 2 .* topodx ) ); %上流端の斜面勾配を与える
  S(gnum) = - ( (eta(gnum) - eta(gnum-2)) / ( 2 .* topodx )); %下流端の斜面勾配を与える
  
  %線形補完により計算グリッド点での斜面傾斜を求める
  slope = interp1(Sx,S,x_real);
  
end