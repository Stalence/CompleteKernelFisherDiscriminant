 %classical PCA + (NN and MD)
 dimensions=100;
disp('Performing PCA through SVD...');
[coeff,score,latent]=pca(trset);
% [coeffs,e,coeff]=svd(trset);
coeff=coeff(:,1:dimensions);
trained=coeff'*trset';
tested=coeff'*testset';
% trained=trset';
% tested=test';


disp('Performing KNN...');
idxc=knnsearch(trained',tested');
foundlabsc=trlabs(idxc);
 flabsbinc=zeros(length(foundlabsc),noflabels);
 subs=sub2ind(size(flabsbinc),1:length(foundlabsc),foundlabsc');
 flabsbinc(subs)=1;
check=bitstlabels+flabsbinc;
perc=(length(find((check==2)))/tsss)*100;

%MD - Nearest centroid
  means=zeros(noflabels,dimensions);
for i=1:noflabels
    field=['index' num2str(i-1)];
    means(i,:)=mean(trained(:,classind.(field)),2);
end

dists=pdist2(means,tested');
[M,I2]=min(dists,[],1);

 foundlabsk=I2';
 flabsbink=zeros(length(foundlabsk),noflabels);
 subs=sub2ind(size(flabsbink),1:length(foundlabsk),foundlabsk');
 flabsbink(subs)=1;
check=bitstlabels+flabsbink;
perc2=(length(find((check==2)))/tsss)*100; 

