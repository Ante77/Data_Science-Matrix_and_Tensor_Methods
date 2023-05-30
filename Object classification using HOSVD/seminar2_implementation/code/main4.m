% a=load('data5');
% A=a.data;
% y=2000;
% A=A(1:y,:)';
% A=reshape(A,96,32,y);
% B=a.labels;
% 
% Z=cell(1,10);
% for i = 1:10
%     Z{i} = zeros(96,32,1);
% end
% 
% k = zeros(1, 10);
% for i = 1:y
%     j = B(i)+1;
%     k(j) = k(j)+1;
%     Z{j}(:,:,k(j)) = A(:,:,i);
% end
% 
% 
% % 2. i 3. korak
% for i=1:10
%     size(Z{i})
%     [S,U1,U2,U3] = hosvd(Z{i});
%     for j=1:k(i)
%         X1 = ten_mat_m(S(:,:,j), U1, 1);
%         X=ten_mat_m(X1,U2,2);
%         %Z{i}(:,:,j)=X/norm(X);
%         Z{i}(:,:,j)=X;
%     end
% end
% 
% for i=1:10
%     norme = zeros(1, k(i));
%     for j=1:k(i)
%         norme(j)=norm(Z{i}(:,:,j),'fro');
%     end
%     semilogy(1:k(i),norme,'LineWidth',2);
%     hold on;
% end
% legend('0','1','2','3','4','5','6','7','8','9');
% ylabel('norme baznih matrica');
% xlabel('indeksi');
% hold off;



%test faza

x = 1000;
t = load('test_batch');
T = double(t.data(1:x,:));
T = reshape(T', 96, 32, x);

znam = zeros(1, x);

p = 1000:500:20000;
err = zeros(1,max(size(p)));

for sss = 1:max(size(p))
    for it = 1:x
        D = T(:,:,it)/norm(T(:,:,it), 'fro');
        R = zeros(1, 10);
        for i = 1:10
            ZZ = zeros(96, 32, 1);
            for j = 1:k(i)
                %R(i) = R(i) + mat_sk_prod(D, Z{i}(:,:,j))^2;
                if norm(Z{i}(:,:,j), 'fro') > p(sss)
                    ZZ = ZZ + trace(Z{i}(:,:,j)' * D) / norm(Z{i}(:,:,j), 'fro')^2 * Z{i}(:,:,j);
                end
            end
        %R(i) = 1 - R(i);
        R(i) = norm(D - ZZ, 'fro');
        end
        [~, ind] = min(R);
        znam(it) = ind-1;
    end

    S = double(t.labels(1:x,:));

    Err = find(abs(S' - znam));
    err(sss) = max(size(Err)) / x;
end