function g = sigmoidGradient(z)
    print "hej"
    g=sigmoid(z);
    1.0-sigmoid(z)
    %g=sigmoid(z).*(1.0-sigmoid(z)); 
end