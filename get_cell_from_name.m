function celltype = get_cell_from_name(name)

celltype = 'unknown';

if contains(name, 'iiRB262')
    celltype = 'NES';
end
if contains(name, 'iiRB263')
    celltype = 'NPC';
end
if contains(name, 'iiRB264')
    celltype = 'NEU';
end


end