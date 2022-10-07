clc; close all; clear
% Muestras sacadas de la base de datos de Physionet.
% Cargamos todos los sujetos y sus sesiones en un fichero

directorio = 'Physionet_Database\Muestras\';
separador = '\';
extension = '.edf';

% for sujetos=1:109
% 
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

%     filename = strcat(directorio,session,paciente,separador,session,paciente,sesion,extension);
% for sesion=1:12
%     if(sesion==3) || (sesion==4) || (sesion==7) || (sesion==8) || (sesion==11) || (sesion==12)
    

filename = strcat(directorio,'S00','1',separador,'S00','1','R03',extension);

[data, anotaciones] = edfread(filename);

[numRows, numCols] = size(data);

segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
contadorSegundosValidos = 1;


canalC3 = zeros(length(data.C3__{1,1})*4,length(segundosValidos));

for n=1:length(segundosValidos)
    for i=0:3
        canalC3(1:end,1) = data.C3__{segundosValidos(contadorSegundosValidos)+i,1};
    end
    contadorSegundosValidos = contadorSegundosValidos+1;
end
    




canalC3 = data.C3__(5,1);
% canalC4 = data.C4__(5:4:numRows,1);



% paciente1 = zeros(length(canalC3)*length(canalC3{1}),3);











