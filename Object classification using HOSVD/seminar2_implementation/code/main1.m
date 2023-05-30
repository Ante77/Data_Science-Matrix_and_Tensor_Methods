a = load('azip.mat');
d = load('dzip.mat');

A = reshape(a.azip, 16, 16, 1707);
D = d.dzip;

Z = cell(1, 10);
for i = 1:10
    Z{i} = zeros(16,16,1);
end

k = zeros(1, 10);
for i = 1:1707
    j = D(i)+1;
    k(j) = k(j)+1;
    Z{j}(:,:,k(j)) = A(:,:,i);
end

% 2. i 3. korak
for i=1:10
    [S,U1,U2,U3] = hosvd(Z{i});
    for j=1:k(i)
        X1 = ten_mat_m(S(:,:,j), U1, 1);
        X=ten_mat_m(X1,U2,2);
        %Z{i}(:,:,j)=X/norm(X);
        Z{i}(:,:,j)=X;
    end
end

for i=1:10
    norme = zeros(1, k(i));
    for j=1:k(i)
        norme(j)=norm(Z{i}(:,:,j),'fro');
    end
%     semilogy(1:k(i),norme,'LineWidth',2);
%     hold on;
end
% legend('0','1','2','3','4','5','6','7','8','9');
% ylabel('norme baznih matrica');
% xlabel('indeksi');
% hold off;



%test faza

t = load('testzip.mat');
T = reshape(t.testzip, 16, 16, 2007);

znam = zeros(1, 2007);
err = zeros(1,50);

p = 1:1:50;
for sss = 1:max(size(p))
    for it = 1:2007
        D = T(:,:,it)/norm(T(:,:,it), 'fro');
        R = zeros(1, 10);
        for i = 1:10
            ZZ = zeros(16, 16, 1);
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

    s = load('dtest.mat');
    S = s.dtest;

    Err = find(abs(S - znam));
    err(sss) = max(size(Err)) / 2007;
end