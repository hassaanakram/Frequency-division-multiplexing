function y = bpf21k(x)
%BPF21K Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.2 and the DSP System Toolbox 8.5.
% Generated on: 08-Jul-2020 11:58:27

%#codegen

% To generate C/C++ code from this function use the codegen command. Type
% 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    % % FIR Window Bandpass filter designed using the FIR1 function.
    %
    % % All frequency values are in Hz.
    % Fs = 48000;  % Sampling Frequency
    %
    % N    = 350;      % Order
    % Fc1  = 18100;    % First Cutoff Frequency
    % Fc2  = 23900;    % Second Cutoff Frequency
    % flag = 'scale';  % Sampling Flag
    % Beta = 0.5;      % Window Parameter
    % % Create the window vector for the design algorithm.
    % win = kaiser(N+1, Beta);
    %
    % % Calculate the coefficients using the FIR1 function.
    % b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
    
    Hd = dsp.FIRFilter( ...
        'Numerator', [0.00138844040372015 -0.000189728438785227 ...
        -0.000390606904356742 5.27715402592198e-18 0.00116433219239352 ...
        -0.00246079994903729 0.00316393418404912 -0.00287751712168983 ...
        0.00176519302890388 -0.000464483107012818 -0.000270921713839182 ...
        8.10202478092578e-17 0.00114951627949645 -0.00254636066887066 ...
        0.00340937743651046 -0.00325160010168236 0.00216243225044319 ...
        -0.000764569280653958 -0.000134243558099314 3.85672221790629e-17 ...
        0.001118684164963 -0.0026100993935586 0.00364087132089118 ...
        -0.00362886872391865 0.00257937556837497 -0.00109055906688246 ...
        2.03356568699042e-05 4.65916541216233e-17 0.00107019595669259 ...
        -0.00264896583231608 0.00385503132819077 -0.00400690354069803 ...
        0.00301531835278794 -0.00144319958070234 0.000193870444024741 ...
        4.68090579218491e-17 0.00100223033234551 -0.00265962380609246 ...
        0.00404823288246481 -0.00438322650313424 0.00346971354661452 ...
        -0.00182351488922997 0.000387632333838382 1.66424254278443e-17 ...
        0.000912714096085957 -0.00263835332289135 0.00421654943317256 ...
        -0.00475532238166676 0.00394227734799321 -0.00223294577038562 ...
        0.000603208291849127 8.35556747351104e-19 0.000799221421145109 ...
        -0.00258090789735532 0.00435565766920438 -0.00512066083127064 ...
        0.00443313226048659 -0.00267354447464696 0.00084263985479342 ...
        -4.19391999728474e-18 0.000658828272709446 -0.00248230533610481 ...
        0.00446069343785392 -0.00547671887605373 0.00494300553948178 ...
        -0.00314825170274535 0.00110862345177905 -9.25981956144585e-18 ...
        0.000487898871938975 -0.00233651715831949 0.00452603207966683 ...
        -0.00582100358138021 0.00547351235757342 -0.00366130012444022 ...
        0.0014048053448672 -3.20951387836463e-17 0.000281766144482351 ...
        -0.00213599917535462 0.00454494969038304 -0.00615107467773597 ...
        0.00602757287878192 -0.00421881899563856 0.00173622763851978 ...
        -3.64297859051204e-17 3.42413708831122e-05 -0.00187096498447881 ...
        0.00450909070540989 -0.00646456689932165 0.00661004875217414 ...
        -0.00482976998683286 0.00211002432572903 -3.61074473704962e-17 ...
        -0.000263161660605603 -0.00152822755746826 0.00440760842367777 ...
        -0.00675921180184826 0.00722875396971777 -0.00550745118697111 ...
        0.00253654862318548 -2.81079484267673e-17 -0.000622500543616763 ...
        -0.00108928301431372 0.0042257283282505 -0.0070328588282136 ...
        0.00789613488949814 -0.0062720230153522 0.00303128100391112 ...
        -9.34813031225409e-17 -0.0010615917328206 -0.000526994741386881 ...
        0.00394223795670107 -0.00728349539762646 0.00863221392560216 ...
        -0.00715497828696132 0.00361823398119379 -8.81113286842456e-17 ...
        -0.00160797790529637 0.0002004721257339 0.00352485008518901 ...
        -0.00750926580323221 0.00947008344661802 -0.00820757188608253 ...
        0.00433643443809785 -2.14243281380522e-18 -0.00230662860258737 ...
        0.00116154371683478 0.00292101054617223 -0.0077084887152984 ...
        0.0104669886150923 -0.00951802983496438 0.00525331263342013 ...
        -3.43311975071522e-17 -0.00323623494422982 0.0024767257959194 ...
        0.00203793111183155 -0.00787967310138279 0.0117290249013698 ...
        -0.0112504753581919 0.00649545050529385 -8.76557117330662e-17 ...
        -0.00454784753719729 0.0043800771267027 0.000693565918141615 ...
        -0.00802153239149684 0.0134740457090257 -0.013746110119353 ...
        0.00833020992503851 -2.58072617568911e-17 -0.00657219728782287 ...
        0.00739417041040297 -0.00152655054819157 -0.00813299673486631 ...
        0.016225815608526 -0.0178451185451075 0.011433919993563 ...
        -1.11916558844314e-17 -0.0101981305929291 0.0129716081102496 ...
        -0.00581670010462554 -0.00821322321530899 0.0216293969748358 ...
        -0.026312188685033 0.0181502615196363 -6.7183982802284e-17 ...
        -0.0189023738007417 0.027215791464727 -0.0176178365981902 ...
        -0.00826160391420832 0.0388576479333709 -0.0566660749542713 ...
        0.045829056174354 -6.89241126683879e-17 -0.0732554273730027 ...
        0.153899988169452 -0.21649348716217 0.240055380267176 -0.21649348716217 ...
        0.153899988169452 -0.0732554273730027 -6.89241126683879e-17 ...
        0.045829056174354 -0.0566660749542713 0.0388576479333709 ...
        -0.00826160391420832 -0.0176178365981902 0.027215791464727 ...
        -0.0189023738007417 -6.7183982802284e-17 0.0181502615196363 ...
        -0.026312188685033 0.0216293969748358 -0.00821322321530899 ...
        -0.00581670010462554 0.0129716081102496 -0.0101981305929291 ...
        -1.11916558844314e-17 0.011433919993563 -0.0178451185451075 ...
        0.016225815608526 -0.00813299673486631 -0.00152655054819157 ...
        0.00739417041040297 -0.00657219728782287 -2.58072617568911e-17 ...
        0.00833020992503851 -0.013746110119353 0.0134740457090257 ...
        -0.00802153239149684 0.000693565918141615 0.0043800771267027 ...
        -0.00454784753719729 -8.76557117330662e-17 0.00649545050529385 ...
        -0.0112504753581919 0.0117290249013698 -0.00787967310138279 ...
        0.00203793111183155 0.0024767257959194 -0.00323623494422982 ...
        -3.43311975071522e-17 0.00525331263342013 -0.00951802983496438 ...
        0.0104669886150923 -0.0077084887152984 0.00292101054617223 ...
        0.00116154371683478 -0.00230662860258737 -2.14243281380522e-18 ...
        0.00433643443809785 -0.00820757188608253 0.00947008344661802 ...
        -0.00750926580323221 0.00352485008518901 0.0002004721257339 ...
        -0.00160797790529637 -8.81113286842456e-17 0.00361823398119379 ...
        -0.00715497828696132 0.00863221392560216 -0.00728349539762646 ...
        0.00394223795670107 -0.000526994741386881 -0.0010615917328206 ...
        -9.34813031225409e-17 0.00303128100391112 -0.0062720230153522 ...
        0.00789613488949814 -0.0070328588282136 0.0042257283282505 ...
        -0.00108928301431372 -0.000622500543616763 -2.81079484267673e-17 ...
        0.00253654862318548 -0.00550745118697111 0.00722875396971777 ...
        -0.00675921180184826 0.00440760842367777 -0.00152822755746826 ...
        -0.000263161660605603 -3.61074473704962e-17 0.00211002432572903 ...
        -0.00482976998683286 0.00661004875217414 -0.00646456689932165 ...
        0.00450909070540989 -0.00187096498447881 3.42413708831122e-05 ...
        -3.64297859051204e-17 0.00173622763851978 -0.00421881899563856 ...
        0.00602757287878192 -0.00615107467773597 0.00454494969038304 ...
        -0.00213599917535462 0.000281766144482351 -3.20951387836463e-17 ...
        0.0014048053448672 -0.00366130012444022 0.00547351235757342 ...
        -0.00582100358138021 0.00452603207966683 -0.00233651715831949 ...
        0.000487898871938975 -9.25981956144585e-18 0.00110862345177905 ...
        -0.00314825170274535 0.00494300553948178 -0.00547671887605373 ...
        0.00446069343785392 -0.00248230533610481 0.000658828272709446 ...
        -4.19391999728474e-18 0.00084263985479342 -0.00267354447464696 ...
        0.00443313226048659 -0.00512066083127064 0.00435565766920438 ...
        -0.00258090789735532 0.000799221421145109 8.35556747351104e-19 ...
        0.000603208291849127 -0.00223294577038562 0.00394227734799321 ...
        -0.00475532238166676 0.00421654943317256 -0.00263835332289135 ...
        0.000912714096085957 1.66424254278443e-17 0.000387632333838382 ...
        -0.00182351488922997 0.00346971354661452 -0.00438322650313424 ...
        0.00404823288246481 -0.00265962380609246 0.00100223033234551 ...
        4.68090579218491e-17 0.000193870444024741 -0.00144319958070234 ...
        0.00301531835278794 -0.00400690354069803 0.00385503132819077 ...
        -0.00264896583231608 0.00107019595669259 4.65916541216233e-17 ...
        2.03356568699042e-05 -0.00109055906688246 0.00257937556837497 ...
        -0.00362886872391865 0.00364087132089118 -0.0026100993935586 ...
        0.001118684164963 3.85672221790629e-17 -0.000134243558099314 ...
        -0.000764569280653958 0.00216243225044319 -0.00325160010168236 ...
        0.00340937743651046 -0.00254636066887066 0.00114951627949645 ...
        8.10202478092578e-17 -0.000270921713839182 -0.000464483107012818 ...
        0.00176519302890388 -0.00287751712168983 0.00316393418404912 ...
        -0.00246079994903729 0.00116433219239352 5.27715402592198e-18 ...
        -0.000390606904356742 -0.000189728438785227 0.00138844040372015]);
end

y = step(Hd,x);


% [EOF]