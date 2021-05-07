function difDinamicas (DFT,inicio,fim)
    color = [[0,0,0];[1,0,0];[0,1,0]];
    forma = ['o','+','*'];
    
    figure()
    
    for i = inicio:fim
        
        X = [];
        Y = [];
        Z = [];

        number_cells = numel(DFT{1,1}{i,1});
        
        for j = 1: number_cells

            %axis X
            DFTX = DFT{1,1}{i,1}{j,1}; %retorna com detrend 

            m_X = abs(DFTX); %módulo complexo (magnitude) para elementos complexos de X

            max_x = max(m_X);
            min_mag_x = (0.6*max_x); %valores a cima de 0.6

            %MinPeakHeight permite-me escolher os picos acima de min_mag_x
            [~,locs_x] = findpeaks(m_X,'MinPeakHeight',min_mag_x);
            
            peak_x = abs(m_X(locs_x));
            X(j) = peak_x(1);

            %axis Y
            DFTY = DFT{1,2}{i,1}{j,1};
            m_Y = abs(DFTY);

            max_y = max(m_Y);
            min_mag_y = (0.6*max_y); 

            [~,locs_y] = findpeaks(m_Y,'MinPeakHeight',min_mag_y);
            
            peak_y = abs(m_Y(locs_y));
            Y(j) = peak_y(1);
            %Y(j) = pk_y(1);

            %axis Z
            DFTZ = DFT{1,3}{i,1}{j,1};
            m_Z = abs(DFTZ);

            max_z = max(m_Z);
            min_mag_z = (0.6*max_z); 
            [~,locs_z] = findpeaks(m_Z,'MinPeakHeight',min_mag_z);
            
            peak_z = abs(m_Z(locs_z));
            Z(j) = peak_z(1);
            
            %Z(j) = pk_z(1);
        end
        c = color(i,:);
        hold on

        plot3(X,Y,Z,forma(i),'color',c);
        view(3) 
    end
    legend('W',"W_UP","W_DO");

end