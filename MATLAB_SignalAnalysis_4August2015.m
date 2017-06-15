%% Laura NET analysis

%-------------------------------------------------------------------------

% This code is designed to analyize the relative imaged areas of slidebook
% images that specificlly look at CY3, FITC, and DAPI flouresence images.
% This code is broken down into 4 sections: 

% Section 1 defines the direcory location of the exported slidebook tiffs

% Section 2 looks at a specific image, and produces a greyscale and a jet
% (intensity) scale image of each of the three signals being analyzed
% (CY3, FITC, and DAPI). It also produces a thresholded image (in both
% greyscale and jet) and presents a calculation for both the area of the
% signal and as a percentage of the total image area. Lastly, it produces a
% figure containing images of how each signal overlaps one another and a
% calcuation of the area of the total overlaping signal. The Thresholding
% valeuse can be adjusted manually for optimum analysis.

% Section 3 takes the previously defined threshold values form section 2
% and applies them to each image in the directory, compiling them into a
% single array containing the name of each image, the area of each of the
% three signals, the percentage of total area of each of the three signal,
% and the total area of the overlaped signals.

% Section 4 allows the user to choose a save name for this data and store
% the data as an excell file in the location of thier chioce. 

%-------------------------------------------------------------------------

%% Section 1. CD to directory of interest

% Change the directory to the directory contianing the images of interest

cd('X:\SOM\BME\Projects\omccarty_lab\Laura\2015\July2015\15July2015-NETs colocalization\tiffs\overlay') % <<---- change as needed


%% Section 2. Analyze all channels of interest, determine threshold
% read in the image
FileName=('PMN_FXIIa+PMA+PPACK_03.tif'); %<------------ Change as needed
I = imread(FileName); 
[path,name,ext] = fileparts(FileName);

% nx = x dimensions; ny = y dimensions; nz = z dimensions = number of signals
[nx,ny,nz] = size(I);


% Defines the first figure contianing the greyscale images
fig1=figure(201);
set(fig1,'Name',sprintf('Threshold Comparisons for %s ', FileName),'NumberTitle','off') 
clf
for iz = 1:nz
    
    % the current channel
    currImage = reshape(I(:,:,iz),nx, ny);
    
    % channel-specific thresholds (can adjust the values as needed in order
    % to limit nonspecific signal in the area calculation, have to be the
    % same for each image being evaluated)
    
    % (the following vales have been preset to the values initially 
    % identified in the prior verison of the code produced by Kevin)
    
    CY3thold=1;    %<----------------------(for the CY3 signal)
    FITCthold=10;  %<----------------------(for the FITC signal)
    DAPIthold=35;  %<----------------------(for the DAPI signal)
    
    % Once these values are acceptable (meaning they produce good images
    % without much extra or non-specific binding being shown) then you can
    % proceed to the next section to calulate the area values for all of
    % the images in the current directory. 
    
    % Thresholds each signal according to defined values
    if iz == 1;
        tholdImage = (currImage>CY3thold);
    else if iz == 2
            tholdImage = (currImage>FITCthold);
        else
            tholdImage = (currImage>DAPIthold);
        end
        
        colormap gray
    end
    
    % plots the greyscale images before and after threshold
    subplot(2,3,iz)
    imagesc(currImage)
    
    if iz == 1;
        title('CY3')
    else if iz == 2
            title('FITC')
        else
            title('DAPI')
        end
    end
    axis equal image
    
    subplot(2,3,iz+3)
    imagesc(tholdImage)
    
    axis equal image
    
        colormap(gray)
    
end

% Defines the second figure containing jet images and caclulated values for
% area and percent total area for each signal for the given image
fig2=figure(202);
set(fig2,'Name',sprintf('Intensity Images and Area and Percent Calculations for %s ', FileName),'NumberTitle','off') 
clf

for channel_no = 1:nz;
    
    % get the current channel
    currImage = reshape(I(:,:,channel_no),nx, ny);
    
    if channel_no == 1;
        thold_value = CY3thold;
    else if channel_no == 2;
            thold_value = FITCthold;
        else 
            thold_value = DAPIthold;
        end
    end
    
    % t-hold current channel
    thold = (currImage>thold_value);
    


% Plots unaltered jet coloerd image for each signal
subplot(3,3,channel_no)
imagesc(currImage)
if channel_no == 1;
        title('CY3')
    else if channel_no == 2
            title('FITC')
        else
            title('DAPI')
        end
end
axis equal image 

% Plots the threshold image and displayes the calculated area based on
% where pixel intensity > t-hold value
subplot(3,3,channel_no+3)
imagesc(thold)
signal_area = sum(thold(:)).*(.1^2);
title(sprintf('signal area = %f  [microns^2] ', signal_area))
axis equal image 
colormap(jet)

% Plots the threshold image and displayed the calculated percent of total
% area based on the previously calculated signal area and a total image
% size of 12506.56 microns^2
signal_area_percent = (signal_area/12506.56)*100;
subplot(3,3,channel_no+6)
imagesc(thold)
title(sprintf('Percentage of Image Area = %f [%%]', signal_area_percent))
axis equal image

end

% Defines figure 3 which will show the area of overlap between the signals
% for the specified image
fig3=figure(203);
set(fig3,'Name',sprintf('Overlaping Signal Images and Area Calculations for %s ', FileName),'NumberTitle','off') 
clf

for iz=1:nz;
     currImageA = reshape(I(:,:,1), nx, ny);
     currImageB = reshape(I(:,:,2), nx, ny);
     currImageC = reshape(I(:,:,3), nx, ny);
     if iz == 1
        tholdImageA = (currImageA>CY3thold);
        tholdImageB = (currImageB>FITCthold);
    else if iz == 2
            tholdImageA = (currImageB>FITCthold);
            tholdImageB = (currImageC>DAPIthold);
        else
            tholdImageA = (currImageC>DAPIthold);
            tholdImageB = (currImageA>CY3thold);
        end
     end
     
     overlap_image = tholdImageA & tholdImageB;
     signal_area = sum(overlap_image(:)).*(.1^2);
     
     subplot(1,4,iz)
     imagesc(overlap_image)
     if iz == 1;
        title(sprintf('CY3 and FITC, Area = %f [microns]', signal_area))
     else if iz == 2
            title(sprintf('FITC and DAPI, Area = %f [microns]', signal_area))
        else
            title(sprintf('DAPI and CY3, Area = %f [microns]', signal_area))
        end
     end
     axis equal image
     colormap (gray)
  
     tholdA = (currImageA>CY3thold);
     tholdB = (currImageB>FITCthold);
     tholdC = (currImageC>DAPIthold);
     overlap_all = tholdA & tholdB & tholdC;
     signal_area_all = sum(overlap_all(:)).*(.1^2);
     subplot(1,4,4)
     imagesc(overlap_all)
     axis equal image
     title(sprintf('Overlap All, Area = %f [microns]', signal_area_all))
    
end

%% Section 3. Determine area of all the signals

% Determines the area of CY3, FITC, and DAPI in a single cell array titled
% Cellular_area_data. The threshold values are based on the user defined
% values specified in the previous seciton of code. Due to the number of
% calculations, this can often take a few minuites to finish.

% Stops the program from running if an error occurs
dbstop if error

tiffList = dir('*.tif');
[nfield knot] = size(tiffList);

Cellular_area_data = cell(nfield+2,4);
Cellular_area_data(1,1)= {'Image/Treatment Name'};
Cellular_area_data(2,1)={' '};
Cellular_area_data(1,2)= {'CY3 Signal'};
Cellular_area_data(2,2)= {'Area (microns^2)'};
Cellular_area_data(1,3)= {'CY3 Signal'};
Cellular_area_data(2,3)= {'Percentage of Image Area (%)'};

% Calculates area and percentage of total image area for the CY3 and
% populates the table with these values
for ifield = 1:nfield
    % load image
    I = imread(tiffList(ifield).name); 
    % choose channel
    currImage = reshape(I(:,:,1),nx, ny);
    % threshold
     thold = (currImage>CY3thold);
    % sum
    signal_area = sum(thold(:)).*(.1^2);
    signal_area_percent = (signal_area/12506.56)*100;
    a=tiffList(ifield).name;
    Cellular_area_data(ifield+2,1) = {a};
    Cellular_area_data(ifield+2,2)= {signal_area};
    Cellular_area_data(ifield+2,3)= {signal_area_percent};
end

Cellular_area_data(1,4)= {'FITC Signal'};
Cellular_area_data(2,4)= {'Area (microns^2)'};
Cellular_area_data(1,5)= {'FITC Signal'};
Cellular_area_data(2,5)= {'Percentage of Image Area (%)'};

% Calculates area and percentage of total image area for the FITC and
% populates the table with these values
for ifield = 1:nfield
    % load image
    I = imread(tiffList(ifield).name); 
    % choose channel
    currImage = reshape(I(:,:,2),nx, ny);
    % threshold
     thold = (currImage>FITCthold);
    % sum
    signal_area = sum(thold(:)).*(.1^2);
    signal_area_percent = (signal_area/12506.56)*100;
    Cellular_area_data(ifield+2,4)= {signal_area}; 
    Cellular_area_data(ifield+2,5)= {signal_area_percent};
    
end

Cellular_area_data(1,6)= {'DAPI Signal'};
Cellular_area_data(2,6)= {'Area (microns^2)'};
Cellular_area_data(1,7)= {'DAPI Signal'};
Cellular_area_data(2,7)= {'Percentage of Image Area (%)'};

% Calculates area and percentage of total image area for the DAPI and
% populates the table with these values
for ifield = 1:nfield
    %load image
    I = imread(tiffList(ifield).name);
    %choose channel
    currImage = reshape(I(:,:,3),nx,ny);
    %threshold
    thold = (currImage>DAPIthold);
    %sum
    signal_area = sum(thold(:)).*(.1^2);
    signal_area_percent = (signal_area/12506.56)*100;
    Cellular_area_data(ifield+2,6)={signal_area};
    Cellular_area_data(ifield+2,7)= {signal_area_percent};
end

Cellular_area_data(1,8)= {'CY3 and FITC Overlap'};
Cellular_area_data(2,8)= {'Area (microns^2)'};
Cellular_area_data(1,9)= {'FITC and DAPI Overlap'};
Cellular_area_data(2,9)= {'Area (microns^2)'};
Cellular_area_data(1,10)= {'DAPI and CY3 Overlap'};
Cellular_area_data(2,10)= {'Area (microns^2)'};
Cellular_area_data(1,11)= {'All Signals Overlap'};
Cellular_area_data(2,11)= {'Area (microns^2)'};

% Calculates the area of the overlap between signals for the four different
% overlap possibilites 
for ifield = 1:nfield
    % load image
    I = imread(tiffList(ifield).name); 
    % choose channel
    currImageA = reshape(I(:,:,1),nx, ny);
    currImageB = reshape(I(:,:,2),nx, ny);
    currImageC = reshape(I(:,:,3),nx, ny);
    % threshold
    tholdA = (currImageA>CY3thold);
    tholdB = (currImageB>FITCthold);
    tholdC = (currImageC>DAPIthold);
    % perform overlap of images
    overlapAB = tholdA & tholdB;
    overlapBC = tholdB & tholdC;
    overlapCA = tholdC & tholdA;
    overlapALL = tholdA & tholdB &tholdC;
    % sum
    signal_areaAB = sum(overlapAB(:)).*(.1^2);
    signal_areaBC = sum(overlapBC(:)).*(.1^2);
    signal_areaCA = sum(overlapCA(:)).*(.1^2);
    signal_areaALL = sum(overlapALL(:)).*(.1^2);
    Cellular_area_data(ifield+2,8)= {signal_areaAB}; 
    Cellular_area_data(ifield+2,9)= {signal_areaBC}; 
    Cellular_area_data(ifield+2,10)= {signal_areaCA}; 
    Cellular_area_data(ifield+2,11)= {signal_areaALL}; 
    
end

%% Section 4: Write data to an Excel file

% Will pull up a window promting you to choose the name and location of the
% excel file with the exported and tabulated data

[FileNameBodeWrite, PathNameBodeWrite] = uiputfile({'*.xls';'*.csv'},'Save As...',['rename file' '.xls']);
    if FileNameBodeWrite ~=0
        if exist([PathNameBodeWrite FileNameBodeWrite],'file')
            delete([PathNameLachWrite FileNameBodeWrite ]);
        end
        xlswrite([PathNameBodeWrite FileNameBodeWrite ],Cellular_area_data)  %saves data in excell format           
    end


