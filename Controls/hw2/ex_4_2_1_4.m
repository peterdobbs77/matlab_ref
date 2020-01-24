tau = .1; ks = 7; kr = 0.8;
ramp = 10; P.pulseMag = 10; duration = 1;

upuls = [P.pulseMag*(ones(P.pulseWidth,1)); zeros(length(t)-P.pulseWidth,1)];