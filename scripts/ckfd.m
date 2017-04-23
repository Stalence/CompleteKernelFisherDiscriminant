%Kernel PCA + LDA (CKFD)

 %kernel PCA 
 kerfun=@(x,sigma) exp(-(x.^2)/(2*sigma^2));
 polyfun=@(x,y,deg) (x*y'+1).^(deg);
 sigma=30;
 disp('Computing the training Kernel matrix...');
 ker=pdist2(trset,trset);
 ker=kerfun(ker,sigma);
 H=(1/trss)*ones(trss,1)*ones(trss,1)';
 ker=ker-H*ker-ker*H+H*ker*H;
 kerank=rank(ker);
 disp('Computing Eigendecomposition...');
 [v,e]=eigs(ker,kerank);
 v=normc(v);
 v=v*sqrt(diag(1./diag(e)));
 cv=v; 
 
 
%  test=bsxfun(@minus,test,mean(test,2))
 disp('Computing the test Kernel matrix...');
 kertest=pdist2(testset,trset);
 kertest=kerfun(kertest,sigma);
 Hone=(1/tsss)*ones(tsss,1)*ones(tsss,1)';
 Htwo= (1/trss)*ones(trss,1)*ones(trss,1)';
 kertest=kertest-Hone*kertest-kertest*Htwo+Hone*kertest*Htwo;
 kertest=cv'*kertest';
 kerdata=cv'*ker';
 
 disp('Computing the test Kernel matrix...2');

 %LDA
 S_w=zeros(kerank);
 S_b=zeros(kerank);
 m_0= mean(kerdata,2);
%   classind=struct;

 for i=1:10
     value=find(trlabs==i); 
     field=['index' num2str(i-1)];
     l_i=length(value);
%     classind.(field)=value;          
    class= kerdata(:,value);
    m_i=mean(class,2);
    S_b=S_b+l_i*(m_i-m_0)*(m_i-m_0)'/trss;
    S_w=S_w+cov(class')*l_i/trss;            
 end
 disp('Computing the test Kernel matrix...3');

  S_w=S_w+10^(-20)*eye(size(S_w));

 
 %NOTE: in S_w the 'cov' command includes normalization so we have to
 %cancel it out by multiplying again with l_i
 
 q=rank(S_w);
 [P,L]=eigs(S_w,size(S_w,2));
 %Orthonormal eigenvectors of within scatter 
 
  P_1=P(:,1:q);
  disp('Computing the test Kernel matrix...35');

 %Calculate Sw tilde and Sb tilde
 S_btilde= P_1'*S_b*P_1;
 S_wtilde= P_1'*S_w*P_1;
 
 %Compute generalized eigenvectors
 d=rank(S_btilde);
 [SV,SE]=eigs(S_btilde,S_wtilde,d);
 disp('Computing the test Kernel matrix...36');

 %Regular features
 U=SV;
 regularkerdata=U'*P_1'*kerdata;
 regularkertest=U'*P_1'*kertest;
 disp('Computing the test Kernel matrix...4');

 %Eigenvectors of Sb hat
 P_2=P(:,q+1:end);
 S_bhat=P_2'*S_b*P_2;
 [SbV,SbE]=eigs(S_bhat,d);
 V=SbV;
 
  %Irregular features
 irregularkerdata=  V'*P_2'*kerdata;
 irregularkertest=  V'*P_2'*kertest;
 disp('Computing the test Kernel matrix...5');

regulardists=pdist2(regularkerdata',regularkertest');
irregulardists=pdist2(irregularkerdata',irregularkertest');

regulardists=bsxfun(@times,regulardists,1./sum(regulardists,2));
irregulardists=bsxfun(@times,irregulardists,1./sum(irregulardists,2));

%feature fusion
theta=0.75;
g=theta*regulardists+irregulardists;
[M,I]=min(g,[],1);


meansreg=zeros(noflabels,d);
meansireg=zeros(noflabels,d);

for i=1:noflabels
    field=['index' num2str(i-1)];
    meansreg(i,:)=mean(regularkerdata(:,classind.(field)),2);
    meansireg(i,:)=mean(irregularkerdata(:,classind.(field)),2);
end
 
meanregdists=pdist2(meansreg,regularkertest');
meaniregdists=pdist2(meansireg,irregularkertest'); 

meanregdists=bsxfun(@times,meanregdists,1./sum(meanregdists,2));
meaniregdists=bsxfun(@times,meaniregdists,1./sum(meaniregdists,2));
g=theta*meanregdists+meaniregdists;
[M,I2]=min(g,[],1);

 foundlabsk=trlabs(I);
  flabsbink=zeros(length(foundlabsk),noflabels);
  subs=sub2ind(size(flabsbink),1:length(foundlabsk),foundlabsk');
  flabsbink(subs)=1;
 check=bitstlabels+flabsbink;
 perc=(length(find((check==2)))/tsss)*100; 

 
  foundlabsk=I2';
  flabsbink=zeros(length(foundlabsk),noflabels);
  subs=sub2ind(size(flabsbink),1:length(foundlabsk),foundlabsk');
  flabsbink(subs)=1;
 check=bitstlabels+flabsbink;
 perc2=(length(find((check==2)))/tsss)*100; 
 