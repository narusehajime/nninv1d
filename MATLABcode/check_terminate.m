function terminate = check_terminate(A, endtime, params)
%計算の終了条件を判定するための関数

    terminate = false;
    eps = 0.001;
    
     %計算が発散しているかチェック
    if max(max(isnan(A))) == 1 || min(min(isreal(A))) == 0
        terminate = true;
    
    %ヘッドの流速・厚さが小さくなりすぎていないか
    elseif min(A(1:2,end)) < eps
        terminate = true;
        
    %ヘッドの濃度が小さくなりすぎていないか
    elseif (sum((A(3:2 + params.noGS,end) .* params.Ci_init),1) / params.Co) < eps
        terminate = true;
        
    %流れが計算ドメインの終端に到達していないか
    elseif params.s * params.ho > params.xo(end)
        terminate = true;
    
    %計算終了時刻となっていないか
    elseif params.t > endtime
        terminate = true;
    end
    
end
