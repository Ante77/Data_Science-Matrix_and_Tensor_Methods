%priprema podataka
a=load('data5');
Ac=a.data;
y=400;
Ac=Ac(1:y,:)';

At=zeros(32,32,3,y);
A=zeros(32,32,y);
B=a.labels;

k = zeros(1, 10);
for i = 1:y
    j = B(i)+1;
    k(j) = k(j)+1;
end

q=min(k)

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

Z = zeros(1024, q, 10);
broj=zeros(1,10);
for i = 1:y
    j = B(i)+1;
    broj(j)= broj(j)+1;
    if(broj(j) <= q)
        Z(:,broj(j),j)=floor(255*reshape(A(:,:,i),1024,1));
    end

end

[S,U1,U2,U3] = hosvd(Z);
p=128;
q=29;
U1_p = U1(:,1:p);
U2_q = U2(:,1:q);
F = ten_mat_m(S(1:p,1:q,:),U3, 3);

k=1:1:p; % mora biti velicine do p
B=cell(1,10);
err=zeros(1,max(size(k)));

for sss=1:max(size(k))
    for i=1:10
        F_i=F(:,:,i);
        [U,S,V]=svd(F_i);
        B{i}=U(:,1:k(sss));
    end
    t = load('test_batch');
    x = 1000;
    Tc= int(t.data(1:x,:)');
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

    R=zeros(1,10);

    for i=1:x
        d=reshape(T(:,:,i),1024,1);
        d_p=U1_p'*d;
        for j=1:10
            R(j)=norm(d_p- B{j}*B{j}'*d_p);
        end
        [~, ind] = min(R);
        znam(i) = ind-1;
    end

     S = double(t.labels(1:x,:));

    Err = find(abs(S' - znam));
    err(sss) = max(size(Err)) / x;
    sss
end

max(1-err)

figure()
plot(k,1-err,'-r','LineWidth',2)
xlabel("k");
ylabel("Uspješnost");