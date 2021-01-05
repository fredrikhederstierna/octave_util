%
% Apply simple band-pass filter on a vector using FFT
%
% Fredrik Hederstierna 2021
%
function [v_filt spectrum_pre BPF spectrum_post] = fft_filter (v, v_rate_hz, bp_lo_freq_hz, bp_hi_freq_hz)

  % setup parameters
  dt = 1/v_rate_hz;
  Fs = 1/dt;
  N = size(v,1);
  dF = Fs/N;
  f = ((-Fs/2) : dF : (Fs/2-dF))';

  % setup Band-Pass filter
  BPF = ((bp_lo_freq_hz < abs(f)) & (abs(f) < bp_hi_freq_hz));

  % subtract mean (like DC component)
  sig_mean = mean(v);
  signal_pre_filt = v - sig_mean;

  % goto freq space (fft)
  spectrum_pre = fftshift( fft(signal_pre_filt) ) / N;

  % apply BP-filter
  spectrum_post = BPF .* spectrum_pre;

  % back from freq space (inverse fft)
  signal_post_filt = ifft( ifftshift(spectrum_post) ) * N;

  % add mean again
  signal_post_filt = signal_post_filt + sig_mean;

  % set returning filtered vector
  v_filt = signal_post_filt;

endfunction
