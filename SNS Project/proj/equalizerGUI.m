function equalizerGUI
    % Create GUI figure
    fig = figure('Name', 'Audio Equalizer', 'Position', [100, 100, 800, 500], 'NumberTitle', 'off', 'MenuBar', 'none', 'Color', [0.8, 0.8, 0.8], 'CloseRequestFcn', @closeFigure);

   % Load the background image
backgroundImage = imread('project.jpg');  % Replace 'your_image.jpg' with the actual image file path

% Create an axes to hold the background image
axes('Parent', fig, 'Position', [0, 0, 1, 1]);

% Display the background image
imshow(backgroundImage);

    % UI components
    loadButton = uicontrol('Style', 'pushbutton', 'String', 'Load Audio', 'Position', [320, 450, 160, 40], 'Callback', @loadAudio, 'BackgroundColor', [0.2, 0.6, 0.8], 'ForegroundColor', [1, 1, 1]);
    playButton = uicontrol('Style', 'pushbutton', 'String', 'Play', 'Position', [480, 450, 160, 40], 'Callback', @playAudio, 'BackgroundColor', [0.2, 0.8, 0.2], 'ForegroundColor', [1, 1, 1], 'Enable', 'off');

    inputAxes = axes('Parent', fig, 'Position', [0.05, 0.2, 0.4, 0.2]);
    outputAxes = axes('Parent', fig, 'Position', [0.55, 0.2, 0.4, 0.2]);

    inputSpectrumAxes = axes('Parent', fig, 'Position', [0.05, 0.5, 0.4, 0.2]);
    outputSpectrumAxes = axes('Parent', fig, 'Position', [0.55, 0.5, 0.4, 0.2]);

    % Gain sliders
    slider1 = uicontrol('Style', 'slider', 'Min', 0, 'Max', 10, 'Value', 1, 'Position', [720, 400, 80, 30], 'Callback', @updateAudio);
    slider2 = uicontrol('Style', 'slider', 'Min', 0, 'Max', 10, 'Value', 1, 'Position', [720, 310, 80, 30], 'Callback', @updateAudio);
    slider3 = uicontrol('Style', 'slider', 'Min', 0, 'Max', 10, 'Value', 1, 'Position', [720, 230, 80, 30], 'Callback', @updateAudio);
    slider4 = uicontrol('Style', 'slider', 'Min', 0, 'Max', 10, 'Value', 1, 'Position', [720, 140, 80, 30], 'Callback', @updateAudio);
    slider5 = uicontrol('Style', 'slider', 'Min', 0, 'Max', 10, 'Value', 1, 'Position', [720, 40, 80, 30], 'Callback', @updateAudio);

  % Labels for filters (arranged in a column on the right)
label1 = uicontrol('Style', 'text', 'String', 'Filter 1', 'Position', [720, 370, 80, 30], 'HorizontalAlignment', 'center', 'BackgroundColor', 'none', 'ForegroundColor', [1, 1, 1]);
label2 = uicontrol('Style', 'text', 'String', 'Filter 2', 'Position', [720, 280, 80, 30], 'HorizontalAlignment', 'center', 'BackgroundColor', 'none', 'ForegroundColor', [1, 1, 1]);
label3 = uicontrol('Style', 'text', 'String', 'Filter 3', 'Position', [720, 190, 80, 30], 'HorizontalAlignment', 'center', 'BackgroundColor', 'none', 'ForegroundColor', [1, 1, 1]);
label4 = uicontrol('Style', 'text', 'String', 'Filter 4', 'Position', [720, 100, 80, 30], 'HorizontalAlignment', 'center', 'BackgroundColor', 'none', 'ForegroundColor', [1, 1, 1]);
label5 = uicontrol('Style', 'text', 'String', 'Filter 5', 'Position', [720, 10, 80, 30], 'HorizontalAlignment', 'center', 'BackgroundColor', 'none', 'ForegroundColor', [1, 1, 1]);



    % Initialize audio data
    audioLoaded = false;
    audio = [];
    player = [];
    Fs = 0; % Initialize Fs

    % Plot initial input and spectrum
    updatePlots(zeros(1, 1), 1, inputAxes, inputSpectrumAxes, 'Input');

    % Callback functions
    function loadAudio(~, ~)
        [filename, pathname] = uigetfile({'*.wav'; '*.mp3'}, 'Select Audio File');
        if isequal(filename, 0) || isequal(pathname, 0)
            return; % User canceled
        end
        filePath = fullfile(pathname, filename);
        [audio, Fs] = audioread(filePath);
        audioLoaded = true;
        updatePlots(audio, Fs, inputAxes, inputSpectrumAxes, 'Input');
        set(playButton, 'Enable', 'on'); % Enable play button after loading audio
        stopAudio(); % Stop audio if it's already playing
    end

    function updateAudio(~, ~)
        if ~audioLoaded
            return;
        end

        % Apply gain sliders
        gain1 = get(slider1, 'Value');
        gain2 = get(slider2, 'Value');
        gain3 = get(slider3, 'Value');
        gain4 = get(slider4, 'Value');
        gain5 = get(slider5, 'Value');

        % Apply gains to filters
        filtered1 = applyGain(filter1(), audio, gain1);
        filtered2 = applyGain(filter2(), audio, gain2);
        filtered3 = applyGain(filter3(), audio, gain3);
        filtered4 = applyGain(filter4(), audio, gain4);
        filtered5 = applyGain(filter5(), audio, gain5);

        % Plot output and spectrum
        updatePlots(filtered1, Fs, outputAxes, outputSpectrumAxes, 'Output');
        
        % Play the audio
        player = audioplayer(filtered1, Fs);
        play(player);
    end

    function playAudio(~, ~)
        if ~audioLoaded
            return;
        end

        % Stop audio if it's already playing
        stopAudio();

        % Apply gain sliders
        gain1 = get(slider1, 'Value');
        gain2 = get(slider2, 'Value');
        gain3 = get(slider3, 'Value');
        gain4 = get(slider4, 'Value');
        gain5 = get(slider5, 'Value');

        % Apply gains to filters
        filtered1 = applyGain(filter1(), audio, gain1);
        filtered2 = applyGain(filter2(), audio, gain2);
        filtered3 = applyGain(filter3(), audio, gain3);
        filtered4 = applyGain(filter4(), audio, gain4);
        filtered5 = applyGain(filter5(), audio, gain5);

        % Combine filtered signals
        combined = filtered1 + filtered2 + filtered3 + filtered4 + filtered5;

        % Play the audio
        player = audioplayer(combined, Fs);
        playblocking(player); % Wait for playback to finish before continuing
    end

    function stopAudio()
        % Stop audio playback if it's active
        if ~isempty(player) && isplaying(player)
            stop(player);
        end
    end

  function updatePlots(signal, fs, signalAxes, spectrumAxes, titleText)
    % Update time-domain plot
    t = (0:length(signal)-1) / fs;
    plot(signalAxes, t, signal, 'Color', [0.5, 0, 0]); % Dark red
    title(signalAxes, titleText);
    xlabel(signalAxes, 'Time (s)', 'Color', [1, 1, 1]); % Set label color to white
    ylabel(signalAxes, 'Amplitude', 'Color', [1, 1, 1]); % Set label color to white
    set(signalAxes, 'Color', 'none'); % Set the axis color to transparent
    set(signalAxes, 'XColor', [1, 1, 1], 'YColor', [1, 1, 1]); % Set axis values color to white

    % Update frequency-domain plot
    spectrum = abs(fft(signal));
    f = linspace(0, fs, length(spectrum));
    plot(spectrumAxes, f, 20*log10(spectrum), 'Color', [0, 0, 0.5]); % Dark blue
    title(spectrumAxes, [titleText ' Spectrum']);
    xlabel(spectrumAxes, 'Frequency (Hz)', 'Color', [1, 1, 1]); % Set label color to white
    ylabel(spectrumAxes, 'Magnitude (dB)', 'Color', [1, 1, 1]); % Set label color to white
    grid(spectrumAxes, 'on');
    set(spectrumAxes, 'Color', 'none'); % Set the axis color to transparent
    set(spectrumAxes, 'XColor', [1, 1, 1], 'YColor', [1, 1, 1]); % Set axis values color to white
end




    function y = applyGain(Hd, x, gain)
        % Apply gain to the filtered signal
        y = filter(Hd, x) * gain;
    end

    function closeFigure(~, ~)
        % Close the figure and stop audio
        stopAudio();
        delete(gcf);
    end
end

function Hd = filter1
    % Your filter1 design code here
    % Placeholder: Example lowpass filter
    Fs = 44100;
    Fc = 500;
    N = 4;
    h = fdesign.lowpass('N,Fc', N, Fc, Fs);
    Hd = design(h, 'butter');
end

function Hd = filter2
    % Your filter2 design code here
    % Placeholder: Example bandpass filter
    Fs = 44100;
    Fc1 = 1000;
    Fc2 = 2000;
    N = 4;
    h = fdesign.bandpass('N,Fc1,Fc2', N, Fc1, Fc2, Fs);
    Hd = design(h, 'butter');
end

function Hd = filter3
    % Your filter3 design code here
    % Placeholder: Example bandpass filter
    Fs = 44100;
    Fc1 = 200;
    Fc2 = 400;
    N = 4;
    h = fdesign.bandpass('N,Fc1,Fc2', N, Fc1, Fc2, Fs);
    Hd = design(h, 'butter');
end

function Hd = filter4
    % Your filter4 design code here
    % Placeholder: Example bandpass filter
    Fs = 44100;
    Fc1 = 500;
    Fc2 = 1000;
    N = 4;
    h = fdesign.bandpass('N,Fc1,Fc2', N, Fc1, Fc2, Fs);
    Hd = design(h, 'butter');
end

function Hd = filter5
    % Your filter5 design code here
    % Placeholder: Example highpass filter
    Fs = 44100;
    Fc = 20000;
    N = 4;
    h = fdesign.highpass('N,Fc', N, Fc, Fs);
    Hd = design(h, 'butter');
end
