figure(1);
three=kerdata(:,classind.index2);
eight=kerdata(:,classind.index7);
scatter(three(1,:),three(2,:));
hold on
scatter(eight(1,:),eight(2,:));

figure(2);
three=regularkerdata(:,classind.index2);
eight=regularkerdata(:,classind.index7);
scatter(three(1,:),three(2,:));
hold on
scatter(eight(1,:),eight(2,:));

figure(3);
three=trained(:,classind.index2);
eight=trained(:,classind.index7);
scatter(three(1,:),three(2,:));
hold on
scatter(eight(1,:),eight(2,:));
