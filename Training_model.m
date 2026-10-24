clc; clear; close all;
yp(1)=0; yp(2)=0;
u=rands(1, 301)*2;

for k=2:301
    yp(k+1)=(yp(k)*(yp(k-1)+2)*(yp(k)+2.5))/((8.5+yp(k)^2+yp(k-1)^2)+u(k));
    out(k-1)=(yp(k+1)-u(k))/20;
    in(k-1)=yp(k)/20;
end;

plantin=[in(1:299); in(2:300)]; plantout=out(1:299);

net=newff(minmax(plantin),[1 10 1],{'tansig','tansig','tansig'},'trainlm','learngdm','mse')

net=init(net);
net.iw{1,1}
net.b{1}

net.trainParam.epochs = 500;
net.trainParam.goal = 0.0005;

net=train(net,plantin,plantout);

trainedout=sim(net,plantin);

plot(plantout, 'b'); %actual plan output
hold on;
plot(trainedout,':k'); %trained neuran network output
grid;
axis([0, 300, -0.1, 0.3]);
xlabel('Time step'); ylabel('Plant (solid) NN output (dotted)')

%trying NN with different inupt patterns

yp(1)=0.0; yp(2)=0.0;out1(1)=0; out1(2)=0;
for k=2:500
  if (k <= 200) 
    u(k)=2.0*cos(2*pi*k*0.01);
  else
    u(k)=1.2*sin(2*pi*k*0.05);
  end;
  yp(k+1)=yp(k)*(yp(k-1)+2)*(yp(k)+2.5)/(8.5+yp(k)^2+yp(k-1)^2)+u(k);
  out1(k)=yp(k)/20;
  out1(k-1)=yp(k-1)/20;
  nnout(k+1)=20*sim(net, [out1(k);out1(k-1)])+u(k);
end;

figure;

plot(yp, 'b');
hold on;
plot(nnout, ':k');
grid;
axis([0,500,-4.0,10.0]);
xlabel('Time Step'); ylabel('Plant (solid) NN Output (dotted)');