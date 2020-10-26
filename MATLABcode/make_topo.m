%% 地形の形成_160204
function [x, eta]=make_topo(filename, dx)
    %データの読み込み
    topodata = load(filename);%filename = topofile
    xo = topodata(:,1);
    yo = topodata(:,2);
    
    %データ補完によりx座標とy座標を作る
    x = xo(1):dx:xo(end);
    eta = interp1(xo,yo,x); % 1次データ内挿 (テーブル ルックアップ)
    
end