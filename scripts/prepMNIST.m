%Prepare MNIST for multiclass problem
clear

%training and test set sizes for cross validation
tsss=100;
trss=9*tsss;

%number of labels
noflabels=10;

trainlabs=loadMNISTLabels('train-labels.idx1-ubyte');
data=loadMNISTImages('train-images.idx3-ubyte')';

%randomly sample data points for crossvalidation
indices=randsample(60000,trss+tsss);


