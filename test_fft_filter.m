%
% FFT test program
% Fredrik Hederstierna 2021
%

v = [-66,-66,-66,-61,-61,-61,-61,-42,-42,-42,-10,-10,-10,-10,25,25,25,57,57,57,82,82,82,82,96,96,96,103,103,103,97,97,97,97,81,81,81,57,57,57,57,34,34,34,10,10,10,-11,-11,-11,-11,-26,-26,-26,-40,-40,-40,-51,-51,-51,-51,-63,-63,-63,-73,-73,-73,-81,-81,-81,-81,-86,-86,-86,-87,-87,-87,-87,-86,-86,-86,-80,-80,-80,-72,-72,-72,-72,-63,-63,-63,-51,-51,-51,-37,-37,-37,-37,-17,-17,-17,1,1,1,1,19,19,19,33,33,33,43,43,43,43,49,49,49,53,53,53,51,51,51,51,46,46,46,42,42,42,42,41,41,41,38,38,38,36,36,36,36,33,33,33,31,31,31,28,28,28,28,27,27,27,24,24,24,24,22,22,22,22,22,22,20,20,20,20,19,19,19,18,18,18,16,16,16,16,15,15,15,13,13,13,13,12,12,12,11,11,11,8,8,8,8,6,6,6,5,5,5,3,3,3,3,2,2,2,0]';

figure(1);

N = size(v,1);
v_rate_hz = 200;
time = (1/v_rate_hz)*(0:N-1)';

subplot(3,3,1);
plot(time,v);
title('original signal')
grid on;

% extra polate

extra_points = 50;
[ev eN] = extrapolate(v, extra_points);
etime = (1/v_rate_hz)*(0:(N+(2*eN))-1)';

subplot(3,3,2);
plot(etime, ev);
title('padded signal')
grid on;

% fft filter

bp_lo_freq_hz = 0.1;
bp_hi_freq_hz = 10;
[ev_filt spectrum_pre BPF spectrum_post] = fft_filter(ev, v_rate_hz, bp_lo_freq_hz, bp_hi_freq_hz);

subplot(3,3,5);
plot(etime, ev_filt);
title('filtered padded signal')
grid on;

% plot spectrum

Fs = v_rate_hz;
dt = 1/Fs;
Ns = N+(2*eN);
dF = Fs/Ns;
f = ((-Fs/2) : dF : (Fs/2-dF))';
t = dt*(0:Ns-1)';

subplot(3,3,9);
plot(f,BPF);
title('BP-filter')
grid on;

subplot(3,3,3);
plot(f,abs(spectrum_pre));
title('Spectrum original')
grid on;

subplot(3,3,6);
plot(f,abs(spectrum_post));
title('Spectrum filtered')
grid on;

% remove extra polation

v_filt = ev_filt(eN+1 : end-eN, :);
subplot(3,3,4);
plot(time, v_filt);
% overlay original signal
%hold on
%plot(time, v);
%hold off
title('cropped filtered signal')
grid on;

% diff

v_diff = v - v_filt;
subplot(3,3,7);
plot(time,v_diff);
title('diff original and filtered signals')
grid on;
