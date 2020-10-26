%Bの取得_160204
function B2 = get_B2(A, params)
  %% AからBを算出する関数
  
  Rio = params.Rio; %初期リチャードソン数
  Ci_init = params.Ci_init;%各粒径の堆積物初期濃度
  Co = params.Co;%堆積物初期濃度
  noGS = params.noGS;
  Grid = params.grid;
  B2 = zeros(size(A));

%% 2016/05/17
  h = A(1,:); %Aの1行目からhを取りだす
  U = A(2,:) ./ h; %Aの1,2行目からUを取りだす
  logical = U < eps;
  U(logical) = eps;%流速ゼロの地点をepsで置き換える U(find(U < eps)) = eps;
  Ci = A(3:2 + noGS,:) ./ repmat(h, noGS, 1); %Aの3行目からC_sandを取りだすCi = A(3,:) ./ h;
  Ct = sum(Ci .* repmat(Ci_init, 1, Grid),1) ./ Co; %トータルの濃度
%   Ct = sum(Ci,1); %C_total = C_sand + C_mud; %トータルの濃度
%% 移動座標系における移流項
  B2(1,:) = U .* h  ; %- A(2,:);
  B2(2,:) = (U .* U .* h + (Rio .* Ct .* h .* h) ./ 2) ;% + Rio .* C_total .* Co .* eta_total)); %- (- (U .* U) .* h - Rio .* C_total .* h .^2 ./ 2);% + Rio .* C_total .* Co .* eta_total));
  B2(3:2 + noGS,:) = Ci .* repmat(h, noGS, 1) .* repmat(U, noGS, 1) ; %- (C_sand .* h .* ( - U));
end

  
