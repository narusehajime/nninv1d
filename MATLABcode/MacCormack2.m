%マクマック法_160204
function [A_next, Es_i_next]= MacCormack2(A, A_2nd, params)
  %% Aは8行n列の配列、lmはΔt/Δx、dtはΔt
  %∂A/∂t + α*∂B1/∂x + ∂B2/∂x = Zを計算して、次のタイムステップのA_nextを出力する
  
%   get_B1,B2; %AからB1,B2を算出する関数
%   get_Z; %AからZを算出する関数
%   get_A_upbound; %Aの上流端の境界条件を与える関数（3行1列）
%   get_A_downbound_3; %Aの上流端の境界条件を与える関数（3行1列）
%   Jameson;%ショック吸収スキームを適用する関数
  
  %% 基本パラメーターを取得
  lm = params.lm; % Δt/Δx
  dt = params.dt; % Δt
  alpha = - params.sdot .* params.x ./ params.s; 
  alpha = repmat(alpha, [size(A,1),1]); %alpha = repmat(alpha,[8,1]);
  s = params.s ;
  %% Grid数を算出する
  gnum = size(A,2);
  %% AからB1とB2,Zを算出する
  B1 = get_B1(A,params);
  B2 = get_B2(A,params);
  
  [Z, Es_i] = get_Z(A, A_2nd, params);
  %% マコーマック法第一ステップ計算結果を格納する配列
  A_star = zeros(size(A));
  B1_star = zeros(size(B1));
  B2_star = zeros(size(B2));
  Z_star = zeros(size(Z));
  %% マコーマック法第２ステップ計算結果を格納する配列
  A_dstar = zeros(size(A));
  %% 最終計算結果を格納する配列
  A_next = zeros(size(A));
  %% マコーマック第1ステップを計算する
%   test1= alpha(:,3:end); %平均よりも安定？
  test1= (alpha(:,3:end) + alpha(:,2:end-1)) ./ 2; 
  A_star(:,2:end-1) = A(:,2:end-1) - lm .* (test1 .* (B1(:,3:end) - B1(:,2:end-1)) + (B2(:,3:end) - B2(:,2:end-1)) ./ s)  + dt .* Z(:,2:end-1);
%   A_star(:,2:end-1) = A(:,2:end-1) - lm .* (test1 .* (B1(:,3:end) - B1(:,2:end-1)) + (B2(:,3:end) - B2(:,2:end-1))) ./ params.s + dt .* Z(:,2:end-1);
  A_star(:,1) = get_A_upbound(A_star); %Aの上流端境界条件を与える
  A_star(:,gnum) = get_A_downbound_4(A, params); %Aの下流端境界条件を与える
  B1_star = get_B1(A_star, params); %次に使うB1を算出
  B2_star = get_B2(A_star, params); %次に使うB2を算出
  
  [Z_star, Es_i_star] = get_Z(A_star, A_2nd, params); %次に使うZを算出

  %% マコーマック第2ステップを計算する
%   test2= alpha(:,2:end-1);
  test2= (alpha(:,2:end-1) + alpha(:,1:end-2)) ./ 2;
  A_dstar(:,2:end-1) = A_star(:,2:end-1) - lm .* (test2 .* (B1_star(:,2:end-1) - B1_star(:,1:end-2)) + (B2_star(:,2:end-1) - B2_star(:,1:end-2)) ./ s) + dt .* Z_star(:,2:end-1);
%   A_dstar(:,2:end-1) = A_star(:,2:end-1) - lm .* (test2 .* (B1_star(:,2:end-1) - B1_star(:,1:end-2)) + (B2_star(:,2:end-1) - B2_star(:,1:end-2)))./ params.s + dt .* Z_star(:,2:end-1);
  A_dstar(:,1) = get_A_upbound(A_dstar); %Aの上流端境界条件を与える
  A_dstar(:,end) = get_A_downbound_4(A_star, params); %Aの上流端境界条件を与える

  %% マコーマック最終ステップを計算する
  A_next = 0.5 .* (A + A_dstar);
  %% 境界条件を与える
  A_next = Jameson(A_next(1,:), A_next, params); %ショック吸収用の数値粘性スキームを適用する
    
  %% Exner方程式に受け渡す堆積・侵食のパラメータ
  Es_i_next = 0.5 .* (Es_i + Es_i_star); %全堆積物初期濃度
  A_next(A_next<0) = 0;
end
