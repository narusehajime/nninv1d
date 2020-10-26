%初期条件の設定_160204
function [A, A_2nd, params] = set_init(setfile)
%TurbSurgeを流れる混濁流の数値計算を行うためのパラメータを設定する
    calcTurbSurge %setfileの読み込み

    %A(1,:) 流れの厚さ（h）
    %A(2,:) 単位距離あたりの運動量（U*h）
    %A(3,:) 単位距離あたりの堆積物の量（Ci*h）
    %A(5,:) 堆積物の厚さ （eta_sand）2016/05/18
    %A(7,:) 堆積物の粒度分布 （Fsand）2016/05/18
    %setfile 設定ファイル
    %% 計算グリッドと地形条件
    [xo, eta_init] = make_topo(topofile, topodx);%ファイルから地形データを読み込む
    params.grid = nogrid;%空間グリッド数
    params.xo = xo;%初期座標
    params.noGS = noGS; %粒径階数
    %% 上流端の境界条件
    params.ho = ho;
    params.lo = lo;
    params.Ci_init = Ci_init;%n粒径に拡張
    params.Co = sum(Ci_init); %トータルの初期濃度
    params.Uo = 1.2 * sqrt(R * g * params.Co * params.ho); %naruse 
    params.Fi = Fi_init; %粒度分布
    params.La = La; %交換層の厚さ　(Arai,2011MS) %2016/05/17 add
    %% 計算条件受け渡し用変数
    params.eta_init = eta_init;%初期地形
    params.eta = eta_init;%現在の地形
    params.topodx = topodx;%地形のグリッド間隔　%実座標での補間（基準）間隔
    params.dx = 1 ./ (nogrid - 1);%空間グリッド間隔
    params.x = (0:params.dx:1);%空間グリッド
    params.s = params.lo ./ params.ho;%ヘッドの（無次元）位置
    params.sdot = 1; %ヘッドの移動速度
    %params.stable_mlevel = stable_mlevel;%下流端における泥水準の最大高さ
    %% そのほかのパラメーター
    params.p = p;%堆積物巻き上げ抑制変数
    params.R = R;%堆積物水中比重
    params.Di = Di;%堆積物の粒径
    params.nu = nu;%水の動粘性係数
    params.vs = get_vs(params.R, params.Di, params.nu) / params.Uo;%砂の無次元沈降速度
    %params.S = get_S(params.dx, params.eta);%初期斜面傾斜, set_paramsに移行
    params.g = g;%重力加速度
    params.Cf = Cf;%底面抵抗係数
    params.ro = ro;%底面近傍／平均濃度比
    params.lambdap = lambdap;%堆積物間隙率
    params.t = 0;%計算機内の時刻
    params.kappa = kappa;%数値粘性
    params.Rp = sqrt(R .* g .* Di) .* Di ./ nu;%粒子レイノルズ数
    params.Rio = R .* g .* params.Co .* params.ho ./ params.Uo .^2;%初期リチャードソン数

    params.prefix = prefix; %ファイルを保存するフォルダ名
    params.topofile = topofile; %地形データを保存するファイル名
    params.dt = 0;
    params.eps = 1 .* 10 ^-6;%極めて小さい数
    %% 流れの初期条件
    params.noCP = size(params.eta_init,2); %control points(基準点) 2016/11/15
    A = set_init_flow(params);
    A_2nd = set_init_layer(params);
    params.etai_init = A_2nd(1:noGS,:);
    params = set_params(A, params);%動的パラメータのセット
    %delete([prefix 'time.txt']);
end
