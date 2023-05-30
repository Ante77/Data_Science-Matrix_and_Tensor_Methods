tic;
A = [0 1 0
     0 0 1
     0 0 0];

rijeci = readcell('index.txt'); %ova linija potrebna samo kada pokrecemo kod prvi put

indeks = 109633 ;%biramo rijec iz "index.txt" cije cemo sinonime traziti
rijec = rijeci(indeks);

C = readcell('dico.txt'); %ova linija potrebna samo kada pokrecemo kod prvi put
% dict , 112169  riječi
D = cell2mat(C); %ova linija potrebna samo kada pokrecemo kod prvi put
nD = max(size(D));%ova linija potrebna samo kada pokrecemo kod prvi put

% broj_pojavljivanja = zeros(112169,1); % vektor koji sadrzi info u koliko se def pojavljuje rijec i
% for i = 1:112169
%     br = 0;
%     for j = 1:nD
%         if D(j,2) == i
%             br = br+1;
%         end
%     end
%     broj_pojavljivanja(i) = br;
% end
broj_pojavljivanja=load('Br_pojavljivanja.csv');

toc
fprintf('\nuvod\n');


tic;
nB = 0;% gledamo koliko ce vrhova imati graf za odabranu rijec
for i = 1:nD
    if (D(i, 1) == indeks) || (D(i, 2) == indeks)
        nB = nB+1;
    end
end

toc
fprintf('\nracunanje nB\n');

tic;
I = zeros(nB, 1);
j = 0;
for i = 1:nD
    if D(i, 1) == indeks
        I(j+1) = D(i, 2);% stavljamo u I sve rijeci koje se pojavljuju def. odabrane rijeci
        j = j+1;
    end
    if D(i, 2) == indeks
        I(j+1) = D(i, 1);% takoder u I stavljamo sve rijeci koje koriste odabranu rijec u svojoj def.
        j = j+1;
    end
end
toc
fprintf('\nindekisranje susjeda\n');

J = unique(I, 'stable');% brisemo sve duplikate iz  I
nB = max(size(J));

tic;
B = zeros(nB, nB);
for i = 1:nB
    for j = 1:nB
        for k = 1:nD
            if D(k, 1) == J(i) && D(k, 2) == J(j)
                B(i,j) = 1;
            end
        end
    end
end

toc
fprintf('\npunjenje B, tri petlje\n');

tic;

S = mat_slic(A, B);
s = S(:,2);
[sin, K] = sort(s, 'descend');

toc
fprintf('\nracunanje matr. slic\n');

tic;

S2 = mat_slic(A, B);
s2 = S2(:,2);
s3=s2;
s4=s2;
s5=s2;
s6=s2;
s7=s2;
s8=s2;
s9=s2;
for i = 1:nB
   % s2(i) = s2(i) / (broj_pojavljivanja(J(i)) + 1);
    s3(i) = s3(i) / (broj_pojavljivanja(J(i)) + pi);
%     s4(i) = s4(i) / (broj_pojavljivanja(J(i)) + 5);
%     s5(i) = s5(i) / (broj_pojavljivanja(J(i)) + 10);
%     s6(i) = s6(i) / (broj_pojavljivanja(J(i)) + 20);
%     s7(i) = s7(i) / (broj_pojavljivanja(J(i)) + 50);
%     s8(i) = s8(i) / (broj_pojavljivanja(J(i)) + 100);
%     s9(i) = s9(i) / (broj_pojavljivanja(J(i)) + 300);
end
%[sin2, K2] = sort(s2, 'descend');
[sin3, K3] = sort(s3, 'descend');
% [sin4, K4] = sort(s4, 'descend');
% [sin5, K5] = sort(s5, 'descend');
% [sin6, K6] = sort(s6, 'descend');
% [sin7, K7] = sort(s7, 'descend');
% [sin8, K8] = sort(s8, 'descend');
% [sin9, K9] = sort(s9, 'descend');
toc
fprintf('\nracunanje matr.slicnosti MI\n');


for i = 1:nB
    fprintf('%s', rijeci{J(K(i))});
    fprintf('\n');
end

fprintf('\n\n -------------------------- \n\n');


% for i = 1:10
%     fprintf('%s', rijeci{J(K2(i))});
%     fprintf('\n');
% end
fprintf('\n');
for i = 1:nB
    fprintf('%s', rijeci{J(K3(i))});
    fprintf('\n');
end
% fprintf('\n');
% for i = 1:10
%     fprintf('%s', rijeci{J(K4(i))});
%     fprintf('\n');
% end
% fprintf('\n');
% for i = 1:10
%     fprintf('%s', rijeci{J(K5(i))});
%     fprintf('\n');
% end
% fprintf('\n');
% for i = 1:10
%     fprintf('%s', rijeci{J(K6(i))});
%     fprintf('\n');
% end
% fprintf('\n');
% for i = 1:10
%     fprintf('%s', rijeci{J(K7(i))});
%     fprintf('\n');
% end
% fprintf('\n');
% for i = 1:10
%     fprintf('%s', rijeci{J(K8(i))});
%     fprintf('\n');
% end
% fprintf('\n');
% for i = 1:10
%     fprintf('%s', rijeci{J(K9(i))});
%     fprintf('\n');
% end