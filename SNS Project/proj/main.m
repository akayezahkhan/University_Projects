% Load audio file
audioFilePath = 'C:\semester\smooth-ac-guitar-loop-93bpm-137706.wav';
[audio, Fs] = audioread(audioFilePath);

% Design filters
filter1Obj = filter1();
filter2Obj = filter2();
filter3Obj = filter3();
filter4Obj = filter4();
filter5Obj = filter5();

% Apply filters
filtered1 = applyFilter(filter1Obj, audio);
filtered2 = applyFilter(filter2Obj, audio);
filtered3 = applyFilter(filter3Obj, audio);
filtered4 = applyFilter(filter4Obj, audio);
filtered5 = applyFilter(filter5Obj, audio);

% Combine filtered signals
combined = filtered1 + filtered2 + filtered3 + filtered4 + filtered5;

% Plot input and output signals
figure;

subplot(2, 1, 1);
plot((1:length(audio))/Fs, audio, 'b');
xlabel('Time (s)');
title('Input Audio');

subplot(2, 1, 2);
plot((1:length(combined))/Fs, combined, 'r');
xlabel('Time (s)');
title('Output Audio');

% Play original audio
sound(audio, Fs);

% Play combined filtered audio
sound(combined, Fs);

% Function to apply filter
function output = applyFilter(filterObj, input)
    output = filter(filterObj, input);
end
