function [dt, lm] = set_dt(A, params) 
    %% 2016/06/28　移流速度αに対応したクーラン数に変更
    
      dx = params.dx; %空間グリッド間隔
      g = params.g; 
      h = A(1,:);
%       alpha = params.sdot .* params.x ; %params.sdot .* params.x ./ params.s ; %get out the minus from MacCormack2
      alpha = - params.sdot .* params.x ./ params.s ; %from MacCormack2
      U1 = alpha .* A(2,:) ./ h; %A(2,:) ./ h; %単位距離あたりの運動量（U*h）
      U2 = A(2,:) ./ h ./ params.s ;
      
      Cr_max = 0.5;
      U_max = abs(max(U2-U1)); %abs(max(U2-U1));
      h_max = max(h);
      dt = Cr_max .* dx ./ (U_max + sqrt(g .* h_max)); %時間グリッド間隔
      lm = dt ./ dx; % Δt/Δx

end