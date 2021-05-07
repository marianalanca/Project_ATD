%o ser humano tem uma passada em torno dos 0.6Hz-2Hz, o que corresponde a 0.5s-1.6s -> escolha tamanho da janela
%frequencias entre 0.6Hz e 2Hz. Depois de retirares as frequencias fora desse intervalo, fazes a média e o desvio padrrão para teres, por exemplo 100 passos por minuto, com um erro de +/- 10 passos.

function steps = calcSteps(data,fs,Nframe,Noverlap)
    
    steps = cell(3,1);

    for i=1:12
        activity = data{i,:}; %atividade da qual se pretende calcular a DFT
        M = length(activity); 
        
        steps{i,1} = cell(3,1);
        
        for j = 1:M
            
            x = activity{1,j}{:,1};
            N = length(x);
            x = detrend(x);

            r = rectwin(Nframe);
            h = hamming(Nframe);
            g = gausswin(Nframe);
            
            if mod(Nframe, 2)==0
                f_frame = -fs/2:fs/Nframe:fs/2-fs/Nframe;
            else 
                f_frame = -fs/2+fs/(2*Nframe):fs/Nframe:fs/2-fs/(2*Nframe);
            end
            
            freq_relev_h = [];            
            freq_relev_r = [];            
            freq_relev_g = [];
            
            for ii=1:Nframe-Noverlap:N-Nframe
                H = x(ii:ii+Nframe-1).*h;
                R = x(ii:ii+Nframe-1).*r;
                G = x(ii:ii+Nframe-1).*g;
                
                m_H = abs(fftshift(fft(H))); % DFT de activity
                m_R = abs(fftshift(fft(R))); % DFT de activity
                m_G = abs(fftshift(fft(G))); % DFT de activity
                
                m_H_max = max(m_H);
                m_R_max = max(m_R);
                m_G_max = max(m_G);
                
                ind_h = find(abs(m_H-m_H_max)<0.001);
                ind_r = find(abs(m_R-m_R_max)<0.001);
                ind_g = find(abs(m_G-m_G_max)<0.001);
              
                freq_relev_h = [freq_relev_h, f_frame(ind_h(1))];
                freq_relev_r = [freq_relev_r, f_frame(ind_r(1))];
                freq_relev_g = [freq_relev_g, f_frame(ind_g(1))];
                
            end
            
            if i==1 || i==2 || i==3
            
                freq_relev_h = abs(freq_relev_h);
                freq_relev_r = abs(freq_relev_r);
                freq_relev_g = abs(freq_relev_g);

                freq_relev_h = freq_relev_h(find((0.6<freq_relev_h) & (freq_relev_h<2)));
                freq_relev_r = freq_relev_r(find(0.6<freq_relev_r & freq_relev_r<2));
                freq_relev_g = freq_relev_g(find(0.6<freq_relev_g & freq_relev_g<2));

                %cálculo dos passos
                spm_h = freq_relev_h(1)*60;
                spm_r = freq_relev_r(1)*60;
                spm_g = freq_relev_g(1)*60;

                steps{i,1}{1,1}(j) = spm_h;
                steps{i,1}{2,1}(j) = spm_r;
                steps{i,1}{3,1}(j) = spm_g;
            end
            
        end
        
        if i==1 || i==4 || i==7 %representar um gráfico para cada uma das atividades
            figure()
             
            subplot(311);
            plot(f_frame,abs(m_R))
            title('|DFT| com rect')
                 
            subplot(312);
            plot(f_frame,abs(m_H))
            title('|DFT| com Hamming')
                 
            subplot(313);
            plot(f_frame,abs(m_G))
            title('|DFT| com Gauss')
        end
        
        %cálculo média
        steps{i,1}{1,2} = mean(steps{i,1}{1,1});
        steps{i,1}{2,2} = mean(steps{i,1}{2,1});
        steps{i,1}{3,2} = mean(steps{i,1}{3,1});
        
        steps{i,1}{1,3} = std(steps{i,1}{1,1});
        steps{i,1}{2,3} = std(steps{i,1}{2,1});
        steps{i,1}{3,3} = std(steps{i,1}{3,1});
        
    end

end