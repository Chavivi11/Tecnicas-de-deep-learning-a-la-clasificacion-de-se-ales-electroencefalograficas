clc; close all; clear
% Muestras sacadas de la base de datos de Physionet.
% Cargamos todos los sujetos y sus sesiones en un fichero

directorio = 'Physionet_Database\Muestras\';
separador = '\';
extension = '.edf';


% for sesionesAux=2:7
%     if (sujetos<10)
%         session = 'S00';
%     elseif(9<sujetos) && (sujetos<100)
%         session = 'S0';
%     else
%         session = 'S';
%     end
%     muestra = sesionesAux*2;
%     
%     if(muestra<10)
%         record = 'R0';
%     else
%         record = 'R';
%     end
% 
%     paciente = string(sujetos);
%     sesion = string(muestra);
% 
%     filename = strcat(directorio,session,paciente,separador,session,paciente,sesion,extension);

for sesion=1:12
    if(sesion<10)
        record = 'R0';
    else
        record = 'R';
    end

    filename = strcat(directorio,'S00','1',separador,'S00','1',record,string(sesion),extension);
    [data, anotaciones] = edfread(filename);
    
    switch sesion
        case 3
            sesion3 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS3, manoIzquierdaS3] = obtenerMDerecha_MIzquierda(sesion3);
        case 4
            sesion4 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS4, manoIzquierdaS4] = obtenerMDerecha_MIzquierda(sesion4);
        case 7
            sesion7 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS7, manoIzquierdaS7] = obtenerMDerecha_MIzquierda(sesion7);
        case 8
            sesion8 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS8, manoIzquierdaS8] = obtenerMDerecha_MIzquierda(sesion8);
        case 11
            sesion11 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS11, manoIzquierdaS11] = obtenerMDerecha_MIzquierda(sesion11);
        case 12
            sesion12 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS12, manoIzquierdaS12] = obtenerMDerecha_MIzquierda(sesion12);
    end
end

pacienteManoDerecha = [manoDerechaS3 manoDerechaS4 manoDerechaS7 manoDerechaS8 manoDerechaS11 manoDerechaS12];
pacienteManoIzquierda = [manoIzquierdaS3 manoIzquierdaS4 manoIzquierdaS7 manoIzquierdaS8 manoIzquierdaS11 manoIzquierdaS12];




    