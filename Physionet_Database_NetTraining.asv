clc; close all; clear

% Muestras sacadas de la base de datos de Physionet.
% Cargamos todos los sujetos y sus sesiones en un fichero

etiquetaPies = 0;
etiquetaManoIzquierda = 1;
etiquetaManoDerecha = 2;

tiradas = zeros(20, 8);

l = 1;

for k=1:1
    
    f = 1;
    iter = 1;
    c = 1;
    i = 1;
    j = 1;

    datosSujetos = zeros(13,7);
%     sujetosCandidatos = [17	78	56	38	69	77	29	53	43	51	10	104];
    sujetosCandidatos = zeros(1,12);

    % Obtenemos 12 pacientes aleatorios y sin repetición de los 109 sujetos
    while i~=13
        pacienteRandom = randi([1,109], 1,1);
        if(~ismember(pacienteRandom, sujetosCandidatos))
            sujetosCandidatos(:,iter) = pacienteRandom;
            iter = iter + 1;
            i = i +1;
        end
    end

    for sujetos=1:length(sujetosCandidatos)

        [mDS3,mIS3,mDS4,mIS4,pS5,pS6,mDS7,mIS7,mDS8,mIS8,pS9,pS10,mDS11,mIS11,mDS12,mIS12,pS13,pS14] = obtenerDatosSesiones(sujetosCandidatos(sujetos));

        pacienteManoDerecha = [mDS3 mDS4 mDS7 mDS8 mDS11 mDS12];
        pacienteManoIzquierda = [mIS3 mIS4 mIS7 mIS8 mIS11 mIS12];
        pacientePies = [pS5 pS6 pS9 pS10 pS13 pS14];

        datosEntrenamiento = datosEntrenamienoRed(pacienteManoDerecha, pacienteManoIzquierda, pacientePies);

        [tasaAcietoMD, tasaFalloMD] = clasificadorDatos(datosEntrenamiento, pacienteManoDerecha, etiquetaManoDerecha);
        [tasaAcietoMI, tasaFalloMI] = clasificadorDatos(datosEntrenamiento, pacienteManoIzquierda, etiquetaManoIzquierda);
        [tasaAcietoPies, tasaFalloPies] = clasificadorDatos(datosEntrenamiento, pacientePies, etiquetaPies);

        datosSujetos(f,:) = [sujetos tasaAcietoMD tasaFalloMD tasaAcietoMI tasaFalloMI tasaAcietoPies tasaFalloPies];
        f = f + 1;
    end

    datosSujetos(end, :) = [max(datosSujetos(:,1)) mean(datosSujetos(1:end-1,2)) mean(datosSujetos(1:end-1,3)) mean(datosSujetos(1:end-1,4)) mean(datosSujetos(1:end-1,5)) mean(datosSujetos(1:end-1,6)) mean(datosSujetos(1:end-1,7))];
    
    tiradas(l,:) = [l datosSujetos(end,:)];
    l = l+1;
end
