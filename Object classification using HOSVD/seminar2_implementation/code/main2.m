a = load('azip.mat');
d = load('dzip.mat');

A = a.azip;
D = d.dzip;

k = zeros(1, 10);
for i = 1:1707
    j = D(i)+1;
    k(j) = k(j)+1;
end

q=min(k)

Z = zeros(256, q, 10);
broj=zeros(1,10);
for i = 1:1707
    j = D(i)+1;
    broj(j)= broj(j)+1;
    if(broj(j) <= q)
        Z(:,broj(j),j)=A(:,i);
    end

end

[S,U1,U2,U3] = hosvd(Z);
p=88;
q=88;
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
        %plot(diag(S));
        %hold on;
    end
    %hold off;


    %test faza

    t = load('testzip.mat');
    T = t.testzip;
    x = 2007;
    znam = zeros(1, x);

    R=zeros(1,10);

    for i=1:x
        d=T(:,i);
        d_p=U1_p'*d;
        for j=1:10
            R(j)=norm(d_p- B{j}*B{j}'*d_p);
        end
        [~, ind] = min(R);
        znam(i) = ind-1;
    end

    s = load('dtest.mat');
    S = s.dtest;

    Err = find(abs(S - znam));
    err(sss) = max(size(Err)) / x;
    sss
end

max(1-err)

figure()
plot(k,1-err,'-r','LineWidth',2)
xlabel("k");
ylabel("Uspješnost");