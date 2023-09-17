function [inpaintMask, holeMask] = generate_masks(imagePath, inpaintWidth, inpaintHeight)
%inpaintMask- matrica koja je bijela na rupi, tj nepoznatom podrucju H, a
%svagdje drugdje je crna
%holeMask je upravo suprotna matrica

    % Read the RGB image
    image = imread(imagePath);

    % Get the image dimensions
    imageHeight = size(image, 1);
    imageWidth = size(image, 2);

    % Calculate the starting position for the inpainting region
    startX = round((imageWidth - inpaintWidth) / 2);
    startY = round((imageHeight - inpaintHeight) / 2);
    
    %u edge spremamo indekse koji su na rubu od H td. jedan redak- jedan
    %piksel
%     edge = zeros(2*inpaintWidth + 2*inpaintHeight, 2);
%     edge(1:inpaintHeight,1)= startX; %lijevi rub, x-koor
%     edge(1:inpaintHeight,2)=startY:startY+inpaintHeight-1 ; %lijevi rub, y-koor
%    
%     edge(inpaintHeight + 1: 2*inpaintHeight,1)= startX+inpaintWidth-1;%desni rub, x-koor
%     edge(inpaintHeight + 1: 2*inpaintHeight,2)= startY:startY+inpaintHeight-1;%desni rub, y-koor
%     
%     edge(2*inpaintHeight + 1: 2*inpaintHeight + inpaintWidth,1)= startX:startX+inpaintWidth-1;%donji rub, x-koor
%     edge(2*inpaintHeight + 1: 2*inpaintHeight + inpaintWidth,2)= startY; %donji rub, ya-koor
%     
%     edge(2*inpaintHeight + inpaintWidth + 1: 2*(inpaintHeight + inpaintWidth),1)= startX:startX+inpaintWidth-1;%gornji rub, x-koor
%     edge(2*inpaintHeight + inpaintWidth + 1: 2*(inpaintHeight + inpaintWidth),2)= startY+inpaintHeight-1;%gornji rub, y-koor
%     

    % Create a mask for the inpainting region
    inpaintMask = zeros(imageHeight, imageWidth);
    inpaintMask(startY:startY+inpaintHeight-1, startX:startX+inpaintWidth-1) = 1;

    % Create a hole mask (complement of the inpainting region)
    holeMask = 1 - inpaintMask;
end