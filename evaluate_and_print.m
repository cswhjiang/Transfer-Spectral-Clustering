function [purity,nmi,randindex] = evaluate_and_print(F1,F2,Y1,Y2,k1,k2,display_flag,display_str)
% evaluate the performance of clustering, if display_flag is true, the result will be displayed

kmtrials = 100;
pred1=kmeans_freq(F1,k1,kmtrials,'m');
pred2=kmeans_freq(F2,k2,kmtrials,'m');



purity1    = eval_acc_purity(Y1,pred1);
nmi1       = eval_nmi(Y1,pred1);
randindex1 = eval_rand(Y1,pred1);

purity2    = eval_acc_purity(Y2,pred2);
nmi2       = eval_nmi(Y2,pred2);
randindex2 = eval_rand(Y2,pred2);


purity     = (purity1 + purity2)/2;
nmi        = (nmi1 + nmi2)/2;
randindex  = (randindex1 + randindex2)/2;

purity     = round(purity*10000)/10000;
nmi        = round(nmi*10000)/10000;
randindex  = round(randindex*10000)/10000;

if display_flag == true
    disp(display_str);
    disp(['purity:    ' num2str(purity)]);
    disp(['nmi:       ' num2str(nmi)]);
    disp(['randindex: ' num2str(randindex)]);
end
end