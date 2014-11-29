--A calculator code that performs simple addition, subtraction, multiplication and division.
Calculator = {};

--Returns the sum of num1 + num2
function add(num1, num2)
    return num1 + num2
end

--Returns the sum of num1 - num2
function sub(num1, num2)
    return num1 - num2
end

--Returns the sum of num1 * num2
function mul(num1, num2)
    return num1 * num2
end

--Returns the sum of num1 / num2
function div(num1, num2)
    return num1/num2
end

function Calculator.main(frame)
    operation = frame.args[1]
    var1 = frame.args[2]
    var2 = frame.args[3]
    if(operation ~= '+' and operation ~= '-' and operation ~= '*' and operation ~= '/')
       --invalid operation
       then return("You must enter a valid operation.")
    else
        if(operation == '+')
            then return(add(var1, var2))
        elseif(operation == '-')
            then return(sub(var1, var2))
        elseif(operation == '*')
            then return(mul(var1, var2))
        elseif(operation == '/')
            then return(div(var1, var2))
        end
    end
end

return Calculator;
