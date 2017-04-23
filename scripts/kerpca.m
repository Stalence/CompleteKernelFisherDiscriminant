% Kernel PCA + (NN and MD)


 %kernel PCA
 
 kerfun=@(x,sigma) exp(-(x.^2)/(2*sigma^2));
 polyfun=@(x,y,deg) (x*y'+1).^(deg);
 sigma=40;
   disp('Computing the training Kernel matrix...');
  ker=pdist2(trset,trset);
  ker=kerfun(ker,sigma);
H=(1/trss)*ones(trss,1)*ones(trss,1)';
ker=ker-H*ker-ker*H+H*ker*H;
   disp('Computing Eigendecomposition...');
   ranker=rank(ker);
 [v,e]=eigs(ker,ranker);
  v=normc(v);
  v=v*sqrt(diag(1./diag(e)));
 cv=v;
 
 
 
%  test=bsxfun(@minus,test,mean(test,2))
disp('Computing the test Kernel matrix...');
 kertest=pdist2(testset,trset);
 kertest=kerfun(kertest,sigma);
   Hone=(1/tsss)*ones(tsss,1)*ones(tsss,1)';
   Htwo= (1/tsss)*ones(trss,1)*ones(trss,1)';
  kertest=kertest-Hone*kertest-kertest*Htwo+Hone*kertest*Htwo;
 kertest=cv'*kertest';
 kerdata=cv'*ker';

 
disp('Performing KNN...');
idxk= knnsearch(kerdata',kertest');
 foundlabsk=trlabs(idxk);
 flabsbink=zeros(length(foundlabsk),noflabels);
 subs=sub2ind(size(flabsbink),1:length(foundlabsk),foundlabsk');
 flabsbink(subs)=1;
check=bitstlabels+flabsbink;
perc=(length(find((check==2)))/tsss)*100; 

%MD - Nearest centroid
  means=zeros(noflabels,ranker);
for i=1:noflabels
    field=['index' num2str(i-1)];
    means(i,:)=mean(kerdata(:,classind.(field)),2);
end

dists=pdist2(means,kertest');
[M,I2]=min(dists,[],1);

 foundlabsk=I2';
 flabsbink=zeros(length(foundlabsk),noflabels);
 subs=sub2ind(size(flabsbink),1:length(foundlabsk),foundlabsk');
 flabsbink(subs)=1;
check=bitstlabels+flabsbink;
perc2=(length(find((check==2)))/tsss)*100; 
