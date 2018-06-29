function number=extractNumbers(str)
strNum=[];
for i=1:length(str)
   strNum =[strNum  num2str(str2double(str(i)))];
end
number = str2double(strNum);

end