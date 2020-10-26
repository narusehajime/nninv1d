%各種パラメータの取り出し_160205
function Es = get_Es(A, params)
    %Es = get_Es(A, params)
    %% 各種パラメータの取り出し
    h = A(1,:);
    U = A(2,:) ./ h;
    noGS = params.noGS;
%     noCP = params.noCP;
    grid = params.grid;
    h_calc = repmat(h, noGS, 1);
    U_calc = repmat(U, noGS, 1);
    Ci = A(3:2 + noGS,:) ./ h_calc;%砂の堆積物濃度
    Di = params.Di;
    g = params.g;
    R = params.R;
    nu = params.nu;
    Cf = params.Cf;
    vs = params.vs;
    Rp = sqrt(R.* g.* Di) .* Di ./ nu;
    Rio = params.Rio;
    
    u_star = sqrt(Cf) .* U;
    p = params.p;

    %% 経験的係数の設定(Kostic and Parker, 2006)
    alpha1 = ones(noGS,1); 
    alpha2 = ones(noGS,1);
    for k = 1:noGS
        if Rp(k) <= 2.36
            alpha1(k,1) = 0.586; alpha2(k,1) = 1.23;
        else
            alpha1(k,1) = 1.0; alpha2(k,1) = 0.6;
        end
    end
    a = 7.8 .* 10 .^ -7; %extened with Garcia and Parker(1993)
    b = 0.08;
    %% Esの算出
    B1 = repmat(u_star, noGS, 1); %粒径階だけ増やす
    B2 = repmat(vs, 1, grid); %グリッド数だけ増やす
    
    sus_index = B1 ./ B2;%sus_index = u_star ./ vs;%サスペンションインデックスを計算
% %    sig = find(sus_index > 0.5);%サスペンションインデックスが大きい領域を検出
% %    Sf(sig) = abs(Cf .* (U(sig).*U(sig)) ./ Rio ./ C(sig) ./ h(sig));
% %    Z(sig) = alpha1 .* sus_index(sig) .* Rp .^ alpha2 .* Sf(sig) .^ b;
% %    Es(sig) = p .* a .* Z(sig) .^5 ./ (1 + (a./0.3) .* Z(sig) .^ 5);

    %いらないかもしれない
    sig = sus_index > 0.5;%     sig = find(sus_index > 0.5);%サスペンションインデックスが大きい領域を検出 %?
    Sf = abs(Cf / Rio * (U_calc.* U_calc) ./ Ci ./ h_calc);
%     Sf(sig) = abs(Cf .* (U(sig).*U(sig)) ./ Rio ./ Cs(sig) ./ h(sig)); %Sf(sig) = abs(Cf .* (U(sig).*U(sig)) ./ Rio ./ C(sig) ./ h(sig));
%     Sf1(sig) = abs(Cf / Rio * (U_calc(sig) .* U_calc(sig)) ./ Ci(sig) ./ h_calc(sig));
    %Sf = abs(Cf .* (U.*U) ./ Rio ./ phi);
    Z = repmat(alpha1, 1, grid) .* sus_index .* (repmat(Rp, 1, grid) .^ repmat(alpha2, 1, grid)) .* Sf .^ b;%Z = alpha1 .* sus_index .* Rp .^ alpha2 .* Sf .^ b;
    Es = p .* a .* Z .^5 ./ (1 + (a./0.3) .* Z .^ 5);   
    
end