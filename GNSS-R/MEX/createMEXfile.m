%% Create MEX file based on *.cpp files
%run the script in the path of *.cpp files
mex -output mymex *.cpp

%% Test MEX file
%%input the path of filelists
filepath = '..\Data\output\';
%%Ensure the configuration file is in the input path
mymex(filepath);