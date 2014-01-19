% example
load OrgsPeople_src;
load OrgsPeople_tar;
Xs = OrgsPeople_src_data;
Ys = OrgsPeople_src_label;
Xt = OrgsPeople_tar_data;
Yt = OrgsPeople_tar_label;
% 
% load OrgsPlaces_src;
% load OrgsPlaces_tar;
% Xs = OrgsPlaces_src_data;
% Ys = OrgsPlaces_src_label;
% Xt = OrgsPlaces_tar_data;
% Yt = OrgsPlaces_tar_label;
% % 
% load PeoplePlaces_src;
% load PeoplePlaces_tar;
% Xs = PeoplePlaces_src_data;
% Ys = PeoplePlaces_src_label;
% Xt = PeoplePlaces_tar_data;
% Yt = PeoplePlaces_tar_label;
% % % 
% % % 
[nt,d] = size(Xt);
ns = size(Xs,1);
Z = [Xs;Xt];
a = sum(Z);
i = (a>0);
Z = Z(:,i);
Xs = Z(1:ns,:);
Xt = Z(ns+1:end,:);

Z = my_tfidf([Xs;Xt],1);
a = sum(Z);
i = (a>0);
Z = Z(:,i);
Xs = Z(1:ns,:);
Xt = Z(ns+1:end,:);


r = 3;
step = 1;
kt = max(Yt);
ks = max(Ys);
k = kt;
nei1 = 27;
nei2 = 27;
options1 = [];
options1.NeighborMode = 'KNN';
options1.k = nei1;
options1.WeightMode = 'Binary';
% options1.WeightMode = 'Cosine';
% options1.WeightMode = 'HeatKernel';
% options1.prenormalize = 1;

W11 = constructW(Xt,options1);
W22 = constructW(Xs,options1);


[Ft, Fs,iter] = transferSpectralClustering(Xt,Xs,k,r,step,W11,W22);
[purity10,nmi10,randindex10] = evaluate_and_print(Ft,Fs,Yt,Ys,kt,ks,true,'transfer Spectral Clustering');
