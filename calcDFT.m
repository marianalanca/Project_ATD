%% TO DO

%% INFOS
%   WINDOWS:
%       retangular: w = rectwin(L) returns a rectangular window of length L.
%       hamming: w = hamming(L) returns an L-point symmetric Hamming window.  

%% COMENTÁRIOS
%   wvtool(w) %Mostra no dominio do tempo e da frequencia

%% CÓDIGO

function [r1,r2,r3] = calcDFT(activities,fs)
    
    r1 = cell(1,1); %gerar array de células para adicionar os resultados da DFT (sem janela)
    r2 = cell(1,1); %gerar array de células para adicionar os resultados das fs
    r3 = cell(1,1); %gera array de células para adicionar os resultados das f_relevant
    
    limiar = 0.4;
    
    for i =1:12 %por cada uma das atividades
        
        %falta representar as figuras
        
        activity = activities{i,:}; %atividade da qual se pretende calcular a DFT
        M = length(activity); 
        tempR1 = cell(M,1); %Array com espaço para todos os resultados de cada uma das DFTs das atividades
        tempR2 = cell(M,1); %Array com espaço para todos os resultados de cada uma das fs das atividades
        tempR3 = cell(M,1);
        
        %Definindo a janela como sendo retangular
        for j = 1:M
            
            x = activity{1,j}{:,1};
            N = length(x);
            x = detrend(x);
            if (mod(N,2)==0)
                % se o número de pontos do sinal for par
                f = -fs/2:fs/N:fs/2-fs/N;
            else
                % se o número de pontos do sinal for ímpar
                f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
            end
            
            X = fftshift(fft(x)); % DFT de activity
          	X(find(abs(X)<0.001)) = 0; % anular valores residuais
            
            m = abs(X);
            max_m = max(m);
            min_mag = limiar*max_m;
            
            [~,ind] = findpeaks(m,'MinPeakHeight',min_mag);
            
            f_relevant = f(ind);
            f_relevant = f_relevant(f_relevant>=0);
            round(f_relevant);
            
            tempR1{j,1} = X;
            tempR2{j,1} = f;
            tempR3{j,1} = f_relevant;
            %tempResult{j,1} = cell(1,3);
            
        end
        
        %Representação dos gráficos
        %{
        if i==1 || i==4 || i==7
            figure()
            plot(f,abs(X))
            title('|DFT|')
            
            figure()

        end
        
        %}
            
        r1{i,1} = tempR1;
        r2{i,1} = tempR2;
        r3{i,1} = tempR3;
    end
end
