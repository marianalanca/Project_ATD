function difAtividades(ACC,DFT,fs)

    for j=1:12
               
        originalX = ACC{j,1}{1,1}{1,1};
        originalY = ACC{j,2}{1,1}{1,1};
        originalZ = ACC{j,3}{1,1}{1,1};
        DFTX = DFT{1,1}{j,1}{1,1};
        DFTY = DFT{1,2}{j,1}{1,1};
        DFTZ = DFT{1,3}{j,1}{1,1};

        N = [0:numel(originalX)-1]./fs;

        figure()
        
        subplot(321)
        plot(N,originalX)
        yline(mean(originalX),'red');
        title('Sinal X sem DFT')
        subplot(322)
        plot(N,abs(DFTX))
        title('Sinal X com DFT')
        
        subplot(323)
        plot(N,originalY)
        yline(mean(originalY),'red');
        title('Sinal Y sem DFT')
        subplot(324)
        plot(N,abs(DFTY))
        title('Sinal Y com DFT')
        
        subplot(325)
        plot(N,originalZ)
        yline(mean(originalZ),'red');
        title('Sinal Z sem DFT')
        subplot(326)
        plot(N,abs(DFTZ))
        title('Sinal Z com DFT')
        
        if j==1
        	sgtitle('WALKING')
        elseif j==2
        	sgtitle('WALKING UPSTAIRS')
        elseif j==3
        	sgtitle('WALKING DOWNSTAIRS')
        elseif j==4
        	sgtitle('SITTING')
        elseif j==5
        	sgtitle('STANDING')
        elseif j==6
            sgtitle('LAYING')
        elseif j==7
            sgtitle('STAND TO SIT')
        elseif j==8
            sgtitle('SIT TO STAND')
        elseif j==9
            sgtitle('SIT TO LIE')
        elseif j==10
            sgtitle('LIE TO SIT')
        elseif j==11
            sgtitle('STAND TO LIE')
        elseif j==12
            sgtitle('LIE TO STAND')
        end
        
    end
    
end