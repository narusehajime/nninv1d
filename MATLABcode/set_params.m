%パラメータの設定_160204
function [newparams] = set_params(A, params)
    %% 次のタイムステップに向けて計算用パラメーターを更新する関数
    
    %A(1,:) 流れの厚さ（h）
    %A(2,:) 単位距離あたりの運動量（U*h）
    
%     set_dt;
%     get_S;
    
    newparams = params;
    newparams.sdot = A(2,end) ./ A(1,end);%ヘッドの移動速度を計算のタイムステップでのヘッドの位置を計算
    newparams.s = params.s + newparams.sdot .* params.dt; %ヘッドの位置
    [newparams.dt, newparams.lm] = set_dt(A,params); %時間ステップを設定する
    newparams.slope = get_S(params); %斜面勾配を算出する

end