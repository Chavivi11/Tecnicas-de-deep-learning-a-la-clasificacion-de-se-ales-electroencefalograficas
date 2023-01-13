function [data,anotaciones] = lecturaFichero(sesion, sujetos)

% Función destinada a la lectura de las sesiones de un sujeto

directorio = 'Physionet_Database\Muestras\';
separador = '\';
extension = '.edf';

if(sesion<10)
    record = 'R0';
else
    record = 'R';
end

if(sujetos < 10)
    paciente = strcat('00', string(sujetos));
elseif(9 < sujetos) && (sujetos < 100)
    paciente = strcat('0', string(sujetos));
else
    paciente = string(sujetos);
end

filename = strcat(directorio,'S',paciente,separador,'S',paciente,record,string(sesion),extension);

[data, anotaciones] = edfread(filename);

end

