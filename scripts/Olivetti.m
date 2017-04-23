%Prepare Olivetti faces for classification
clear

tsss=40;
trss=9*tsss;

noflabels=40;
trainlabs=zeros(400,1);

%set up labels
for i=1:400
    trainlabs(i)= floor((i-1)/10);
end

inistruct=load('olivettifaces.mat');
data=(inistruct.faces/255)';

indices=randsample(400,trss+tsss);
