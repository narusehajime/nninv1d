%Zの所得_160204
function [Z, Es_i] = get_Z(A, A_2nd, params)
  %% AからZを算出する関数
  
  Rio = params.Rio; %初期リチャードソン数
  Cf = params.Cf; %底面抵抗係数
  ro = params.ro;%底面／平均濃度比
  Ci_init = params.Ci_init;%各粒径の堆積物初期濃度
  Co = params.Co;%堆積物初期濃度
  vs = params.vs;%堆積物沈降速度
  slope = params.slope;%斜面勾配
  noGS = params.noGS;
  Grid = params.grid;
  
  Z = zeros(size(A));
  q = A(2,:); %無次元運動量
  
  % 2016/05/17
  h = A(1,:); %Aの1行目からhを取りだす %無次元流高
  U = A(2,:) ./ h; %Aの1,2行目からUを取りだす
  L = U < eps;
  U(L) = eps;%流速ゼロの地点をepsで置き換える U(find(U < eps)) = eps;
  Ci = A(3:2 + noGS,:) ./ repmat(h, noGS, 1);%Aの3～ｎ行目からCiを取りだす
  Ct = sum(Ci .* repmat(Ci_init, 1, Grid),1) ./ Co; %トータルの濃度 C_total = C_sand + C_mud;　%列の和

  %% 侵食・堆積量の計算
  Fi = A_2nd(noGS+1: 2 * noGS,:); %Fi = A(7,:);
  Es_i = get_Es(A, params);%砂の連行係数
  Ci_init_grid = repmat(Ci_init, 1, Grid);
%   dep_i =  repmat(vs, 1, Grid) .* (ro * Ci .* Ci_init_grid - Fi .* Es_i); %砂の堆積量 dep_i =  repmat(vs, 1, Grid) .* (ro * Ci - Fi .* Es_i./ Co);
  dep_i =  repmat(vs, 1, Grid) .* (ro * Ci - Fi .* Es_i./ Ci_init_grid); %砂の堆積量 dep_i =  repmat(vs, 1, Grid) .* (ro * Ci - Fi .* Es_i./ Co);
    
  %トータルで侵食を起こさせないための処理
  eroded_area = dep_i < 0;%侵食が発生している領域の検出
  dep_i(eroded_area) = 0;%A(5,:) 砂堆積物の厚さ （eta_sand）
  Es_i(eroded_area) = ro .* Ci(eroded_area) .* Ci_init_grid(eroded_area) ./ Fi(eroded_area);

  %% 移動座標系におけるソース項
  scrit = q > params.eps; %find(q > params.eps);
  Z(1,scrit) = 0.00153 .* U(scrit) ./ (0.0204 + (Rio .* Ct(scrit) .* h(scrit)) ./ U(scrit) ./ U(scrit));%Z(1,scrit) = 0.00153 .* (q(scrit) ./ h(scrit)) ./ (0.0204 + Rio .* C_total(scrit) .* h(scrit)) ./ (U(scrit) .* U(scrit));
  Z(2,:) = (Rio .* Ct .* h .* slope) - Cf .* (U .* U);
  Z(3:2 + noGS,:) = - dep_i; % - dep_sand; % vs .* (es_sand ./ C_sand_init - ro .* C_sand);

end