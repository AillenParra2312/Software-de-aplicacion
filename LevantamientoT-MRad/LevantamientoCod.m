%% Levantamientos Topográficos en MATLAB
% Este script procesa datos crudos de levantamientos topográficos y genera un informe.

%% Paso 1: Carga de datos crudos
% Descripción de prueba de caja negra: Verificar que los datos se cargan correctamente desde el archivo especificado.
% Entradas esperadas: archivo .csv con columnas [Punto, Distancia, HD, VD, X_este, Y_norte, Z_cota, Cod]
% Resultados esperados: Datos cargados en la variable 'data' con las columnas correspondientes.

% Carga del archivo exportado
data = readtable('datos_crudos.csv'); % Cambia 'datos_crudos.csv' por el nombre de tu archivo

%% Paso 2: Preprocesamiento de datos crudos
% Descripción de prueba de caja negra: Asegurarse de que las columnas se renombran y se convierten a los tipos de datos correctos.
% Entradas esperadas: Datos crudos con valores numéricos y no numéricos en las columnas.
% Resultados esperados: Datos con columnas renombradas y convertidas a tipos numéricos, filas inválidas eliminadas.

% Renombrar las columnas para facilitar el acceso
data.Properties.VariableNames = {'Punto', 'Distancia', 'HD', 'VD', 'X_este', 'Y_norte', 'Z_cota', 'Cod'};

% Convertir variables necesarias a números
data.Distancia = str2double(strrep(data.Distancia, ',', '.'));
data.HD = str2double(strrep(data.HD, ',', '.'));
data.VD = str2double(strrep(data.VD, ',', '.'));
data.X_este = str2double(strrep(data.X_este, ',', '.'));
data.Y_norte = str2double(strrep(data.Y_norte, ',', '.'));
data.Z_cota = str2double(strrep(data.Z_cota, ',', '.'));

% Identificar filas inválidas y eliminarlas
filas_invalidas = any(isnan(data{:, {'Distancia', 'HD', 'VD', 'X_este', 'Y_norte', 'Z_cota'}}), 2);
data = data(~filas_invalidas, :);

%% Paso 3: Cálculos de levantamientos topográficos (Método de Radiación)
% Descripción de prueba de caja negra: Verificar la precisión de las coordenadas calculadas a partir de los datos procesados.
% Entradas esperadas: Datos de coordenadas en formato polar (Distancia, HD, VD) y coordenadas de referencia.
% Resultados esperados: Coordenadas cartesianas calculadas correctamente y almacenadas en la variable 'resultados'.

% Coordenadas de referencia de la estación
X0 = 0; % Coordenada X de la estación (cambia según punto de referencia)
Y0 = 0; % Coordenada Y de la estación (cambia según punto de referencia)
Z0 = 0; % Coordenada Z de la estación (cambia según punto de referencia)

% Inicializar matriz para resultados
resultados = zeros(height(data), 4); % [Punto, X_calc, Y_calc, Z_calc]

for i = 1:height(data)
    % Coordenadas polares a cartesianas
    Distancia = data.Distancia(i);
    HD = data.HD(i);
    VD = data.VD(i);
    
    % Convertir ángulos a radianes
    HD_rad = deg2rad(HD);
    VD_rad = deg2rad(VD);
    
    % Calcular coordenadas en el plano horizontal
    X_calc = X0 + Distancia * cos(VD_rad) * cos(HD_rad);
    Y_calc = Y0 + Distancia * cos(VD_rad) * sin(HD_rad);
    Z_calc = Z0 + Distancia * sin(VD_rad);
    
    % Almacenar resultados
    resultados(i, :) = [i, X_calc, Y_calc, Z_calc];
end

%% Paso 4: Interpretación y validación de resultados
% Descripción de prueba de caja negra: Asegurar que las coordenadas calculadas estén dentro de los rangos esperados.
% Entradas esperadas: Coordenadas calculadas en la variable 'resultados'.
% Resultados esperados: Coordenadas dentro de los rangos esperados y sin valores NaN.

% Validación simple: comprobar que las coordenadas no son NaN y están dentro de un rango esperado
valido = all(~isnan(resultados(:, 2:4)), 2) & resultados(:, 2) >= -10000 & resultados(:, 2) <= 10000 & ...
         resultados(:, 3) >= -10000 & resultados(:, 3) <= 10000 & resultados(:, 4) >= -10000 & resultados(:, 4) <= 10000;

% Filtrar resultados no válidos (opcional)
resultados_validos = resultados(valido, :);

% Calcular errores y tolerancia
errores = sqrt((resultados_validos(:, 2) - data.X_este).^2 + (resultados_validos(:, 3) - data.Y_norte).^2 + (resultados_validos(:, 4) - data.Z_cota).^2);
tolerancia = 1000; % Define tu propia tolerancia aquí

% Mostrar errores y puntos fuera de tolerancia
disp('Errores:');
disp(errores);
puntos_fuera_tol = errores > tolerancia;
if any(puntos_fuera_tol)
    warning('Algunos puntos están fuera de tolerancia.');
    disp('Puntos fuera de tolerancia:');
    disp(array2table(resultados_validos(puntos_fuera_tol, :), 'VariableNames', {'Punto', 'X_este', 'Y_norte', 'Z_cota'}));
else
    disp('Todos los puntos están dentro de tolerancia.');
end

%% Paso 5: Generación del informe
% Descripción de prueba de caja negra: Verificar que el informe se genera correctamente y contiene la información esperada.
% Entradas esperadas: Resultados válidos en la variable 'resultados_validos'.
% Resultados esperados: Archivo .csv y archivo de informe .txt generados correctamente con los datos esperados.

% Guardar resultados en un archivo .csv
results_table = array2table(resultados_validos, 'VariableNames', {'Punto', 'X_este', 'Y_norte', 'Z_cota'});
writetable(results_table, 'resultados_levantamientos.csv');

% Crear el informe
informe_filename = 'informe_levantamientos.txt';
fid = fopen(informe_filename, 'w');
fprintf(fid, 'Informe de Levantamientos Topográficos\n\n');

fprintf(fid, 'Errores:\n');
for i = 1:length(errores)
    fprintf(fid, 'Punto %d: %.2f\n', resultados_validos(i, 1), errores(i));
end

fprintf(fid, '\n');
if any(puntos_fuera_tol)
    fprintf(fid, 'Algunos puntos están fuera de tolerancia.\n');
    fprintf(fid, 'Puntos fuera de tolerancia:\n');
    for i = 1:size(resultados_validos(puntos_fuera_tol, :), 1)
        fprintf(fid, 'Punto %d: X=%.2f, Y=%.2f, Z=%.2f\n', resultados_validos(puntos_fuera_tol, 1), resultados_validos(puntos_fuera_tol, 2), resultados_validos(puntos_fuera_tol, 3), resultados_validos(puntos_fuera_tol, 4));
    end
else
    fprintf(fid, 'Todos los puntos están dentro de tolerancia.\n');
end

fclose(fid);
disp(['Informe generado: ' informe_filename]);

%% Paso 6: Visualización de resultados
% Descripción de prueba de caja negra: Asegurar que los resultados se visualizan correctamente en un gráfico 3D.
% Entradas esperadas: Resultados válidos en la variable 'resultados_validos'.
% Resultados esperados: Gráfico 3D con los puntos válidos correctamente visualizados.

figure;
scatter3(resultados_validos(:, 2), resultados_validos(:, 3), resultados_validos(:, 4), 'filled');
title('Resultados de Levantamientos Topográficos');
xlabel('X (este)');
ylabel('Y (norte)');
zlabel('Z (cota)');
grid on;

% Mostrar resultados no válidos (opcional)
if any(~valido)
    warning('Algunos puntos no son válidos y se han excluido de los resultados.');
    disp('Puntos no válidos:');
    disp(array2table(resultados(~valido, :), 'VariableNames', {'Punto', 'X_este', 'Y_norte', 'Z_cota'}));
end

%% Paso 7: Prueba de caja negra - Equivalencia de Clases (Distancias)
% Descripción: Verificar que las distancias medidas estén dentro de un rango específico.
% Entradas esperadas: Distancias medidas en la columna 'Distancia' de los datos procesados.
% Resultados esperados: Todas las distancias deben estar dentro del rango especificado.

% Definir el rango permitido para las distancias (en metros)
rango_minimo = 0;
rango_maximo = 1000;

% Obtener las distancias medidas
distancias_medidas = data.Distancia;

% Verificar que todas las distancias estén dentro del rango permitido
distancias_validas = all(distancias_medidas >= rango_minimo & distancias_medidas <= rango_maximo);

% Mostrar el resultado de la prueba
if distancias_validas
    disp('Todas las distancias están dentro del rango permitido.');
else
    disp('Algunas distancias están fuera del rango permitido.');
end