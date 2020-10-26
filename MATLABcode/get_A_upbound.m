%% A‚Ìã—¬’[‚É‚¨‚¯‚é‹«ŠEğŒ_160204
function A_upbound = get_A_upbound(A)
  %A‚Ìã—¬’[‚É‚¨‚¯‚é‹«ŠEğŒ‚ğ—^‚¦‚éŠÖ”
  %A_upbound = ones(2 + params.noGS,1);
  A_upbound(:,1) = A(:, 2); %ƒmƒCƒ}ƒ“‚Ì‹«ŠEğŒ
  A_upbound(2,1) = 0; %ŒÅ’è
  
  
%% lock exchange model 
%   A_upbound(2,:) = eps;%zeros;%—¬‘¬‚Ílock exchange@2016/11/08
  
end

%% memo
% %     %h = -local_topo ./ params.ho; % h‚Íh^, ‚Ü‚½(1 X nogrid)‚Ìs—ñ
% %     %A = [h;h;h;h;zeros(1,params.grid);-h;(params.Fsand * (1-(h ./ params.La)));(params.Fmud * (1-(h ./ params.La)))] .* A; %h‚Í–³ŸŒ³‰»‚³‚ê‚Ä‚é
% %   A_upbound = [1;1;1; params.eta(1,1) .* params.Fsand ./ params.ho;params.Fsand] .* A_upbound;




