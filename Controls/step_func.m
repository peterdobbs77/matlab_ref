function u = step_func(t)
    x = sign(t); %takes negative values and makes them -1 and positive +1 and zero = 0
    u = (x+1)/2; %takes x and adds one to make it all positive and divides by 2
    
    %final product is a function from -5 to zero with amplitude 0
    %and 0 to 10 with amplitude 1