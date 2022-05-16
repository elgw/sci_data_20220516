close all
clear all

cells = {'NES', 'NPC', 'NEU'};
channels = {'a647', 'a488'};

%% Generate with measure_all.m
%tsvfile = 'nuclei_statistics_raw.tsv'; % non-deconolved, varied number of slices
tsvfile = 'nuclei_statistics_raw_48slice.tsv'; % non-deconolved, varied number 48 slices
D = tdfread(tsvfile, '\t');
outfolder = [tsvfile, '_plots/'];
if ~isdir(outfolder)
    mkdir(outfolder)
end

T = struct2table(D);
T.Properties.VariableNames

nchan = -1*ones(size(T,1),1);
ncelltype = -1*ones(size(T,1),1);
for kk = 1:size(T,1)    
    ct = T.celltype(kk,:);
        if strcmp(ct, 'NES')
            ncelltype(kk) = 1;
        end
        if strcmp(ct, 'NPC')
            ncelltype(kk) = 2;
        end
        if strcmp(ct, 'NEU')        
            ncelltype(kk) = 3;
        end            
end


figure
for kk = 1:3
    subplot(1,3,kk)
    use = ncelltype == kk;
    scatter(T.dapi_intensity(use), T.a647_intensity(use))
    xlabel('DAPI');
    ylabel('A647')
    title(cells{kk})
end

figure
boxplot(T.a647_intensity, ncelltype)
set(gca, 'XTickLabel', cells)
xlabel('intensity')
title('A647 per nuclei')
dprintpdf([outfolder 'a647_per_nuclei'], 'driver', {'-dpng', '-dpdf'});

figure
boxplot(T.a488_intensity, ncelltype)
set(gca, 'XTickLabel', cells)
xlabel('intensity')
title('A488 per nuclei')
dprintpdf([outfolder 'a488_per_nuclei'], 'driver', {'-dpng', '-dpdf'});





%% Normalized per dapi
figure
boxplot(T.a647_intensity./T.dapi_intensity, ncelltype)
set(gca, 'XTickLabel', cells)
xlabel('intensity/intensity [-]')
title('A647/DAPI per nuclei')
dprintpdf([outfolder 'a647_dapi_per_nuclei'], 'driver', {'-dpng', '-dpdf'});

figure
boxplot(T.a488_intensity./T.dapi_intensity, ncelltype)
set(gca, 'XTickLabel', cells)
xlabel('intensity/intensity [-]')
title('A488/DAPI per nuclei')
dprintpdf([outfolder 'a488_dapi_per_nuclei'], 'driver', {'-dpng', '-dpdf'});

fprintf('Two-sided tests using ttest2 for a488/dapi\n');
value = T.a488_intensity./T.dapi_intensity;
for aa = 1:3
    for bb = aa+1:3        
        [H, p] = ttest2(value(ncelltype == aa), value(ncelltype == bb));
        fprintf('%s vs %s: H: %d, p: %e\n', cells{aa}, cells{bb}, H, p);
    end
end
