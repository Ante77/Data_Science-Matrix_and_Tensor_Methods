clear 
clear all

image_path = 'forest100x100.jpeg';
image = double(imread(image_path)) / 255;
imshow(image)


imageHeight = size(image, 1);
imageWidth = size(image, 2);

%varijabilni parametri
sigma = 0.5;
    
inpaintWidth = 10;
inpaintHeight = 30;


[~, holeMask] = generate_masks(image_path, inpaintWidth, inpaintHeight);
I = image.*holeMask;
%imshow(I)
%saveas(gcf, 'ombre_hole.png');


br = sum(holeMask(:));
W = zeros(br, br);

count1 = 0;


for i = 1:size(holeMask, 1)
    for j = 1:size(holeMask, 2)
        if holeMask(i, j) == 1
            count1 = count1 + 1;
            count2 = 0;
            for k = 1:size(holeMask, 1)
                for l = 1:size(holeMask, 2)
                    if holeMask(k, l) == 1
                        count2 = count2 + 1;
                        if count2 >= count1
                            x1 = reshape(image(i, j, :), 1, []);
                            x2 = reshape(image(k, l, :), 1, []);
                            W(count1, count2) = kernel_f(x1, x2, sigma);
                            W(count2,count1) = W(count1, count2);
                        end
                    end
                end
            end
        end
    end
end

e = ones(br,1);
d = W*e;
d_1=1./d;
D_inv = diag(d_1);
A = D_inv*W;
[V, D] = eig(A);

clear W;
clear A;
clear image;
clear holeMask;

% Extract eigenvalues
 eigenvalues = diag(D);
clear D;

% Sort eigenvalues in descending order
[sortedEigenvalues, indices] = sort(eigenvalues, 'descend');

% Plot all eigenvalues
figure;
plot(1:max(size(sortedEigenvalues)),sortedEigenvalues, 'o');
title('Eigenvalues of A');
xlabel('Eigenvalue Index');
ylabel('Eigenvalue');


saveas(gcf, 'eigenvalues_plot.png');

% Define the cutoff threshold
cutoff = 0.01;

% Determine the number of leading eigenvectors based on the cutoff
numEigenvectors = sum(sortedEigenvalues > cutoff);

% Select the leading eigenvectors based on the cutoff
% Psi=diag(sortedEigenvalues)*V';
% clear Psi;
% %uzet ćemo prvih k = numEigenvectors redaka
% Psi_k=Psi(1:numEigenvectors,:);
Psi_k= diag(sortedEigenvalues(1:numEigenvectors)) * V(:,1:numEigenvectors)';%ovo bi trebalo raditii!
%to jos mozes reducirat, jer znamo da je desni blok od 
%inpaintanje rupe H
clear d;
clear d_1;
clear D_inv;
clear e;
clear eigenvalues;
clear V;
psi_H = zeros(inpaintWidth * inpaintHeight, numEigenvectors);
iter = 1;

startX = round((imageWidth - inpaintWidth) / 2);
startY = round((imageHeight - inpaintHeight) / 2);


for i = startY:startY+inpaintHeight-1
    for j = startX:startX+inpaintWidth-1
        if (i==startY && j==startX)
            indices=zeros(5,1);
            indices(1:4,1)=[(i-2)*100 + j-1;%ćošak, za jedan gore i za jedan lijevo
                            (i-2)*100 + j;%iznad trenutnog piksela
                            (i-2)*100 + j+1;% iznad udesno
                            (i-1)*100 + j-1];%ulijevo
            indices(5,1) = (i)*100 + j - 1 - inpaintWidth;%(i+1,j-1),njemu se indeks mijenja zbog rupe H
        
        matr = Psi_k(:,indices);
        psi_H(iter,:) = mean(matr,2)'; %moguce da dimenzije nece pasat
        iter = iter + 1;
        end
       
        if (i == startY && startX <j && j < startX + inpaintWidth-1)
            %prvi redak, ali ne ćoškovi
            indices=zeros(3,1);%gledamo lijevog i tri iznad
            indices(1:3,1)=[(i-2)*100 + j-1;% za jedan gore i za jedan lijevo
                            (i-2)*100 + j;%iznad trenutnog piksela
                            (i-2)*100 + j+1];% iznad udesno
                        
            matr1 = Psi_k(:,indices);
            matr2 = psi_H(iter-1,:)';
            matr =  [matr1 matr2];
            psi_H(iter,:) = mean(matr,2)';
            iter = iter + 1;
        end
        
        if (i==startY && j==(startX + inpaintWidth-1))
            indices=zeros(5,1);
            indices(1:5,1)=[(i-2)*100+j-1;% za jedan gore i za jedan lijevo
                            (i-2)*100 + j;%iznad trenutnog piksela
                            (i-2)*100 + j + 1;% iznad udesno
                            (i-1)*100 + j + 1 - inpaintWidth;%udesno, pazimo na rupu pa se indeks mijenja
                            (i)*100 + j + 1 - 2 *inpaintWidth ];%(i+1,j+1), njemu se indeks mijenja zbog rupe H
                           
            matr = Psi_k(:,indices);
            psi_H(iter,:) = mean(matr,2)'; %moguce da dimenzije nece pasat
            iter = iter + 1;
        end
  
        %prvi redak rijesen, idemo sada za sve ostale, osim zadnjeg
        
        %lijevi rub rupe H
        if(i>startY && i<startY+inpaintHeight-1)
            if(j==startX)
                indices=zeros(3,1);%ona 3 piksela koja su u referentnom podrucju, tj.poznatom
                indices(1:3,1)=[(i-2)*100 + j-1 - (i-startY)*inpaintWidth;% za jedan gore i za jedan lijevo
                                (i-1)*100 + j-1 - (i-startY)*inpaintWidth;
                                (i-3)*100 + j-1 - (i-startY)*inpaintWidth];
                matr1 = Psi_k(:,indices);
                matr2 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                matr3 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
                disp(size(matr1))
                disp(size(matr2))
                disp(size(matr3))
                                
                matr = [matr1 matr2 matr3];
                psi_H(iter,:) = mean(matr,2)'; %moguce da dimenzije nece pasat
                iter = iter + 1;
            end
            
             if(startX <j && j < startX + inpaintWidth-1)
               
                 matr1 = psi_H(iter-1,:)';%gledamo piksel slijeva, odnosno prethodni
                 matr2 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                 matr3 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
                 matr4 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela iznad lijevo
                 matr =  [matr1 matr2 matr3 matr4];
                 psi_H(iter,:) = mean(matr,2)';
                 iter = iter + 1;
                 
             end
             
             %desni rub, ali ne i coskovi
             if(j==(startX + inpaintWidth-1))
                 %gledamo 3 iz psi_H i 3 iz referentnog podrucja

                indices=zeros(3,1);
                
                indices(1) = (i-1)*100 + j + 1-(i-startY)*inpaintWidth;
                indices(2) = (i-2)*100 + j + 1 -(i-startY)*inpaintWidth;
                indices(3) = (i-2)*100 + j -(i-startY)*inpaintWidth;
%                 indices=[(i-1)*100 + j + 1-(i-startY)*inpaintWidth;% za jedan desno
%                                 (i-2)*100 + j + 1 -(i-startY)*inpaintWidth;% iznad udesno
%                                 (i-2)*100 + j -(i-startY)*inpaintWidth];% iznad, pazimo na rupu pa se indeks mijenja
                size(indices)
                            
                matr1 = Psi_k(:,indices);
                matr2 = psi_H(iter-1,:)';%embedded koor. prethodnog piksela 
                matr3 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                matr4 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela iznad lijevo
                matr = [matr1 matr2 matr3 matr4];
                 
                psi_H(iter,:) = mean(matr,2)'; %moguce da dimenzije nece pasat
                iter = iter + 1;
                 
             end
          
            
        end
        
        %dno rupe H
        if(i==startY+inpaintHeight-1)
            if(j==startX) 
                indices=[(i-2)*100+j-1-(i-1-startY)*inpaintWidth;% za jedan gore i ulijevo
                                (i-1)*100+j-1-(i-startY)*inpaintWidth;% ulijevo
                                (i)*100+j-1-(i+1-startY)*inpaintWidth;% dolje ulijevo
                                (i)*100+j-(i+1-startY)*inpaintWidth;% ispod
                                (i)*100+j+1-(i+1-startY)*inpaintWidth];% dolje udesno
                       
                
                matr1 = Psi_k(:,indices);
                matr2 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                matr3 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad lijevo
                
                matr = [matr1 matr2 matr3];
                 
                psi_H(iter,:) = mean(matr,2)'; %moguce da dimenzije nece pasat
                iter = iter + 1;
                
            end
            
            if(startX <j && j < startX + inpaintWidth-1)
                
                indices=zeros(3,1);
                indices(1:3,1)=[(i)*100+j-1-(i+1-startY)*inpaintWidth;% dolje ulijevo
                                (i)*100+j-(i+1-startY)*inpaintWidth;% ispod
                                (i)*100+j+1-(i+1-startY)*inpaintWidth];% dolje udesno
                matr1 = Psi_k(:,indices);
                matr2 = psi_H(iter-1,:)';%gledamo piksel slijeva, odnosno prethodni
                matr3 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                matr4 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
                matr5 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela iznad lijevo
                matr =  [matr1 matr2 matr3 matr4 matr5];
                psi_H(iter,:) = mean(matr,2)';
                iter = iter + 1;
                 
            end
             if(j == startX + inpaintWidth-1)
                 indices=zeros(5,1);
                 indices(1:5,1)=[(i)*100+j-1-(i+1-startY)*inpaintWidth;% dolje ulijevo
                                (i)*100+j-(i+1-startY)*inpaintWidth;% ispod
                                (i)*100+j+1-(i+1-startY)*inpaintWidth;% dolje udesno
                                (i-1)*100+j+1-(i-startY)*inpaintWidth;% desno
                                (i-2)*100+j+1-(i+1-startY)*inpaintWidth];% gore desno


                matr1 = Psi_k(:,indices);
                matr2 = psi_H(iter-1,:)';%gledamo piksel slijeva, odnosno prethodni
                matr3 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                matr4 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela iznad lijevo
                matr =  [matr1 matr2 matr3 matr4];
                psi_H(iter,:) = mean(matr,2)';
                iter = iter + 1;
                 
             end
        end
    end             
end

clear matr;
clear matr1;
clear matr2;
clear matr3;
clear matr4;
clear matr5;


figure;
imagesc(psi_H);
colorbar; % Add a colorbar for reference
title('Matrix Plot')


k = 10;%koliko najblizih susjeda uzimamo
M = zeros(inpaintWidth * inpaintHeight,k);
for i = 1:inpaintWidth * inpaintHeight
    v = zeros(br,1);
    for j = 1:br
        v(j) = norm(Psi_k(:,j)-psi_H(i,:)');
    end
    [~, indices] = sort(v, 'ascend');
    M(i,:)=indices(1:k);
end

for i = startY:startY+inpaintHeight-1
    for j = startX:startX+inpaintWidth-1
        %I(i,j,:) punimo sa RGB vrijednostima od k- najblizih susjeda iz
        %referentnog podrucja
        pom_m=zeros(k,3);
        ind = (i-startY)*inpaintWidth + j-startX +1;
        %indices1 = M(ind,:);
        for l = 1:k
            [x_i, x_j]=return_indices(M(ind,l),imageWidth);
            pom_m(l,:)=I(x_i,x_j,:);
        end
        I(i,j,:) = mean(pom_m,1);
    end
end

clear M;

imshow(I);
title(['\sigma = ' num2str(sigma)]);

filename = ['forest_inpaint_' num2str(sigma) '.png'];
saveas(gcf, filename);
clear psi_H;

psi_H = difusion_inpaint_spiral(Psi_k,imageWidth, imageHeight, inpaintWidth, inpaintHeight, numEigenvectors);
k = 10;%koliko najblizih susjeda uzimamo
M = zeros(inpaintWidth * inpaintHeight,k);
for i = 1:inpaintWidth * inpaintHeight
    v = zeros(br,1);
    for j = 1:br
        v(j) = norm(Psi_k(:,j)-psi_H(i,:)');
    end
    [~, indices] = sort(v, 'ascend');
    M(i,:)=indices(1:k);
end

for i = startY:startY+inpaintHeight-1
    for j = startX:startX+inpaintWidth-1
        %I(i,j,:) punimo sa RGB vrijednostima od k- najblizih susjeda iz
        %referentnog podrucja
        pom_m=zeros(k,3);
        ind = (i-startY)*inpaintWidth + j-startX +1;
        %indices1 = M(ind,:);
        for l = 1:k
            [x_i, x_j]=return_indices(M(ind,l),imageWidth);
            pom_m(l,:)=I(x_i,x_j,:);
        end
        I(i,j,:) = mean(pom_m,1);
    end
end
imshow(I);
title(['spiralno, \sigma = ' num2str(sigma)]);
filename = ['forest_inpaint_spiral' num2str(sigma) '.png'];
saveas(gcf, filename);

clear M;
clear psi_H;

