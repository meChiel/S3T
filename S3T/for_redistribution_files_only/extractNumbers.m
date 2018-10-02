function number=extractNumbers(str)
% Extracts all the numbers out of a strin
% Concatenates this into a string of numbers
% and than interpretes this as a number.
strNum=[];
for i=1:length(str)
   strNum =[strNum  num2str(str2double(str(i)))];
end
number = str2double(strNum);

end