%各種ファイル名
    prefix = 'test_output\'; %データを記録するフォルダ名
    prefix2 = 'test_input\'; %データを記録するフォルダ名
    topofile = 'test_input\InitTopo.txt'; %地形データを記したファイル
    delete('\test_output\*.txt');

%% 求めたい初期条件　inital
    ho_max = 800;
    ho_min = 100;
    lo_max = 800;
    lo_min = 100;
    C_max = 0.01;
    C_min = 0.0001;
    S_min = 0.000;
    S_max = 0.005;
    ho = 1.367199999999999989e+02;
    lo = 5.561299999999999955e+02;
    S = 2.241400000000000163e-03;
    delete(topofile);
    topo = [0,0;5000,-500;50000,-500-S*(50000-5000)];
    dlmwrite(topofile, topo);
    noGS = 3; %粒径階数

    str_noGS = num2str(noGS);
    Di = load([prefix2 ['InitD' str_noGS] '.txt']); %堆積物の粒径(m) [1000 * 10^-6; 250 * 10^-6; 62.5 * 10^-6];%3粒径
    Di = Di .* 10^-3; %粒径の次元を揃える

%     Ci_init = repmat(0.01 ./ noGS, noGS, 1);%Ci_init = repmat(C_unit, noGS, 1); %初期濃度（砂）1%は濃い [0.01; 0.01] 
    Ci_init = [2.629600000000000166e-03;1.891099999999999942e-03;2.310299999999999940e-03];
    F_base = 1 ./ noGS;
    Fi_init = repmat(F_base, noGS, 1);% 1-sum(repmat(F_base, noGS-1, 1))]; %GS in Active layer
%% 流れの初期条件
    nogrid = 50; %空間グリッド数
    topodx = 5;%50; %地形のグリッド間隔
    R = 1.65; %堆積物水中比重 for natural quartz.
    nu = 1.0 * 10^-6; %水の動粘性係数
    g = 9.81; %重力加速度(m/s^2)
    Cf = 0.0069; %底面抵抗係数 0.0069 0.004
    ro = 1.5; %底面近傍／平均濃度比
    lambdap = 0.4; %堆積物間隙率
    kappa = 0.001;%0.00001; %数値粘性
    p = 0.1;%堆積物巻き上げ抑制
    La = 0.003; %交換層の厚さ　(Arai,2011MS)
    
    %初期条件の記録
    dlmwrite([prefix 'initial_conditions.txt'], [ho, lo, Ci_init(1), Ci_init(2), Ci_init(3), S], '-append');