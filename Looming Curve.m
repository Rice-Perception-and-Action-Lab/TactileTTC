
prompt1 = 'enter the value of time ';
T = input(prompt1);
prompt2 = 'enter the value of distance ';
r = input(prompt2);
v = r./T;
t = 0:0.001:T;
tmax = t(end);

I0 = (r-v*(t-0.001)).^(-1);
I1 = (r - v*(tmax-0.001)).^(-1);
STDI = I0./I1 .* 25500;
k =STDI/I0

plot (t,STDI)
xlabel('Time Elapsed(s)');
ylabel('Intensity(a.u.)');
set(gcf,'color','white');
legend(['speed = ' num2str(v),'m/s','  distance = ' num2str(r),'m']);
set(gca,'fontsize',14)
title('Intensity as Function of Time for Rectilinear Approach')
ylim([0 255]);
%xlim([0 T])