%exner方程式とActive layerの式での取得_161005
function A_2nd_next = predictor_corrector(A_2nd, params, CP_Ci, Es_i)
  %% A_2ndは(粒径階数*2)行n列の配列、lmはΔt/Δx、dtはΔt
  %∂A/∂t + α*∂B1/∂x + ∂B2/∂x = Zを計算して、次のタイムステップのA_nextを出力する

%   get_Z_2nd; %AからZを算出する関数
  %% 基本パラメーターを取得
  dt = params.dt;
  %% AからZを算出する
  Z_2nd = get_Z_2nd(A_2nd, params, CP_Ci, Es_i);
  %% オイラー法を用いて予測子fpを計算する
  A_predictor = A_2nd  + dt .* Z_2nd;
  Z_2nd_star = get_Z_2nd(A_predictor, params, CP_Ci, Es_i); %次に使うZを算出
  %% 予測子・修正子最終ステップを計算する
  A_2nd_next = A_2nd  + 0.5 .* dt .* (Z_2nd + Z_2nd_star);
  
end