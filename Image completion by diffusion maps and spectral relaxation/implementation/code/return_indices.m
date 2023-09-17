function [i,j]=return_indices(ind,imageWidth)
    if(ind <= 3400)
        i = ceil(ind/imageWidth);
        if(mod(ind,100)==0)
            j = 100;
        else
            j = mod(ind,100);
        end
    end
    if(ind > (3400 + 2700))
        ind_pom = ind+300;
        i = ceil(ind_pom/imageWidth);
        if(mod(ind_pom,100)==0)
            j = 100;
        else
            j = mod(ind_pom,100);
        end
    end
    if(ind > 3400 && ind<=( 3400 + 2700))
        ind_pom=ind-3400;
        i = ceil(ind_pom/90);
        if(mod(ind_pom,90)> 0 && mod(ind_pom,90)<=44)
            j = mod(ind_pom,90);
        end
        if(mod(ind_pom,90)==0)
            j = 100;
        end
        if(mod(ind_pom,90)> 44)
            j = mod(ind_pom,90) + 10;
        end
        
    end
     
end