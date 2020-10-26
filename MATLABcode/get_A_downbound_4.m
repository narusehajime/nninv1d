%Aの下流端における境界条件_160204
function A_downbound = get_A_downbound_4(A, params)
    %Aの下流端における境界条件を与える
    A_downbound = zeros(size(A,1),1);
    gnum = size(A,2);
    noGS= params.noGS;
    Rio = params.Rio;
    Ci_init = params.Ci_init;%各粒径の堆積物初期濃度
    Co = params.Co;%堆積物初期濃度
    Frd_const = 1.2; %ヘッドのフルード数が必ず1.2になるようにする Huppert and Simpson 1980

    if 0== isreal(params.s) %0は複素数
        return
    end

    %% Aの下流端の境界条件を変更する
    %eta = interp1([0:params.topodx:(size(params.eta,2) - 1) .* params.topodx],params.eta,x); 
    A_downbound(:,1) = A(:,end-1);
    H = A_downbound(1,1);%前の流れの厚さを保存 %H = A_downbound(1,1) * params.ho;
    U = A_downbound(2,1)./A_downbound(1,1); %U = A_downbound(2,1)./A_downbound(1,1) * params.Uo;
    Ci = A_downbound(3:2 + noGS,1) ./ A_downbound(1,1);
    Ct = sum(Ci .* Ci_init,1) ./ Co; %C = sum(A_downbound(3:2 + noGS,1))./A_downbound(1,1).* params.Co; % C = (A_downbound(3,1) + A_downbound(4,1))./h;
    
    A_downbound(1,1) = (U .^2 .* H .^2 ./ (Frd_const .^2 .* Rio .* Ct)).^(1/3); %A_downbound(1,1) = (U .^2 .* h .^2 ./ (Frd_const .^2 .* R .* g .* C)).^(1/3);
    A_downbound(2,1) =  (Frd_const .^2 * Rio .* (Ct .* U .* H) ).^(1/3); %A_downbound(2,1) =  (Frd_const .^2 * (R .* g .* C .* U .* H) ).^(1/3);
    A_downbound(3:2 + noGS,1) = A_downbound(3:2 + noGS,1); %砂堆積物濃度
    
    % confirm Frd
    Frd = A_downbound(2,1) ./ sqrt(Rio .* Ct .* A_downbound(1,1));
    a = 0;
    if (Frd - 1.2)^2 > 0.000000001
        a = a +1;
    end
end

%%　メモ
%     A_downbound(1,1) = (Frd_const .^ 2 .* R .* g .* A_downbound(2,1) ./ (A_downbound(3,1) + A_downbound(4,1))) .^ (1/3); %だめ?なぜかこれがいい
%     A_downbound(1,1) = A_downbound(2,1) .^ 2 ./ Frd_const .^ 2 ./ R ./ g ./ (A_downbound(3,1) + A_downbound(4,1));%(U1*h1)^2/(Fr^2*R*g*C)