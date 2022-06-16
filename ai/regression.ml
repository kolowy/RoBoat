(*
    Initialise random bias and weight values

    param n: number of weights (int)
    returns: a tuple with the bias (float) and the weights (float list)
    *)
let init n = (0.0, [0.0])

(*
    Predict values using y = b + w1*d1 + w2*d2 ...
        with b the bias d1, d2 the different datas in the equations and
        w1, w2 the weights of the according data

    param b: bias (float)
    param x: data (float list)
    param w: weights, must be same length as data (float list)
    returns: the expected value of y (float)
    *)
let predict b x w = 0.0;;

(*
    Calculates the cost of current prediction

    param y: current value (float)
    param yp: predicted value (float)
    returns: the cost of the predicted value (float)
    *)
let cost y yp = 0.0;;

(*
    Update bias and weigths to reduce cost

    param x: input for prediction (float list)
    param y: real result (float)
    param yp: predicted result (float)
    param b: bias (float)
    param w: weights (float list)
    param lr: learning rate: update step (float)
    returns: a tuple with the new bias (float) and the new weights (float list)
    *)
let update_weight x y yp b w lr = (0.0, [0.0]);;

(*
    Run the Gradient descent algorithm
    
    param x: list of all entries for each data (float list list)
    param y: list of all example values in data (float list)
    param alpha: learning rate: update step for weight values (float)
    param it: number of iterations (int)
    returns: a tuple the final bias (float) and weights (float list)
    *)
let gradient_descent x y alpha it = (0.0, [0.0]);;
