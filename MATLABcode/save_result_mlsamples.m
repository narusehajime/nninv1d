%計算結果を格納する関数
function save_result_mlsamples(A, A_2nd, params)
    %% 計算結果を取り出す
%     num = sprintf('%d', i); %string(i);
    prefix = 'output\';%params.prefix;
    noGS = params.noGS;
    grid = params.grid;

    h = A(1,:); %Aの1行目からhを取りだす
    U = A(2,:) ./ h; %Aの1,2行目からUを取りだす
    logical = U < eps;
    U(logical) = eps;%流速ゼロの地点をepsで置き換える U(find(U < eps)) = eps;
    Ci_temp = A(3:2 + noGS,:) ./ repmat(h, noGS, 1);%Aの3行目からCiを取りだす
    etai = A_2nd(1:noGS,:); %Aの5行目からeta_sandを取りだす eta_sand = A(5,:); 
    Fi = A_2nd(noGS+1:2 * noGS,:); %Fsand = A(7,:);
    time = params.t;
    x = params.x .* params.s .* params.ho; %実空間への変換
%     xo = params.xo; %初期グリッド
    %% 実時間・空間に戻す
    h = h .* params.ho;
    U = U .* params.Uo;
    Ci = Ci_temp .* repmat(params.Ci_init, 1, grid);%Ci = Ci .* params.Co%n粒径に拡張
    Ct = sum(Ci,1); %C_total = Cs + Cm;
    
    etat = sum(etai, 1); %eta_total = eta_sand + eta_mud;
    Ft = sum(Fi, 1);

    time = time .* params.ho ./ params.Uo;
    %% ヘッドのところに0を付け加える
    h(end+1) = 0;
    U(end+1) = 0;
    Ci(:,end+1) = zeros();
    Ct(:,end+1) = zeros();
%     eta_head = interp1([0:params.topodx:(size(params.eta,2) - 1) .* params.topodx], params.eta, params.s .* params.ho) ./ params.ho;

    x(end+1) = x(end);
    %% 地形の読み込み
    eta_init_head = interp1([0:params.topodx:(size(params.eta,2) - 1) * params.topodx],params.eta,x);%headまでの初期地形
%     eta_init = params.init_eta;%全体初期地形
    etai_init = params.etai_init;
    %% 結果をファイルに書き込む
    Hi = zeros(noGS, size(params.eta,2));
    for m = 1:noGS
        order = num2str(m);
        Hi(m,:) = etai(m,:) - etai_init(m,:);
        dlmwrite([prefix 'C' order '.txt'], Ci(m,:),'-append');%堆積物濃度
        dlmwrite([prefix 'H' order '.txt'], Hi(m,:),'-append'); % 堆積物の厚さ
        dlmwrite([prefix 'eta' order  '.txt'], etai(m,:),'-append');%堆積物の厚さ+初期地形 eta_i(k,:) + init_eta
        dlmwrite([prefix 'F' order  '.txt'], Fi(m,:),'-append');%砂の粒度分布        
    end

    Htotal = sum(Hi,1);%トータルの堆積物の厚さ
    dlmwrite([prefix 'Ct' '.txt'], Ct,'-append');%全体の堆積物濃度
    dlmwrite([prefix 'Ht' '.txt'],  Htotal,'-append'); %全混濁流堆積物の厚さ
    dlmwrite([prefix 'etat' '.txt'], etat,'-append');%全体の堆積物の厚さ etat + init_eta
    dlmwrite([prefix 'Ft' '.txt'], Ft,'-append');%全体の粒度分布
    
    dlmwrite([prefix 'xi' '.txt'], h + eta_init_head,'-append');%実際の混濁流の流れている状況
    dlmwrite([prefix 'flow_h' '.txt'], h,'-append');%実際の混濁流の流れている状況

    %dlmwrite([prefix 'xi' '.txt'], h,'-append');%実際の混濁流の流れている状況
    dlmwrite([prefix 'U' '.txt'], U,'-append');%流速
    
    dlmwrite([prefix 'x' '.txt'], x,'-append');
    dlmwrite([prefix 'time' '.txt'], time, '-append');
end