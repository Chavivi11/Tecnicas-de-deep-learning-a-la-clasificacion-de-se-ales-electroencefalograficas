function [mDS3,mIS3,mDS4,mIS4,pS5,pS6,mDS7,mIS7,mDS8,mIS8,pS9,pS10,mDS11,mIS11,mDS12,mIS12,pS13,pS14] = obtenerDatosSesiones(sujetos)

% Obtenemos todos los datos de las manos y pies de todas las sesiones de un
% sujeto

for sesion=1:14

    [data, anotaciones] = lecturaFichero(sesion, sujetos);

    switch sesion
        case 3
            [mDS3, mIS3] = rellenarMatrizDatosManos(data, anotaciones);
        case 4
            [mDS4, mIS4] = rellenarMatrizDatosManos(data, anotaciones);
        case 5
            pS5 = rellenarMatrizDatosPies(data, anotaciones);
        case 6
            pS6 = rellenarMatrizDatosPies(data, anotaciones);
        case 7
            [mDS7, mIS7] = rellenarMatrizDatosManos(data, anotaciones);
        case 8
            [mDS8, mIS8] = rellenarMatrizDatosManos(data, anotaciones);
        case 9
            pS9 = rellenarMatrizDatosPies(data, anotaciones);
        case 10
            pS10 = rellenarMatrizDatosPies(data, anotaciones);
        case 11
            [mDS11, mIS11] = rellenarMatrizDatosManos(data, anotaciones);
        case 12
            [mDS12, mIS12] = rellenarMatrizDatosManos(data, anotaciones);
        case 13
            pS13 = rellenarMatrizDatosPies(data, anotaciones);
        case 14
            pS14 = rellenarMatrizDatosPies(data, anotaciones);
    end

end
end

