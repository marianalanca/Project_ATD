%% INFORMA??ES

%Materiais a entregar: Relat?rio e C?digo (poder? usar o Jupyter notebook para integrar o
%relat?rio e o c?digo).
%Data limite de entrega: 20 de maio de 2020 ?s 23h59 via Inforestudante.
%Defesa: Em slot temporal a selecionar para os dias 26, 27 ou 29 de maio de 2020

%% INSTRU??ES

%1. Fazer download dos sinais relativos ? sua turma PL. (PL2)
%
%2. Desenvolver o c?digo necess?rio para importar esses sinais.
%
%3. Representar graficamente os sinais importados, identificando a atividade a que cada fragmento
%corresponde.
%
%4. Calcular a DFT de cada fragmento do sinal associado a uma atividade.
%   4.1. Comparar os resultados obtidos com diferentes tipos de janela deslizante. Qual o efeito dos
%        diferentes tipos de janela? Justificar.
%   4.2. Para as atividades din?micas fazer uma identifica??o estat?stica do n?mero de passos por
%        minuto. Criar uma tabela de valores, incluindo o valor m?dio e o desvio padr?o.
%   4.3. Identificar caracter?sticas espectrais que permitam diferenciar atividades est?ticas e de
%        transi??o das atividades din?micas. Demonstrar graficamente. Qual a performance em termos
%        de sensibilidade e especificidade?
%   4.4. Identificar caracter?sticas espectrais que permitam diferenciar entre os diferentes tipos de
%        atividades. Demonstrar graficamente.
%   4.5. Identificar caracter?sticas espectrais que permitam diferenciar as atividades din?micas.
%        Demonstrar graficamente.

%% INFORMA??ES 
%ACC ? um array de c?lulas com 3 colunas (Axis X, Y e Z) e 12 linhas (uma
%para cada atividade); cada uma dessas c?lulas ter? informa??o sobre os
%dados correspondentes a essa atividade

%ACCX,ACCY,ACCZ s?o um array de c?lulas,com uma coluna apenas e 12 linhas,
%cada uma para cada atividade; cada uma dessas c?lulas ter? N c?lulas (N =
%n?mero de dados da atividade dessa Axis), em que cada c?lula ter? 3
%colunas, para cada uma das janelas

%% C?DIGO
clc
clear
close all

%% 2.

user = {'06', '07', '08', '09', '10'};
exp = {'11', '12', '13', '14', '15', '16', '17', '18', '19', '20'};

activities = {'W', 'W\_U', 'W\_D', 'SIT', 'STAND', 'LAY', 'S\_SIT', 'S\_STAND', 'S\_lay', 'L\_SIT', 'S\_lay', 'L\_STAND'};
sensors = {'ACC\_X', 'ACC\_Y', 'ACC\_Z'};

fs = 50; %Sampling frequency in Hz
Tframe = 1.05; % largura da janela de an?lise em s -> passada do ser humano d?-se no intervalo de 0.5s a 1.6 s
Toverlap = 0.55; % sobreposi?ao das janelas em s
Nframe = round(Tframe*fs); % n?mero de amostras na janela
Noverlap = round(Toverlap*fs); % n?mero de amostras sobrepostas na janela

%Inicializar o array de c?lulas que conter? os dados
ACC = cell(12,3);
for i=1:3
    for j=1:12
        ACC{j,i} = {};
    end
end
    
for i = 1:10
    
    e = i; %exp value
    u = ceil(e/2); %user value
    
    %Acel file name
    acc_file = sprintf('database/acc_exp%s_user%s.txt', exp{e}, user{u});
    
    %Import raw_data_file and store it in a matrix
    dacc = importdata(acc_file);
    %%matriz_dados = importfile("acc_exp11_user06.txt").acc_exp11_user06
    
    %Get label info
    all_labels = importdata('database/labels.txt');
    
    %Get labels for the current data file
    ix_labels = intersect(find(all_labels(:, 1) == str2num(exp{e})), find(all_labels(:, 2) == str2num(user{u})));
    %gerar? um "array" com as linhas da label em que existem atividades
        
    data = dacc;
    N= length(data);
    t = [0: N - 1]./fs;%time scale 
    
    %Get data size
    [v, col] = size(data); %returns two parameters: first is the number of 
    %values in each column, and the second, the number of columns
    
    %% 3.
    figure;
    
     for i = 1:col
               
         subplot(col, 1, i); %vai criar os subplots na mesma fig para os tr?s graficos (conforme o num de colunas (3)
         plot(t./60, data(:, i), 'k--') %faz o plot de cada m dos tempos (dividido por 60, da coluna i 
         axis([0 t(end)./60 min(data(:, i)) max(data(:, i))])
         xlabel('Time (min)');
         ylabel(sensors{i}); %lista com sensores
         hold on
        
         for j = 1 : numel(ix_labels)
             
             linha = ix_labels(j);
             inicio = all_labels(linha, 4); %acede a quarta coluna do all_labels (que cont?m o in?cio da atividade no ficheiro)
             fim = all_labels(linha, 5);
             activity = all_labels(linha,3);
         
             plot(t(inicio:fim)./60, data(inicio:fim, i));
             %Define a posi??o do y em que fica a label do movimento
             if mod(j, 2) == 1
                 ypos = min(data(:, i)) - (0.2 * min(data(:, i)));
             else
                 ypos = max(data(:, i)) - (0.2 * min(data(:, i)));
             end
             text(t(inicio)/60, ypos, activities{activity});
            
             new = data(inicio:fim,i);
             
             %adicionar ? c?lula
             ACC{activity,i}{1,end+1} = {new}; %ap?s criar a c?lula
        end
    end
    
end

%pause
close all

ACCX = ACC(:,1);
ACCY = ACC(:,2);
ACCZ = ACC(:,3);

%% 4.1

DFT = cell(1,3);
f_relevant = cell(1,3);

%wvtool(hamming(N))
%wvtool(rectwin(N))
%wvtool(gausswin(N))

%retorna DFT com a janela de Hamming
[DFT{1,1},fXYZ,f_relevant{1,1}] = calcDFT(ACCX,fs);
[DFT{1,2},~,f_relevant{1,2}] = calcDFT(ACCY,fs);
[DFT{1,3},~,f_relevant{1,3}] = calcDFT(ACCZ,fs);

%% 4.2

spm = cell(1,3);

spm{1,1} = calcSteps(ACCX,fs,Nframe,Noverlap);
spm{1,2} = calcSteps(ACCY,fs,Nframe,Noverlap);
spm{1,3} = calcSteps(ACCZ,fs,Nframe,Noverlap);

%O C?LCULO ? FEITO COM RECURSO ? JANELA DE HAMMING DESLIZANTE

for i=1:3
    i
    disp('X: ')
    disp('HAMMING: ')
    spm{1,1}{i,1}{1,2}(1)
    spm{1,1}{i,1}{1,3}(1)
%     disp('RECTANGULAR: ')
%     spm{1,1}{i,1}{2,2}(1)
%     spm{1,1}{i,1}{2,3}(1)
%     disp('GAUSS: ')
%     spm{1,1}{i,1}{3,2}(1)
%     spm{1,1}{i,1}{3,3}(1)
    
    disp('Y: ')
    disp('HAMMING: ')
    spm{1,2}{i,1}{1,2}(1)
    spm{1,2}{i,1}{1,3}(1)
%     disp('RECTANGULAR: ')
%     spm{1,2}{i,1}{2,2}(1)
%     spm{1,2}{i,1}{2,3}(1)
%     disp('GAUSS: ')
%     spm{1,2}{i,1}{3,2}(1)
%     spm{1,2}{i,1}{3,3}(1)
    
    disp('Z: ')
    disp('HAMMING: ')
    spm{1,3}{i,1}{1,2}(1)
    spm{1,3}{i,1}{1,3}(1)
%     disp('RECTANGULAR: ')
%     spm{1,3}{i,1}{2,2}(1)
%     spm{1,3}{i,1}{2,3}(1)
%     disp('GAUSS: ')
%     spm{1,3}{i,1}{3,2}(1)
%     spm{1,3}{i,1}{3,3}(1)
end

%% 4.3
%difDin(f_relevant);

%% 4.4/4.5
%Mostrar os gr?ficos de todas as atividades -> original e DFT
      
difAtividades(ACC,DFT,fs);

%fazer o plot com as magnitudes do sinal

difDinamicas(DFT,1,3);
difDinamicas(DFT,2,3);

%% 5.
% SFTF

calcSTFT('database/acc_exp11_user06.txt', fs, Tframe, Toverlap);

