function [datosEntrenamiento] = datosEntrenamienoRed(manoDerecha,manoIzquierda, pies)

derecha = [manoDerecha(:,1:2:20) manoDerecha(:,1:5:20) manoDerecha(:,1:20)];
izquierda = [manoIzquierda(:,1:2:20) manoIzquierda(:,1:5:20) manoIzquierda(:,1:20)];
pie = [pies(:,1:2:20) pies(:,1:5:20) pies(:,1:20)];
datosEntrenamiento = [derecha izquierda pie];

end

