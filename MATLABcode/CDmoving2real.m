%% 2016/11/15
function [CP_Ci, CP_Es_i] = CDmoving2real(A, params, Es_i)
    %% パラメータ抽出
    noGS = params.noGS; %number of grid
    grid = params.grid;
    x = params.x .* params.s .* params.ho;%実空間への変換

    h_temp = A(1,:);
    Ci_temp = A(3:2 + noGS,:) ./ repmat(h_temp, noGS, 1);
    %% 実空間に戻す
    if size(params.Ci_init, 2) == 1 %1列の場合はFMであり転置なし，列が複数ある場合はgaでの初期値発生により転置
        Ci = Ci_temp .* repmat(params.Ci_init, 1, grid);
    else
        Ci = Ci_temp .* repmat(params.Ci_init.', 1, grid); %転置
    end
    
    %% Control point
    CP_Ci = zeros(noGS, size(params.eta,2));
    CP_Es_i = zeros(noGS, size(params.eta,2));
    Ci(isnan(Ci)) = 0;
    Es_i(isnan(Es_i)) = 0;
    for k= 1:noGS
        CP_Ci(k,:) = interp1(x, Ci(k,:), params.xo, 'pchip', 0);% 粒径階の堆積物の厚さ control point
        CP_Es_i(k,:) = interp1(x, Es_i(k,:),params.xo, 'pchip', 0);
    end
end

%% memo

%     U_temp = A(2,:) ./ h_temp; %Aの1,2行目からUを取りだす
%     logical = U_temp  < eps;
%     U_temp (logical) = eps;%流速ゼロの地点をepsで置き換える U(find(U < eps)) = eps;
%     U = U_temp .* params.Uo;