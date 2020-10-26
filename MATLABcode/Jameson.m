%水深hの変化率に応じてショック吸収スキームを適用_160204
function A_next = Jameson(h, A, params)
  %% 水深hの変化率に応じてショック吸収スキームを適用し、Aを修正する
  
  %% 基本パラメータ
  lm = params.lm;
  gnum = size(A,2);%グリッド数
  dx_dt = params.dx ./ params.dt; % Δx/Δt
  kappa = params.kappa;%人為的拡散係数
  
  A_next = zeros(size(A)); %計算結果格納用
  eps_i = zeros(1,gnum);
  eps_i_half = zeros(1,gnum);
  
  %% ショック吸収用の拡散係数を計算
  eps_i(2:gnum-1) = abs(h(3:gnum) - 2 .* h(2:gnum-1) + h(1:gnum-2)) ./ (abs(h(3:gnum)) + 2 .* abs(h(2:gnum-1)) + abs(h(1:gnum-2)));  
  
  %% ショック吸収用の拡散係数（グリッド半ずらし）を計算
  eps_i_half(2:gnum-1) = kappa .* dx_dt .* max([eps_i(3:gnum),eps_i(2:gnum-1)]);
  
  %% ショック吸収用の数値粘性スキームを適用
  for k = 1:size(A,1)
    A_next(k,1) = A(k,1);
    A_next(k,2:end-1) = A(k,2:end-1) + eps_i_half(2:end-1) .* (A(k,3:end) - A(k,2:end-1)) - eps_i_half(1:end-2) .* (A(k,2:end-1) - A(k,1:end-2));
    A_next(k,gnum) = A(k,gnum) - eps_i_half(gnum-1) .* (A(k,gnum) - A(k,gnum-1));
  end
  
end