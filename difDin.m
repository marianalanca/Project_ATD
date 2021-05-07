function difDin (f_relevant) %diferenciar dinâmica das outras
    
    color = [[0,0,0];[1,0,0];[0,1,0];[0,0,1];[1,1,0];[1,0,1];[0,1,1];[0.5,1,0];[1,0.5,0];[1,0,0.5];[0,0,0.5];[1,0.25,1]];
    forma = ['o','o','o','+','+','+','*','*','*','*','*','*'];
    
    figure()
    
    for i=1:12    
      tempX=f_relevant{1,1}{i,1};
      tempY=f_relevant{1,2}{i,1};
      tempZ=f_relevant{1,3}{i,1};
      finalX=[];
      finalY=[];
      finalZ=[];
      for j=1:length(tempX)
          
           %DFT
           finalX(j)=tempX{j,1}(1,1);
           finalY(j)=tempY{j,1}(1,1);
           finalZ(j)=tempZ{j,1}(1,1);
           
      end

      c = color(i,:);
      hold on
      
      plot3(finalX,finalY,finalZ,forma(i),'color',c);
      view(3) 
    end

    legend('W',"W_UP","W_DO","SIT","STAND","LAY","STA_SIT","SIT_STA","SIT_LIE","LIE_SIT","STA_LIE","LIE_STA");
end