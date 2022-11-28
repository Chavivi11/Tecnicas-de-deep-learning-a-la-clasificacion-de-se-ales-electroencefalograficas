function [mDS3,mIS3,mDS4,mIS4,pS5,pS6,mDS7,mIS7,mDS8,mIS8,pS9,pS10,mDS11,mIS11,mDS12,mIS12,pS13,pS14] = obtenerDatosSesiones(sujetos)

for sesion=1:14

    [data, anotaciones] = lecturaFichero(sesion, sujetos);

%         switch sesion
%             case 3
%                 [mDS3, mIS3] = rellenarMatrizDatosManos(data, anotaciones);
%             case 4
%                 [mDS4, mIS4] = rellenarMatrizDatosManos(data, anotaciones);
%             case 5
%                 pS5 = rellenarMatrizDatosPies(data, anotaciones);
%             case 6
%                 pS6 = rellenarMatrizDatosPies(data, anotaciones);
%             case 7
%                 [mDS7, mIS7] = rellenarMatrizDatosManos(data, anotaciones);
%             case 8
%                 [mDS8, mIS8] = rellenarMatrizDatosManos(data, anotaciones);
%             case 9
%                 pS9 = rellenarMatrizDatosPies(data, anotaciones);
%             case 10
%                 pS10 = rellenarMatrizDatosPies(data, anotaciones);
%             case 11
%                 [mDS11, mIS11] = rellenarMatrizDatosManos(data, anotaciones);
%             case 12
%                 [mDS12, mIS12] = rellenarMatrizDatosManos(data, anotaciones);
%             case 13
%                 pS13 = rellenarMatrizDatosPies(data, anotaciones);
%             case 14
%                 pS14 = rellenarMatrizDatosPies(data, anotaciones);
%         end

    switch sesion
        case 3
            sesion3 = obtenerDatosEntrenamiento(data, anotaciones);
            [mDS3, mIS3] = obtenerMDerecha_MIzquierda(sesion3);

        case 4
            sesion4 = obtenerDatosEntrenamiento(data, anotaciones);
            [mDS4, mIS4] = obtenerMDerecha_MIzquierda(sesion4);

        case 5
            sesion5 = obtenerDatosPies(data, anotaciones);
            pS5 = datosPies(sesion5);

        case 6
            sesion6 = obtenerDatosPies(data, anotaciones);
            pS6 = datosPies(sesion6);

        case 7
            sesion7 = obtenerDatosEntrenamiento(data, anotaciones);
            [mDS7, mIS7] = obtenerMDerecha_MIzquierda(sesion7);

        case 8
            sesion8 = obtenerDatosEntrenamiento(data, anotaciones);
            [mDS8, mIS8] = obtenerMDerecha_MIzquierda(sesion8);

        case 9
            sesion9 = obtenerDatosPies(data, anotaciones);
            pS9 = datosPies(sesion9);

        case 10
            sesion10 = obtenerDatosPies(data, anotaciones);
            pS10 = datosPies(sesion10);

        case 11
            sesion11 = obtenerDatosEntrenamiento(data, anotaciones);
            [mDS11, mIS11] = obtenerMDerecha_MIzquierda(sesion11);

        case 12
            sesion12 = obtenerDatosEntrenamiento(data, anotaciones);
            [mDS12, mIS12] = obtenerMDerecha_MIzquierda(sesion12);

        case 13
            sesion13 = obtenerDatosPies(data, anotaciones);
            pS13 = datosPies(sesion13);

        case 14
            sesion14 = obtenerDatosPies(data, anotaciones);
            pS14 = datosPies(sesion14);

    end
end
end

