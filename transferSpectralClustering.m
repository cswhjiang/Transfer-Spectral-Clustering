function [F1, F2,iter] = transferSpectralClustering(Xt,Xs,k,r,step,W11,W22)
% parameters:
%   Xt            - data matrix from target domain
%   Xs            - data matrix from soure domain
%   k             - the number of clusters
%   r             - trade off parameter
%   step          - step length
%   maxiter       - maximum number of iterations
%   W11           - affinity matrix for the target domain
%   W22           - affinity matrix for the source domain
%  
% ref:
%   Jiang, Wenhao, and Fu-lai Chung. "Transfer spectral clustering." Machine Learning 
%   and Knowledge Discovery in Databases. Springer Berlin Heidelberg, 2012. 789-803.
% 
%   Author: Wenhao Jiang (cswhjiang@comp.polyu.eud.hk)


[nt d] = size(Xt);
ns = size(Xs,1);

% n = nt + ns;

A1 = Xt - min(min(Xt));
A2 = Xs - min(min(Xs));
% A1(A1>0) = 1;A2(A2>0) = 1; 
[A1] = normalize_matrix(A1);
[A2] = normalize_matrix(A2);

% fea2 = my_tfidf([Xt;Xs],1);
% Xt = fea2(1:nt,:);
% Xs = fea2(nt+1:end,:);

% options1 = [];
% options1.NeighborMode = 'KNN';
% options1.k = nei1;
% options1.WeightMode = 'Binary';
%
% W11 = constructW(Xt,options1);
% W22 = constructW(Xs,options1);
[W11] = normalize_matrix(W11);
[W22] = normalize_matrix(W22);
W11 = (W11 + W11')/2;
W22 = (W22 + W22')/2;


[F1,D1] = eigs(W11,k,'LA');
[D1,index] = sort(diag(D1),'descend');
F1 = F1(:,index);
% F1 = randn(size(F1));

[F2,D2] = eigs(W22,k,'LA');
[D2,index] = sort(diag(D2),'descend');
F2 = F2(:,index);
% F2 = randn(size(F2));


[F1,F2,F3] = init_F3(F1,F2,A1,A2,k);
% F3 = randn(size(F3));

[f_old,f1,f2,f3,f4] = compute_obj(W11,W22,F1,F2,F3,A1,A2,r);
% disp(['init;']);
% disp(['f: ' num2str(f) ' f1: ' num2str(f1) ' f2: ' num2str(f2) ' f3: ' num2str(f3) ' f4: ' num2str(f4)]);
% disp(' ');

iter = 1;
% f_old  = 1000000;
if r > 0
    while true
        if rem(iter,100) == 0
            disp(['iter:' num2str(iter) ' obj: ' num2str(f_old)]);
%                     disp(['f: ' num2str(f_old) ' f1: ' num2str(f1) ' f2: ' num2str(f2) ' f3: ' num2str(f3) ' f4: ' num2str(f4)]);
%                     disp( ' ');
        end
        
        F1  = update_F1(W11,W22,F1,F2,F3,A1,A2,r,step);
%         [f_current,f1,f2,f3,f4] = compute_obj(W11,W22,F1,F2,F3,A1,A2,r);disp(['iter:' num2str(iter) ' update1 obj: ' num2str(f_current)]);
         
        F2  = update_F2(W11,W22,F1,F2,F3,A1,A2,r,step);
%         [f_current,f1,f2,f3,f4] = compute_obj(W11,W22,F1,F2,F3,A1,A2,r);disp(['iter:' num2str(iter) ' update2 obj: ' num2str(f_current)]);
         
        F3  = update_F3(W11,W22,F1,F2,F3,A1,A2,r,step);
%         [f_current,f1,f2,f3,f4] = compute_obj(W11,W22,F1,F2,F3,A1,A2,r);disp(['iter:' num2str(iter) ' update3 obj: ' num2str(f_current)]);
         
        [f_new,f1,f2,f3,f4]  = compute_obj(W11,W22,F1,F2,F3,A1,A2,r);%f_new should be bigger than f_old
%         if f_new <= f_old
%             error('wrong in TSC');
%         end
        if (abs(f_new - f_old) < 0.00001 )
            break;
        end
        f_old = f_new;
        iter = iter + 1;
%         disp(' ');
    end
end
% f_ideal = compute_ideal_objective(W11,W22,A1,A2,r,F3,Yt,Ys);
for i = 1:nt
    F1(i,:) = F1(i,:)/norm(F1(i,:));
end

for i = 1:ns
    F2(i,:) = F2(i,:)/norm(F2(i,:));
end

end

function [f,f1,f2,f3,f4] = compute_obj(W11,W22,F1,F2,F3,A1,A2,r)
f1 = trace(F1'*W11*F1);
f2 = trace(F2'*W22*F2);
f3 = r*trace(F1'*A1*F3);
f4 = r*trace(F2'*A2*F3);
f = f1 + f2 + f3 + f4;
% disp(['f1: ' num2str(f1) ' f2: ' num2str(f2) ' f3: ' num2str(f3) ' f4: ' num2str(f4)]);
end

function F1  = update_F1(W11,W22,F1,F2,F3,A1,A2,r,step)

dF1 = 2*W11*F1 + r*A1*F3;
dF1 = dF1/norm(dF1,'fro');
F1 = F1 + step*dF1;
[F1] = find_projection(F1);

end

function F2  = update_F2(W11,W22,F1,F2,F3,A1,A2,r,step)

dF2 = 2*W22*F2  + r*A2*F3;
dF2 = dF2/norm(dF2,'fro');
F2 = F2 + step*dF2;
[F2] = find_projection(F2);
end

function F3  = update_F3(W11,W22,F1,F2,F3,A1,A2,r,step)

F3 = A1'*F1+ A2'*F2;

% dF3 =  r*A1'*F1 + r*A2'*F2;
% dF3 = dF3/norm(dF3,'fro');
% F3 = F3 + step*dF3;
[F3] = find_projection(F3);
end

function [Ap] = find_projection(A)
% disp('projection');
[U D V] = svd(A,0);
% Ap = U*eye(size(D))*V';
Ap = U*V';
assert(norm(Ap'*Ap - eye(size(Ap,2)),'fro')<0.000000001,'wrong projection');
end


function [A] = normalize_matrix(A)
[nt ns] = size(A);

D1 = sum(A,2);% sum of column nt*1
D2 = sum(A,1);% 1*ns
D1 = sqrt(D1);
D2 = sqrt(D2);

for i = 1:nt
    if D1(i)~=0
        A(i,:) = A(i,:)/D1(i);
    end
end

for i = 1:ns
    if D2(i) ~=0
        A(:,i) = A(:,i)/D2(i);
    end
end
end

function [F1,F2,F3] = init_F3(F1,F2,A1,A2,k)
[A] = normalize_matrix([A1;A2]);
% [U S V] = svds(A,l+1);
% n = size(A,2);
% F = zeros(n,k);

% [U S V] = svd(full(A),'econ');
[U S V] = svds(A,k);
[s index] = sort(diag(S),'descend');
F3 = V(:,index);
% sum(s)
for i = 1:k
    F3(:,i) = F3(:,i)/norm(F3(:,i));
    t1 = F1(:,i)'*A1*F3(:,i);
    if t1 < 0
        F1(:,i) = -F1(:,i);
    end
    
    t2 = F2(:,i)'*A2*F3(:,i);
    if t2 < 0
        F2(:,i) = -F2(:,i);
    end
end

end
