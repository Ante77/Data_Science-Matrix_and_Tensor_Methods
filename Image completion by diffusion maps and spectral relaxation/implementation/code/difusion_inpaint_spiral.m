function psi_H = difusion_inpaint_spiral(Psi_k,imageWidth, imageHeight, inpaintWidth, inpaintHeight, numEigenvectors)

    startX = round((imageWidth - inpaintWidth) / 2);
    startY = round((imageHeight - inpaintHeight) / 2);

    psi_H = zeros(inpaintWidth * inpaintHeight, numEigenvectors);   

    %odredivat cemo embedded koor. nepoznatog podrucja H spiralno, krenuvsi
    %od gornjeg ruba,pa desnog, pa donjeg, pa lijevog
    %s time da prvo popunjavamo ćoškove
    
    
    layer = 0;%moja logika: ide od 0 do ceil(min(inpaintWidth,inpaintHeight)/2)
    i=startY + layer; j=startX + layer;
    i_H=1;j_H=1;
    
    for layer = 0: ceil(min(inpaintWidth,inpaintHeight)/2)
        
         i=startY + layer; j=startX + layer;
         i_H=1+layer;j_H=1+layer;
        
        %gornji lijevi ćošak : (startY + layer, startX +layer)
        iter = (i_H-1)*inpaintWidth+j_H;

        if(layer==0)
            
            indices = [(i -1)*imageWidth+j-1; %slijeva
                       (i -2)*imageWidth+j-1; %slijeva i gore (i-1,j-1)
                       (i -2)*imageWidth+j]; %gornji
            matr = Psi_k(:,indices);
            
        else
             matr1 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
             matr2 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela iznad lijevo
             matr3 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
             matr=[matr1 matr2 matr3];
        end
        psi_H(iter,:)= mean(matr, 2)';
        j=j+1;
        j_H=j_H+1;

 
        
        for h=1:inpaintWidth-2*(layer+1) %broj "unutarnjih" piksela od H cije koor. treba odrediti
            iter = (i_H-1)*inpaintWidth+j_H;
            %gledamo ona tri iznad i lijevi, drukcije je kada je layer=0
            if(layer==0)
                 indices = [(i-2)*imageWidth+j+1; % gore desno
                            (i -2)*imageWidth+j-1; %slijeva i gore (i-1,j-1)
                            (i -2)*imageWidth+j]; %gornji
                  matr1 = Psi_k(:,indices);
                  matr = [matr1 psi_H(iter-1,:)'];
                  
            else
                matr1 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                matr2 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela iznad lijevo
                matr3 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
                matr=[matr1 matr2 matr3];
            end
            psi_H(iter,:)= mean(matr, 2)';
            j = j+1;%j je sada na indeksu stupca desnog ćoška
            j_H=j_H+1;
           
        end
%         if(layer==0)
%             disp(j_H)%10
%         end

         %gornji desni ćošak : (startY + inpaintHeight-1+layer, startX + inpaintWidth-1-layer)
         %drukcije za layer=0
         iter = (i_H-1)*inpaintWidth+j_H;
         if(layer==0)
              indices = [(i -1)*imageWidth+j+1-inpaintWidth; %zdesna
                         (i -2)*imageWidth+j+1; %zdesna i gore (i-1,j+1)
                         (i -2)*imageWidth+j]; %gornji
             matr = Psi_k(:,indices);
         else

             matr1 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
             matr2 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
             matr3 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela desno
             matr=[matr1 matr2 matr3];

         end

        psi_H(iter,:)= mean(matr, 2)';
        
        %desni rub, gornji ćošak već riješen
        %gledamo onog iznad, iznad desno i desno
        i = i+1;
        i_H=i_H+1;
%         if(layer==0)
%             disp(i_H)%2
%         end
         for h=1:inpaintHeight-2*(layer+1) %broj piksela od H cije koor. treba odrediti, svi osim gornjeg i donjeg ćoška
            iter = (i_H-1)*inpaintWidth+j_H;
            %gledamo ona tri desno i gornji, drukcije je kada je layer=0
            if(layer==0)
                 indices = [(i-2)*imageWidth+j+1-(i_H-1)*inpaintWidth; % desno gore
                            (i-1)*imageWidth+j+1-(i_H)*inpaintWidth ; %zdesna 
                            (i)*imageWidth+j+1-(i_H+1)*inpaintWidth]; %desno dolje
                  matr1 = Psi_k(:,indices);
                  matr = [matr1 psi_H(iter-1,:)'];
                  
            else
                matr1 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
                matr2 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
                matr3 = psi_H(iter+1,:)';%embedded koor. piksela desno
                matr4 = psi_H(iter+inpaintWidth+1,:)';%embedded koor. piksela desno dolje
                matr=[matr1 matr2 matr3 matr4];
            end
            psi_H(iter,:)= mean(matr, 2)';
            i = i+1;%spuštamo se dolje
            i_H=i_H+1;
           
         end
%          if (layer==0)
%              disp(i_H)%30
%          end
        %za layer=0, i bi trebao biti  35+30-1=64
        %donji desni ćošak
        
         %drukcije za layer=0
         iter = (i_H-1)*inpaintWidth+j_H;
         if(layer==0)
              indices = [(i -1)*imageWidth+j+1-(i_H*inpaintWidth); %zdesna, i_H bi trebao biti 30!
                         (i)*imageWidth+j+1-(i_H*inpaintWidth); %zdesna i dolje
                         (i)*imageWidth+j-(i_H*inpaintWidth)]; %dolje
             matr = Psi_k(:,indices);
         else

             matr1 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela iznad
             matr2 = psi_H(iter-inpaintWidth+1,:)';%embedded koor. piksela iznad desno
             matr3 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela desno
             matr4 = psi_H(iter+inpaintWidth+1,:)';%embedded koor. piksela dolje desno
             matr5 = psi_H(iter-inpaintWidth,:)';%embedded koor. piksela dolje
           
             matr=[matr1 matr2 matr3 matr4 matr5];

         end

        psi_H(iter,:)= mean(matr, 2)';
        j=j-1;
        j_H=j_H-1;
        
%         if(layer==0)
%             disp(j_H)%9
%         end
        %donji rub
        %i,tj. i_H bi trebao biti dobar, desni ćošak već imamo
        
        for h=1:inpaintWidth-2*(layer+1) %broj "unutarnjih" piksela od H cije koor. treba odrediti
            iter = (i_H-1)*inpaintWidth+j_H;
            %gledamo ona tri ispod i desni, drukcije je kada je layer=0
            if(layer==0)
                 indices = [(i)*imageWidth+j-1-(i_H*inpaintWidth); % dolje lijevo
                            (i)*imageWidth+j-(i_H*inpaintWidth); % dolje 
                            (i)*imageWidth+j+1-(i_H*inpaintWidth)]; %dolje desno
                  matr1 = Psi_k(:,indices);
                  matr = [matr1 psi_H(iter-1,:)'];
                  
            else
                matr1 = psi_H(iter+inpaintWidth,:)';%embedded koor. piksela ispod
                matr2 = psi_H(iter+inpaintWidth-1,:)';%embedded koor. piksela ispod lijevo
                matr3 = psi_H(iter+inpaintWidth+1,:)';%embedded koor. piksela ispod desno
                matr4 = psi_H(iter+1,:)';%embedded koor. piksela desno
                matr=[matr1 matr2 matr3 matr4];
            end
            psi_H(iter,:)= mean(matr, 2)';
            j = j-1;%j je sada na indeksu stupca desnog ćoška
            j_H=j_H-1;
           
        end
%         if(layer==0)
%             disp(i_H)%30
%             disp(j)%45
%             disp(j_H)%1
%         end
        
        %donji lijevi ćošak , j je 45, a j 1, za layer=0, a
        %i_H=30
         %drukcije za layer=0
         iter = (i_H-1)*inpaintWidth+j_H;
         if(layer==0)
              indices = [(i-1)*imageWidth+j-1-(i_H-1)*inpaintWidth; %slijeva
                         (i)*imageWidth+j-1-i_H*inpaintWidth; %slijeva i dolje
                         (i)*imageWidth+j-i_H*inpaintWidth]; %dolje
             matr1 = Psi_k(:,indices);
             matr=[matr1 psi_H(iter+1,:)'];
         else

             matr1 = psi_H(iter+inpaintWidth,:)';%embedded koor. piksela ispod
             matr2 = psi_H(iter+inpaintWidth+1,:)';%embedded koor. piksela ispod desno
             matr3 = psi_H(iter+inpaintWidth-1,:)';%embedded koor. piksela ispod lijevo
             matr4 = psi_H(iter-1,:)';%embedded koor. piksela  lijevo
             matr5 = psi_H(iter+1,:)';%embedded koor. piksela  desno
             
             matr=[matr1 matr2 matr3 matr4 matr5];

         end

        psi_H(iter,:)= mean(matr, 2)';
        i=i-1;
        i_H=i_H-1;
        
        %lijevi rub, gornji ćošak već riješen
        %gledamo onog ispod, ispod lijevo i lijevo
      
         for h=1:inpaintHeight-2*(layer+1) %broj piksela od H cije koor. treba odrediti, svi osim gornjeg i donjeg ćoška
            iter = (i_H-1)*inpaintWidth+j_H;
            %gledamo ona tri lijevo i donji, drukcije je kada je layer=0
            if(layer==0)
                 indices = [(i)*imageWidth+j-1-(i_H)*inpaintWidth; % lijevo dolje
                            (i-1)*imageWidth+j-1-(i_H-1)*inpaintWidth ; %lijevo 
                            (i-2)*imageWidth+j-1-(i_H-2)*inpaintWidth]; %lijevo gore
                  matr1 = Psi_k(:,indices);
                  matr = [matr1 psi_H(iter+inpaintWidth,:)'];
                  
            else
                matr1 = psi_H(iter+inpaintWidth,:)';%embedded koor. piksela ispod
                matr2 = psi_H(iter+inpaintWidth-1,:)';%embedded koor. piksela ispod lijevo
                matr3 = psi_H(iter-1,:)';%embedded koor. piksela lijevo
                matr4 = psi_H(iter-inpaintWidth-1,:)';%embedded koor. piksela lijevo gore
                matr=[matr1 matr2 matr3 matr4];
            end
            psi_H(iter,:)= mean(matr, 2)';
            i = i-1;%spuštamo se dolje
            i_H=i_H-1;
           
         end
         %lijevi gornji ćošak već riješen
%          if(layer==0)
%              disp(i)
%              disp(i_H)
%          end
  
            
   end
        
         
end
