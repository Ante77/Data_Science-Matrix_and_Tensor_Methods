a=load('data5');
A=a.data;
y=2000;
A=A(1:y,:)';
B=a.labels;


k = zeros(1, 10);
for i = 1:y
    j = B(i)+1;
    k(j) = k(j)+1;
end

q=min(k);

Z = zeros(96*32, q, 10);
broj=zeros(1,10);
for i = 1:y
    j = B(i)+1;
    broj(j)= broj(j)+1;
    if(broj(j) <= q)
        Z(:,broj(j),j)=A(:,i);
    end

end
size(Z)
[S,U1,U2,U3] = hosvd(Z);
p=128;
q=64;
U1_p = U1(:,1:p);
U2_q = U2(:,1:q);
F = ten_mat_m(S(1:p,1:q,:),U3, 3);

k=25;
B=cell(1,10);
for i=1:10
    F_i=F(:,:,i);
    [U,S,V]=svd(F_i);
    B{i}=U(:,1:k);
    plot(diag(S));
    hold on;
end
hold off;


%test faza

% t = load('testzip.mat');
% T = t.testzip;
% znam = zeros(1, 2007);
% 
% R=zeros(1,10);
% 
% for i=1:2007
%     d=T(:,i);
%     d_p=U1_p'*d;
%     for j=1:10
%         R(j)=norm(d_p- B{j}*B{j}'*d_p);
%     end
%     [~, ind] = min(R);
%     znam(i) = ind-1;
% end
% 
% s = load('dtest.mat');
% S = s.dtest;
% 
% Err = find(abs(S - znam));
% err = max(size(Err)) / 2007
% 
% 
