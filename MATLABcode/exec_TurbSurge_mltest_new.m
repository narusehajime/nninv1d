%% シミュレーション実行_160204
function [A, A_2nd, params, elapsed_time] = exec_TurbSurge_mltest_new(prefix, interval, endtime, icond)
    %TurbSurgeでの混濁流シミュレーションを計算を実施する
    %setfile: 設定ファイルの名称
    %interval: 結果を書きだす間隔（秒）
    %endtime: 計算終了時刻（秒）
    %prefix = 'test_output_otadai04\';

    delete([prefix '*.txt']);%まず出力フォルダを空にする
    rng('shuffle');%乱数を初期化する
    
    for i = 1:1

        %初期パラメータ設定
        [A, A_2nd, params] = set_init_mltest_new(icond, prefix);
        
            %初期パラメータを保存する

    init_x = params.xo;
    dlmwrite([prefix 'x_init.txt'], init_x);%地形のxグリッド
    dlmwrite([prefix 'eta_init.txt'], params.eta_init);%初期地形
    dlmwrite([prefix 'Di.txt'], params.Di);%粒径階
    for m = 1: params.noGS
        dlmwrite([prefix 'etai_init.txt'], A_2nd(m,:),'-append');%粒径階ごとの堆積物の厚さ
    end
    dlmwrite([prefix 'icond.txt'], icond); %initial conditions

        
        %移動座標系に時間を変換
        interval_trans = interval ./ params.ho .* params.Uo; %interval_trans = interval ./ params.ho .* params.Uo;
        endtime_trans = endtime ./ params.ho .* params.Uo; %endtime_trans = endtime ./ params.ho .* params.Uo;
        params.endtime_trans = endtime_trans;
        [A, A_2nd, params, elapsed_time] =  TurbSurge_mltest(A, A_2nd, params, interval_trans, endtime_trans);
        
        %save_result_mltest(A, A_2nd, params);%計算結果を格納

    end
    
end
