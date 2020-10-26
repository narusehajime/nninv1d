%exner方程式とActive layerの式での取得_161005
function Z_2nd = get_Z_2nd(A_2nd, params, Ci, Es_i)
  %% AからA_2nd（ExnerとActive Layer）を算出する関数
    noGS = params.noGS;%粒径階
    noCP = params.noCP;
    vs = params.vs;%堆積物沈降速度
    
    La = params.La;
    ro = params.ro;%底面／平均濃度比
    ho = params.ho;
    Uo = params.Uo;
    lambdap = params.lambdap; %堆積物間隙率
    
    Fi = A_2nd(noGS+1:2 * noGS,:);%固定座標系での粒度分布
    
    etai = A_2nd(1:noGS,:);%Exner方程式より算出される地形
    etai_init = params.etai_init;
    L = etai < etai_init;%L = eta_i < repmat(eta_local, noGS, 1);%論理配列による検出, 侵食量が大きかった場合には変更, 符号（＜）はあっている   
    Es_i(L) = ro * Ci(L) ./ Fi(L);
%     Ct = sum(Ci,1);
%     dep_i = (Uo * repmat(vs, 1, noCP)) .* (ro .* Ci - Fi .* Es_i); %Exner方程式では符号が逆であるので，そのまま dep_i = repmat(vs, 1, noCP) .*  (ro * Ci - Fi .* Es_i./ Co);
    dep_i =  (ho * Uo * repmat(vs, 1, noCP)) .* (ro * Ci - Fi .* Es_i);
    %トータルで侵食を起こさせないための処理
    eroded_area = dep_i < 0;%侵食が発生している領域の検出
    if dep_i < 0 
        a = 1;
    end
    dep_i(eroded_area) = 0;%A(5,:) 砂堆積物の厚さ （eta_sand）

  %% 固定座標系におけるソース項
    Z_2nd(1:noGS,:)= dep_i ./ (1 - lambdap); %Exner
    eta_t = sum(dep_i, 1) ./ (1 - lambdap);
    Z_2nd(noGS+1:2 * noGS, :) = (Z_2nd(1:noGS,:) ./ La - Fi ./ La .* repmat(eta_t, noGS, 1)); %Active Layer; eta_i ./ params.La - Fi .* eta_total
end

% memo
% dep = - dep;%Exner方程式では符号が逆
% Z_2nd(noGS+1:2 * noGS, :) = (Z_2nd(1:noGS,:) ./ La - Fi ./ La .* repmat(eta_t, noGS, 1));