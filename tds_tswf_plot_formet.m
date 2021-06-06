function tds_tswf_plot_formet(data, index)
if ~exist('index', 'var')
    index = 1;
end
if ~exist('tofile', 'var')
    tofile = 0;
end
ep = data.Epoch.data;
time = ep(index);
tds_mode = convertCharsToStrings(data.TDS_CONFIG_LABEL.data(index, :));
% Pachenko's antenna angle
pacang = 132.2;
% RPW ANT in SRF 
V1=[0, 1];
% Geometric antenna
%V2=[0.81915204586197221, -0.57357643410459713]; 
%V3=[-0.81915204586197221, -0.57357643410459713]; 
% Pachenko antenna
V2=[sind(pacang), cosd(pacang)]; 
V3=[-sind(pacang), cosd(pacang)]; 
V2 = V2./norm(V2);
V3 = V3./norm(V3);
% XLD1 TDS mode
V1V3 = V1 - V3; V1V3 = V1V3/ norm(V1V3); %CH1
V2V1 = V2 - V1; V2V1 = V2V1/ norm(V2V1); %CH2
if contains(tds_mode, 'SE1')
% SE1 TDS mode
    M(1,:) = V1; %CH1
    M(2,:) = V2; %CH2
else 
    % construct transformation matrix ANT->SRF 
    M(1,:) = V1V3; % V1-V3
    M(2,:) = V2V1; % V2-V1
    % DIFF1 TDS mode is same
end
time = ep(index);
% load TDS TSWF data
% if it's at the OKF then use find_file
nsamp = double(data.SAMPS_PER_CH.data(index));
fs = data.SAMPLING_RATE.data(index);
tvec = (0:nsamp-1) / fs * 1e3;
ww = data.WAVEFORM_DATA.data(:,1:nsamp,index);
% projection: E = MAT(ANT->SRF) * V; where MAT(2,2) and V is observed field 
M = inv(M);
E = M*ww(1:2,:) * 1e3; % transformation into SRF (Y-Z)
E0 = ww(1:2,:) * 1e3;
   subplot(2, 1, 1); 
   plot(tvec, E(1,:), 'LineWidth', 2.);
   xlim([tvec(1) tvec(end)]);
   hold on
   plot(tvec, E(2,:), 'LineWidth', 2.);
   hold off
   legend('E_Y','E_Z');
   ylabel('E field (mV/m)');
   xlabel(sprintf('Time in ms after %s', datestr(time, 31)));
   title(sprintf('SolO RPW/TDS Survey Snapshot %i', index));
   set(gca,'FontSize', 16);
   subplot(2, 1, 2)
   [pyy, fq] = pwelch(E(1,:), nsamp/4, nsamp/8, [], data.SAMPLING_RATE.data(index));
   [pzz, fq] = pwelch(E(2,:), nsamp/4, nsamp/8, [], data.SAMPLING_RATE.data(index));

   ii = find(fq < 8e4);
   semilogy(fq(ii), pyy(ii), 'LineWidth', 2.);
   hold on
   semilogy(fq(ii), pzz(ii), 'LineWidth', 2.);
   hold off
   ylabel('PSD (mV^2/m^2/Hz)');
   xlabel('Frequency (Hz)');
   set(gca,'FontSize', 16);
end
