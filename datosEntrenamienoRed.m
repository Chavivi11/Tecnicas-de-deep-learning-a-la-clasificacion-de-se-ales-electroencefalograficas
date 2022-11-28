function [datosEntrenamiento] = datosEntrenamienoRed(manoDerecha,manoIzquierda, pies)

% deDosEnDos = [manoDerecha(:,1:2:25) manoIzquierda(:,1:2:25) pies(:,1:2:20)];
% deTresEnTres = [manoDerecha(:,1:3:25) manoIzquierda(:,1:3:25) pies(:,1:3:20)];
% deCincoEnCinco = [manoDerecha(:,1:5:25) manoIzquierda(:,1:5:25) pies(:,1:5:20)];
% variosDatos = [manoDerecha(:,1:25) manoIzquierda(:,1:25) pies(:,1:20)];

% deDosEnDos = [manoDerecha(:,1:2:end) manoIzquierda(:,1:2:end) pies(:,1:2:end)];
% deTresEnTres = [manoDerecha(:,1:3:end) manoIzquierda(:,1:3:end) pies(:,1:3:end)];
% deCuatroEnCuatro = [manoDerecha(:,1:4:end) manoIzquierda(:,1:4:end)];
% deCincoEnCinco = [manoDerecha(:,1:5:end) manoIzquierda(:,1:5:end) pies(:,1:5:end)];
% variosDatos = [manoDerecha(:,:) manoIzquierda(:,:) ];

% deDosEnDos = [manoDerecha(:,1:2:20) manoIzquierda(:,1:2:20) pies(:,1:2:20)];
% deTresEnTres = [manoDerecha(:,1:3:20) manoIzquierda(:,1:3:20) pies(:,1:3:20)];
% deCuatroEnCuatro = [manoDerecha(:,1:4:20) manoIzquierda(:,1:4:20) pies(:,1:4:20)];
% deCincoEnCinco = [manoDerecha(:,1:5:20) manoIzquierda(:,1:5:20) pies(:,1:5:20)];
% variosDatos = [manoDerecha(:,1:20) manoIzquierda(:,1:20) pies(:,1:20)];

manoderecha = [manoDerecha(:,1:2:20) manoDerecha(:,1:3:20) manoDerecha(:,1:4:20) manoDerecha(:,1:5:25) manoDerecha(:,1:25)];
manoizquierda = [manoIzquierda(:,1:2:20) manoIzquierda(:,1:3:20) manoIzquierda(:,1:4:20) manoIzquierda(:,1:5:25) manoIzquierda(:,1:25)];
pieses = [pies(:,1:2:20) pies(:,1:3:20) pies(:,1:4:20) pies(:,1:5:25) pies(:,1:25)];

% manoderecha = [manoDerecha(:,1:2:end) manoDerecha(:,1:3:end) manoDerecha(:,1:4:end) manoDerecha(:,:)];
% manoizquierda = [manoIzquierda(:,1:2:end) manoIzquierda(:,1:3:end) manoIzquierda(:,1:4:end) manoIzquierda(:,1:5:end) manoIzquierda(:,:)];
% % piess = [pies(:,:)];
% 
datosEntrenamiento = [manoderecha manoizquierda pieses];

% datosEntrenamiento = [deDosEnDos deTresEnTres deCuatroEnCuatro deCincoEnCinco variosDatos];

end

