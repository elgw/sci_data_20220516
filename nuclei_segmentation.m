data_definition % make dapifiles availabe
close all

fprintf('Available files:\n');
for ff = 1:numel(dapifiles)
    fprintf('%d %s\n', ff, dapifiles{ff});
end

fprintf('Looking for unsegmented\n');
for ff = 1:numel(dapifiles)
    fprintf('File %d / %d\n', ff, numel(dapifiles))
    file = dapifiles{ff};
    segment_image(file, 0)
end

fprintf('Validation and adjustment\n');
for ff = 1:numel(dapifiles)
    file = dapifiles{ff};
    [path, name, ext] = fileparts(file);
    prefile = [path filesep() 'preview_' name '.png'];
    I = imread(prefile);
    close all
    imshow(I);
    adjust = questdlg('Adjust?', ...
                         'Adjust the segmentation mask?', ...
                         'Yes', 'No', 'Cancel', 'No');
    if strcmp(adjust, 'Cancel')
        return;
    end
    if strcmp(adjust, 'Yes')
        segment_image(file, 1);
    end
end
fprintf('All done!')

function genpreview(mpfile, segfile, prefile)
%keyboard

Im = df_readTif(mpfile);
Seg = df_readTif(segfile);

V = double(Im)/double(percentile16(Im, 0.95));
V(V>1) = 1;
[h,~,~] = rgb2hsv(1, 0, 1);
H = 0*V + h;
S = 0*V;
Seg = Seg > 0;
S = imdilate(Seg, strel('disk', 2)) - Seg;
S = gsmooth(S, 1);
S = 1.2*S/max(S(:));
S(S>1) = 1;
P = hsv2rgb(H, double(S), min(V+S, 1));
%figure, imshow(P)
imwrite(P, prefile);
end

function segment_image(file, force)
[path, name, ext] = fileparts(file);

mpfile = [path filesep() 'max_' name ext];
segfile = [path filesep() 'mask_' name ext];
prefile = [path filesep() 'preview_' name '.png'];

if ~isfile(mpfile)
    system(['dw maxproj ' file ' --overwrite'])
end

assert(isfile(mpfile))

if force
    I = df_readTif(mpfile);
    mask = df_readTif(segfile);
    mask = get_nuclei_manual(mask, I);
    df_writeTif(uint16(mask), segfile);
    genpreview(mpfile, segfile, prefile)
end

if ~isfile(segfile) 
    I = df_readTif(mpfile);
    [mask, man] = get_nuclei_dapi_ui(I);
    if man
        mask = get_nuclei_manual(mask, I);
    end
    df_writeTif(uint16(mask), segfile);
else
    mask = df_readTif(segfile);
end

if ~isfile(prefile)
    genpreview(mpfile, segfile, prefile)
end
if 0
    figure(1)
    hold off
    imagesc(I)
    axis image
    colormap gray
    title(file(end-30:end), 'interpreter', 'none')
    figure(1)
    hold on
    contour(mask > 0, 'g')
end
end