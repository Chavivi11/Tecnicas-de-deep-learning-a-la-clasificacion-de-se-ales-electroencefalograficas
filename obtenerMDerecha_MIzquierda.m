function [manoDerecha,manoIzquierda] = obtenerMDerecha_MIzquierda(sesion)

[~, numCols] = size(sesion);

n = 1;
r = 1;
l = 1;

while n <= numCols
    if(sesion(end,n) == 1)
        manoIzquierda(:,r) = sesion(:,n);
        r = r + 1;
    else
        manoDerecha(:,l) = sesion(:,n);
        l = l + 1;
    end
    n = n + 1;
end
end
