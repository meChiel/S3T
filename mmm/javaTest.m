% Compile 
!"C:\Program Files\Java\jdk1.8.0_91\bin\javac" -source 1.8 -target 1.8 test1.java
!"C:\Program Files\Java\jdk1.8.0_91\bin\javac" -source 1.8 -target 1.8 HelloWorld.java

% Set up Java
javaaddpath('./')
% Initiate
o = Test1;
% Run
javaMethod('main', o, '')
javaMethod('main', Test1, '')
javaMethod('main', HelloWorld, '')
