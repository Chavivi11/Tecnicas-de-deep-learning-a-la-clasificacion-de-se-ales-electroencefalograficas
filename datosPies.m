function [pies] = datosPies(sesion)
[~, numCols] = size(sesion);

n = 1;
r = 1;

while n <= numCols
    if(sesion(end,n) == 0)
        pies(:,r) = sesion(:,n);
        r = r + 1;
    end
    n = n + 1;
end
end

