function y = hello(name)
%HELLO Simple greeting function
%   y = hello(name) returns "Hello, <name> !" as a string.
arguments
    name {mustBeTextScalar}
end
y = "Hello,  " + string(name) + " ! ";
end