function [kl] = myHistDist(N_comp, N_ref)
%% KL Distance
    Q=N_comp./sum(N_comp)+eps;
    P=N_ref./sum(N_ref)+eps;
    kl=sum(P.*log10(P./Q));
end

