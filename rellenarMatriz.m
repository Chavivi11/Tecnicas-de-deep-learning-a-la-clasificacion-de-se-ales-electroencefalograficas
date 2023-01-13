function [canal] = rellenarMatriz(data, tarea, t, etiqueta, segundosValidos)

% Funcion para rellenar matrices con los datos de las sesiones

n = 1;
cont = 1;
contadorSegundosValidos = 1;
canal = zeros(length(data{1,1})*4,t);

while n <= t
    k = 1;
    if(tarea(cont) == etiqueta)
        for i=0:3
            for j=1:length(data{1,1})
                canal(k,n) = data{segundosValidos(contadorSegundosValidos)+i,1}(j);
                k = k + 1;
            end
        end
        n = n + 1;
        contadorSegundosValidos = contadorSegundosValidos+1;
    end
    cont = cont + 1;
end
end

