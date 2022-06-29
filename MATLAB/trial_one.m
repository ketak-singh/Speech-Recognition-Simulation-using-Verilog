clc
% Record your voice for 1 seconds.
recObj = audiorecorder;
disp('Start of Recording..');
recordblocking(recObj, 1);
disp('End of Recording..');
Fs = 8000;
% Store data in double-precision array.
y = getaudiodata(recObj);
Nsamps = length(y);
t = (1/Fs)*(1:Nsamps);          %Prepare time data for plot
y = y .* hamming(length(y));
y=highpass(y,200,Fs);
%Do Fourier Transform
y_fft = abs(fft(y));            %Retain Magnitude
y_fft = y_fft(1:Nsamps/4);      %Discard Half of Points
f = Fs*(0:Nsamps/4-1)/Nsamps;   %Prepare freq data for plot
y_fft= uint8(y_fft);
coeffs = mfcc(y,Fs);
feature =zeros(98:1);
for i=1:98
    for j=1:14
  feature(i)=+coeffs(i,j);
    end
    feature(i)=(feature(i)/14)*1000;
    feature(i)=round(abs(feature(i)));
end
feature=feature.';
%Plot Voice in Time Domain
subplot(2,1,1);plot(t, y)
xlim([0 1])
xlabel('Time (s)');ylabel('Amplitude');title('Human Voice')
%Plot Voice File in Frequency Domain
subplot(2,1,2);plot(f, y_fft)
xlim([0 1000]);ylim([0,50])
xlabel('Frequency (Hz)');ylabel('Amplitude')
title('Frequency Response of Human Voice')
  p=zeros(2:1);
  for i=1:97
      if(feature(i)~=0)
        p(1)=feature(i);
        p(2)=feature(i+1);
        p=dec2bin(p,8);
        break;
      end
  end 
fid=fopen('C:\Users\adima\Desktop\nine.txt','wt');
fprintf(fid, '%s', [ p.'; repmat(char(13), 1, size(p,1)) ] );
fclose(fid);