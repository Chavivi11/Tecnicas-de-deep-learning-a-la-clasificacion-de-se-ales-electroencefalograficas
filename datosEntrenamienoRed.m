function [datosEntrenamiento] = datosEntrenamienoRed(manoDerecha,manoIzquierda, pies)

deDosEnDos = [manoDerecha(:,1:2:25) manoIzquierda(:,1:2:25) pies(:,1:2:20)];
deTresEnTres = [manoDerecha(:,1:3:25) manoIzquierda(:,1:3:25) pies(:,1:3:20)];
deCincoEnCinco = [manoDerecha(:,1:5:25) manoIzquierda(:,1:5:25) pies(:,1:5:20)];
variosDatos = [manoDerecha(:,1:25) manoIzquierda(:,1:25) pies(:,1:20)];

datosEntrenamiento = [deDosEnDos deTresEnTres deCincoEnCinco variosDatos];

end

