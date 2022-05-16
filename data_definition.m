folder = '/srv/secondary/ki/hd/20220325_Roberto_262_263_264/';
clear dir
dirs = dir([folder 'iiRB*']);
dapifiles = {};

for kk = 1:numel(dirs)
   files = dir([dirs(kk).folder filesep() dirs(kk).name filesep() 'dw_dapi_*.tiff']);
   for ff = 1:numel(files)
       dapifiles{end+1} = [files(ff).folder filesep files(ff).name];    
   end
end


