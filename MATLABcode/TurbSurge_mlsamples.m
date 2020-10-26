%主要な関数_160204
function [A, A_2nd, params, elapsed_time] = TurbSurge_mlsamples(A, A_2nd, params, interval, endtime)
    %% TurbSurgeを流れる混濁流の数値計算を行う
    %interval: 何秒ごとに結果を記録するか
    %endtime: 計算を終了する時刻
    %A: 流れの厚さ・濃度（c*h）・流速（U*h）
    %params: 計算に必要なパラメータ
    %prefix: 計算結果を保存するファイルに付ける名前（フォルダ名）

%     exec('MacCormack.m');%マコーマック法を実行する関数
%     exec('plot_result.m');%結果を表示する関数
%     exec('get_next_eta.m');%次のステップのetaを計算する関数
%     exec('set_params.m');%次の時間ステップにおける各種パラメータを計算する関数
%     exec('save_result.m');%結果を保存する関数
    
    prefix = params.prefix;
    
    %計算ループ
    tic();
    i = 1;
    
    terminate = false; %計算終了条件判定のための変数
    while(terminate == false)%終了条件を満たすまで計算を続ける
        temp = 0;%インターバル測定用のカウンタ
        c = 0; %デバッグ用変数
        while(temp < interval)%interval秒ごとに結果を保存
            
            params = set_params(A, params);%パラメータを更新
            % 	termination conditionをチェックする
            terminate = check_terminate(A, endtime, params);
            if terminate %計算終了条件に達していたらループを抜ける
                break;
            end
                
            A_2nd_moving = CDreal2moving(A_2nd, params); %etai and Fi are interpolated from real CD to moving CD 2016/11/16
            [A, Es_i] = MacCormack2(A, A_2nd_moving, params); %１時間ステップ分の計算を行う            
            [CP_Ci, CP_Es_i] = CDmoving2real(A, params, Es_i);%dep of control points are interpolated %interpolation from moving CD to real CD　2016/11/16
            A_2nd = predictor_corrector(A_2nd, params, CP_Ci, CP_Es_i);%exnerとFiを得る 2016/10/31
            params.t = params.t + params.dt; %計算機内で経過した時間を記録
            temp = temp + params.dt;%インターバル測定用
            c = c + 1;            
        
        end
        
        i = i + 1;
        
        
    end
    elapsed_time = toc();%実際に計算にかかった時間
    
end

%% memo
%             params = set_params(A, params);%パラメータを更新
%             A_2nd_moving = CDreal2moving(A_2nd, params); %etai and Fi are interpolated from real CD to moving CD 2016/11/16
%             [A, Es_i] = MacCormack2(A, A_2nd_moving, params); %１時間ステップ分の計算を行う
%             %params.eta = get_next_eta(A, params); %地形変化を計算
%             
%             [CP_Ci, CP_Es_i] = CDmoving2real(A, params, Es_i);%dep of control points are interpolated %interpolation from moving CD to real CD　2016/11/16
%             A_2nd = predictor_corrector(A_2nd, params, CP_Ci, CP_Es_i);%exnerとFiを得る 2016/10/31
% %             CP_A = CDmoving2realver1(A, params);
% %             A_2nd = predictor_corrector2(A_2nd, params, CP_A);
%             params.t = params.t + params.dt; %計算機内で経過した時間を記録
%             temp = temp + params.dt;%インターバル測定用
