% 10-fold cross validate 
finalpercentage=0;
finalpercentage2=0;
time=0;
for k=1:10

testind=(indices((k-1)*tsss+1:k*tsss));
trsetind=setdiff(indices,testind);

testset=data(testind,:);
trset=data(trsetind,:);
 
trlabs=trainlabs(trsetind);
testlabs=trainlabs(testind);


trlabs=trlabs+1;
testlabs=testlabs+1;



bitrlabels= zeros(trss,noflabels);
subs=sub2ind(size(bitrlabels),1:trss,trlabs');
bitrlabels(subs)=1;


bitstlabels= zeros(tsss,noflabels);
subs=sub2ind(size(bitstlabels),1:tsss,testlabs');
bitstlabels(subs)=1;


 classind=struct;
 for i=1:noflabels
     value=find(trlabs==i); 
     field=['index' num2str(i-1)];
     classind.(field)=value;          
 end

tic;
%Comment\Uncomment to choose classification method.
ckfd; 
% simplepca;
% kerpca;

time=time+toc/10;
finalpercentage=perc/10+finalpercentage;
finalpercentage2=perc2/10+finalpercentage2;


end

disp(['NN Classification rate: ' num2str(finalpercentage)]);
disp(['MD Classification rate: ' num2str(finalpercentage2)]);
disp(['Average time: ' num2str(time)]);

