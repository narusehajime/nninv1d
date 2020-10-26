   function [blockTime] = get_blockTime(sumHi, time, para)
   %% 堆積物の厚さ区間あたりにかかる時間の算出
   
   % divisionの設定
    temp = sumHi;
    divi = para.divi;
    range= 0:divi;
    d_sumHi = sumHi(end) / divi;
    Hi_range = (range * d_sumHi).';

    % 削剥部分は削除
    L = sumHi > sumHi(end); %論理配列により，最終堆積物より上位の堆積物は削除
    time(L) = [];
    sumHi(L) = [];
    
    % 極めて小さい部分は削除 (初期地形（0）の部分は削除を含む）
    L = sumHi < 0.0001; %論理配列により，非常に小さい値は削除
    time(L) = [];
    sumHi(L) = [];
    
    time_temp = zeros(size(time,1)+1,1);%1行目に0秒を加える
    time_temp(2:end) = time; %0秒の後にtimeを加える
    sumHi_temp = zeros(size(sumHi,1)+1,1);%1行目に0秒を加える
    sumHi_temp(2:end) = sumHi; %0秒の後にtimeを加える
    time = time_temp;
    sumHi = sumHi_temp;
    
    % 時間補間
    if sumHi(end) ~= 0
        blockTime = interp1(sumHi, time, Hi_range); %vq = interp1(x,v,xq) 1 次データ内挿 (テーブル ルックアップ)
    else 
        blockTime = 0;
    end
    
   end