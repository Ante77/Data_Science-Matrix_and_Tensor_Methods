%priprema podataka
a=load('data5');
Ac=a.data;
y=2000;
Ac=Ac(1:y,:)';

At=zeros(32,32,3,y);
A=zeros(32,32,y);
B=a.labels;


for n=1:y
    for i=1:1024
        if rem(i,32) == 0
            pr = 32;
        else
            pr = rem(i,32);
        end
        
        At(ceil(i/32), pr, 1, n)=Ac(i, n);
        At(ceil(i/32), pr, 2, n)=Ac(i+1024, n);
        At(ceil(i/32), pr, 3, n)=Ac(i+2048, n);
    end
    A(:,:,n)=rgb2gray(At(:,:,:,n)/255);
end

% At(:,:,:,1)/255
% imshow(At(:,:,:,15)/255);
%I = rgb2gray(At(:,:,:,15)/255);
% imshow(I);

%imshow(Z(:,:,30));

%------------------
Z = cell(1, 10);
for i = 1:10
    Z{i} = zeros(32,32,1);
end

k = zeros(1, 10);
for i = 1:y
    j = B(i)+1;
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

x = 2000;
t = load('test_batch');
Tc = double(t.data(1:x,:)');

%slike spremljene po stupcima spremamo kao tenzore, tj. u formatu RGB
Tt=zeros(32,32,3,y);
T=zeros(32,32,y);

for n=1:x
    for i=1:1024
        if rem(i,32) == 0
            pr = 32;
        else
            pr = rem(i,32);
        end
        
        Tt(ceil(i/32), pr, 1, n)=Tc(i, n);
        Tt(ceil(i/32), pr, 2, n)=Tc(i+1024, n);
        Tt(ceil(i/32), pr, 3, n)=Tc(i+2048, n);
    end
    T(:,:,n)=rgb2gray(Tt(:,:,:,n)/255); %grayscaleamo slike
end



znam = zeros(1, x);

p = 0.25:0.25:20;
err = zeros(1,max(size(p)));

for sss = 1:max(size(p))
    for it = 1:x
        D = T(:,:,it)/norm(T(:,:,it), 'fro');
        R = zeros(1, 10);
        for i = 1:10
            ZZ = zeros(32, 32, 1);
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

% figure()
% plot(p,1-err,'-r','LineWidth',2)
% xlabel("M");
% ylabel("Uspješnost");