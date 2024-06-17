net = feedforwardnet([10 8 6]);

% Configure the network for training
net = configure(net,trainZ2 , squeeze(trainTar) );

net = train(net, trainZ2, squeeze(trainTar) );
output = net(testZ2);

%accuracy = sum(testTar == round(output)) / numel(testTar)
confusionchart(testTar,round(output))

save('outputTRUE');

