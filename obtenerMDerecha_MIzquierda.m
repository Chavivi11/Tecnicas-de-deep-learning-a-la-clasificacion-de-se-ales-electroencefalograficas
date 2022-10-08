function [manoDerecha,manoIzquierda] = obtenerMDerecha_MIzquierda(sesion)

[~, numCols] = size(sesion);

n = 1;
r = 1;
l = 1;

while n <= numCols
    if(sesion(end,n) == "T1")
        manoDerecha(:,r) = sesion(:,n);
        r = r + 1;
    else
        manoIzquierda(:,l) = sesion(:,n);
        l = l + 1;
    end
    n = n + 1;
end
end
