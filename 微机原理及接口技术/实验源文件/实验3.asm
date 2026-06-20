CODE SEGMENT   PUBLIC
ASSUME CS:CODE	
START:
        MOV DX,0606H        
        MOV AL,00110110B    
  	    OUT DX,AL
  	    MOV DX,0600H          
    	MOV AX,4000          
        OUT DX,AL                 
    	MOV AL,AH                
     	OUT DX,AL
     	MOV DX,0606H 
   	    MOV AL,01110110B  
  	    OUT DX,AL                  
    	MOV DX,0602H   
    	MOV AX,2000            
     	OUT DX,AL                    
    	MOV AL,AH                
     	OUT DX,AL                    
ABC:          
       JMP ABC
CODE ENDS
END START    