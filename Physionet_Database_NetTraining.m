clc; close all; clear

% Definimos las etiquetas de las diferentes tareas y una matriz que va a
% guardar los resultados medios de 20 ejecuciones

etiquetaPies = 0;
etiquetaManoIzquierda = 1;
etiquetaManoDerecha = 2;
tiradas = zeros(20, 8);
l = 1;


for k=1:20
    
    f = 1;
    iter = 1;
    c = 1;
    i = 1;
    j = 1;

    % Creamos una matriz que almacenará el porcentaje de acierto y fallo de
    % las tres tareas y la ultima fila de esta matriz corresponde a la
    % media de los acietos y fallos de cada tarea.

    datosSujetos = zeros(13,7);
  
    % Obtenemos 12 pacientes aleatorios y sin repetición de los 109 sujetos

    sujetosCandidatos = zeros(1,12);

    while i~=13
        pacienteRandom = randi([1,109], 1,1);
        if(~ismember(pacienteRandom, sujetosCandidatos))
            sujetosCandidatos(:,iter) = pacienteRandom;
            iter = iter + 1;
            i = i +1;
        end
    end

    % Para los sujetos seleccionados aleatoriamente...

    for sujetos=1:length(sujetosCandidatos)

        % Obtenemos los datos correspondientes a la mano derecha, izquierda
        % y de ambos pies para todas las sesiones

        [mDS3,mIS3,mDS4,mIS4,pS5,pS6,mDS7,mIS7,mDS8,mIS8,pS9,pS10,mDS11,mIS11,mDS12,mIS12,pS13,pS14] = obtenerDatosSesiones(sujetosCandidatos(sujetos));

        % Agrupamos todos los datos de la mano derecha, mano izquierda y
        % de los pies

        pacienteManoDerecha = [mDS3 mDS4 mDS7 mDS8 mDS11 mDS12];
        pacienteManoIzquierda = [mIS3 mIS4 mIS7 mIS8 mIS11 mIS12];
        pacientePies = [pS5 pS6 pS9 pS10 pS13 pS14];

        % Componemos los datos de entrenamiento de la red neronal

        datosEntrenamiento = datosEntrenamienoRed(pacienteManoDerecha, pacienteManoIzquierda, pacientePies);

        % Clasificamos los datos en funcion de las tres tareas obteniendo
        % la tasa de acierto y fallo de cada una de ellas

        [tasaAcietoMD, tasaFalloMD] = clasificadorDatos(datosEntrenamiento, pacienteManoDerecha, etiquetaManoDerecha);
        [tasaAcietoMI, tasaFalloMI] = clasificadorDatos(datosEntrenamiento, pacienteManoIzquierda, etiquetaManoIzquierda);
        [tasaAcietoPies, tasaFalloPies] = clasificadorDatos(datosEntrenamiento, pacientePies, etiquetaPies);

        % Incorporamos los datos a la matriz comentada anteriormente

        datosSujetos(f,:) = [sujetos tasaAcietoMD tasaFalloMD tasaAcietoMI tasaFalloMI tasaAcietoPies tasaFalloPies];
        f = f + 1;
    end

    % A la ultima fila de la matriz anterior, añadimos el número total de
    % pacientes y la media de la tasa de acierto y fallo de las tareas. 

    datosSujetos(end, :) = [max(datosSujetos(:,1)) round(mean(datosSujetos(1:end-1,2)), 2) round(mean(datosSujetos(1:end-1,3)), 2) round(mean(datosSujetos(1:end-1,4)), 2) round(mean(datosSujetos(1:end-1,5)), 2) round(mean(datosSujetos(1:end-1,6)), 2) round(mean(datosSujetos(1:end-1,7)), 2)];
    
    tiradas(l,:) = [l datosSujetos(end,:)];
    l = l+1;

    % Guardamos los datos de las 20 ejecuciones en un fichero
    
    writetable(table(datosSujetos), 'Tiradas\Tiradas.xlsx', 'Sheet',k);
end
