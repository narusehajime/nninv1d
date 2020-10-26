%% 2016/11/15
function A_2nd_moving = CDreal2moving(A_2nd, params)
%ÀÀ•W‚©‚çˆÚ“®À•WŒn‚Ö•ÏŠ·‚·‚é‚½‚ß‚ÌŠÖ”

    xo = params.xo;
    x = params.x .* params.s .* params.ho;

    A_2nd_moving = zeros(size(A_2nd,1),size(x,2));
%     A_2nd(params.noGS+1:2 * params.noGS, :) = A_2nd(params.noGS+1:2 * params.noGS, :) / (1/params.noGS);
    for i = 1:size(A_2nd,1)
        A_2nd_moving(i,:) = interp1(xo, A_2nd(i,:), x);
    end
    
end

%% memo

