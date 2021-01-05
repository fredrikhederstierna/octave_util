%
% Edge effect happens when the FFT filter runs past the end of the signal,
% and assumes the signal following samples are zero.
%
% Prefixing and appending the original signal with a small number (10-100)
% samples in the beginning and ending of the signal to avoid this effect.
%
% The vector is flipped and shifted in order to maintain continuity in
% signal level and slope at the joining points in both beginning and end.
%
% After filtering, the prefixed and the appended samples of the filtered
% signal are removed. Just crop off the last few elements, usually half
% the filter window width.
%
% Fredrik Hederstierna 2021
%
function [v N] = extrapolate (v, N)

  % limit to max 50% of signal
  Nv = size(v,1);
  N = min(floor(Nv * 0.5), N);

  % maintain continuity in signal level and slope
  v_first_val = v(1);
  v_first_flip = flipud(v(2 : N+1));
  v_pre = (2 * v_first_val) - v_first_flip;

  v_last_val = v(end);
  v_last_flip = flipud(v(end-N : end-1));
  v_post = (2 * v_last_val) - v_last_flip;

  % resulting vector is prefixed and appended
  v = [v_pre ; v ; v_post];

endfunction
