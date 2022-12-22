function [datosEntrenamiento] = datosEntrenamienoRed(manoDerecha, manoIzquierda, pies)

deDosEnDos = [manoDerecha(:,1:2:28) manoIzquierda(:,1:2:28) pies(:,1:2:26)];
deTresEnTres = [manoDerecha(:,1:3:27) manoIzquierda(:,1:3:27) pies(:,1:3:24)];
deCuatroEnCuatro = [manoDerecha(:,1:4:28) manoIzquierda(:,1:4:28) pies(:,1:4:24)];
deCincoEnCinco = [manoDerecha(:,1:5:25) manoIzquierda(:,1:5:25) pies(:,1:5:25)];
variosDatos = [manoDerecha(:,1:28) manoIzquierda(:,1:28) pies(:,1:25)];

datosEntrenamiento = [deDosEnDos deTresEnTres deCuatroEnCuatro deCincoEnCinco variosDatos];

% manoderecha = [manoDerecha(:,1:2:28) manoDerecha(:,1:3:27) manoDerecha(:,1:4:28) manoDerecha(:,1:5:25) manoDerecha(:,1:28)];
% manoizquierda = [manoIzquierda(:,1:2:28) manoIzquierda(:,1:3:27) manoIzquierda(:,1:4:28) manoIzquierda(:,1:5:25) manoIzquierda(:,1:28)];
% pieses = [pies(:,1:2:24) pies(:,1:3:21) pies(:,1:4:24) pies(:,1:5:25) pies(:,1:25)];
% 
% datosEntrenamiento = [manoderecha manoizquierda pieses];

end

