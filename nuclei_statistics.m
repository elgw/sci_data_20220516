function nuclei_statistic()
%% Nuclei Intensity Statistics

data_definition
channels = {'a647', 'a488'};

if 0
slices = 10000;
for ff = 1:numel(dapifiles)
    I = df_readTif(dapifiles{ff});
    slices = min(slices, size(I,3))
end
end
% at lest 48 slices per image

% Get nuclei size for each nuclei
outfile = 'nuclei_statistics_raw_48slice.tsv';
fprintf('Will write to %s\n', outfile);
table = fopen(outfile, 'w');
fprintf(table, 'file\tnuc_num\tcelltype\tarea\tdapi_intensity\ta647_intensity\ta488_intensity\n');

for ff = 1:numel(dapifiles)
    fprintf('File %d / %d\n', ff, numel(dapifiles))
    file = dapifiles{ff};
    [path, name, ext] = fileparts(file);
    
    I = df_readTif(strrep(file, 'dw_dapi', 'dapi'));
    % Find focus and determine which 48 slices to use
    
    f = df_image_focus('image', I);
    nslice = 48;
    best_region = [1,nslice];
    best_focus = sum(f(best_region(1):best_region(2)));
    for zz = 1:size(I, 3)-nslice
        if sum(f(zz:zz+48)) > best_focus
            best_region = [zz, zz+nslice-1];
        end
    end
    
    SP_dapi = get_SP(strrep(file, 'dw_dapi', 'dapi'), best_region);
    SP_a647 = get_SP(strrep(file, 'dw_dapi', 'a647'), best_region);      
    SP_a488 = get_SP(strrep(file, 'dw_dapi', 'a488'), best_region);    
    
    %mpfile = [path filesep() 'max_' name ext];
    segfile = [path filesep() 'mask_' name ext];
    %prefile = [path filesep() 'preview_' name '.png'];
    
    S = df_readTif(segfile);
    [M, n] = bwlabeln(S);
    celltype = get_cell_from_name(file);
    for nn = 1:n  % For each nuclei        
        area = sum(sum(M == nn));
        dapi_intensity = sum(sum(SP_dapi(M==nn)));
        a647_intensity = sum(sum(SP_a647(M==nn)));
        a488_intensity = sum(sum(SP_a488(M==nn)));
        assert(dapi_intensity > 0);
        assert(a647_intensity > 0);
        assert(a488_intensity > 0);
        
        fprintf(table, '%s\t%d\t%s\t%d\t%f\t%f\t%f\n', ...
            file, nn, celltype, area, dapi_intensity, a647_intensity, a488_intensity);
        
    end        
end

fclose(table);
end

function SP = get_SP(file, z)
    [I, s] = df_readTif(file);
    I = double(I);
    SP = sum(I(:,:,z(1):z(end)), 3);
    if s > 0
        SP = double(SP)/s;
    else 
        fprintf('Missing scaling value for %s\n', file);
    end
    end