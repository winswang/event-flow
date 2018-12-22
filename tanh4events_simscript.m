clear all;
num = 300;
t_lin = linspace(0,1,num);
sig_log = sin(20*t_lin)./t_lin;
sig_log_min = min(sig_log);sig_log_max = max(sig_log);
sig_log = (sig_log - sig_log_min+1e-2)/(sig_log_max - sig_log_min)*2;

figure(1);
ax_fac = 4;
subplot(3,1,1);
sig_exp = exp(sig_log);

plot(t_lin, sig_exp,'linewidth',2,'color','k');
ax_limits1 = [0,max(t_lin), max(0,min(sig_exp)), max(sig_exp)*1.2];
axis(ax_limits1);
ax_ratio1 = [1, ax_fac*(ax_limits1(4)-ax_limits1(3))/(ax_limits1(2)-ax_limits1(1)),1];
daspect(ax_ratio1);
xlabel('Time');
ylabel('Intensity');

% subplot(3,1,3)
% plot(t_lin,sig_log,'linewidth',2,'color','y');
% xlabel('Time');
% ylabel('log(I)');

% log change
sig_delta = conv(sig_log,[1,-1],'valid');
t_delta = t_lin; t_delta(1) = [];
epsilon = 5e-3;
sig_delta_neg = sig_delta <= -epsilon;
sig_delta_pos = sig_delta >= epsilon;
t_dvs_idx = 1:2:num;
t_dvs = t_lin(t_dvs_idx);
sig_dvs_neg = sig_delta_neg(t_dvs_idx);
sig_dvs_pos = sig_delta_pos(t_dvs_idx);
 
sig_dvs_nzero_idx = sig_dvs_neg ~= 0;
t_dvs_neg = t_dvs(sig_dvs_nzero_idx);
sig_dvs_neg_short = sig_dvs_neg(sig_dvs_nzero_idx);
sig_dvs_pzero_idx = sig_dvs_pos ~= 0;
t_dvs_pos = t_dvs(sig_dvs_pzero_idx);
sig_dvs_pos_short = sig_dvs_pos(sig_dvs_pzero_idx);
 

subplot(3,1,3)
aspect_ratio_2 = [1,10,1];
plot(t_delta, 10*sig_delta,'.y');
hold on
stem(t_dvs_neg,-sig_dvs_neg_short,'.b');
stem(t_dvs_pos,sig_dvs_pos_short,'.r');
ax_limits2 = [0,max(t_lin), -1.2, 1.2];
axis(ax_limits2);
ax_ratio2 = [1, ax_fac*(ax_limits2(4)-ax_limits2(3))/(ax_limits2(2)-ax_limits2(1)),1];
daspect(ax_ratio2);

xlabel('Time');
ylabel('Events');