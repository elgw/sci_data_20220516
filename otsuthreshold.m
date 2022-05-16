function th = otsuthreshold(A)
% function th = otsuthreshold(A)
% Find the optimal threshold according to otsu on the data in A

A = A(:);
v = A;
v = v-min(v(:));
v = v/max(v(:));
h = imhist(v, 2^16);
th = otsuthresh(h);
v = A;
th = min(v) + th*(max(v(:))-min(v(:)));
end