% Calculations of strain and stress in the ReTRIna device,
% including the position of the neutral plane.

close all
clear all

%% Define the material properties

R = 11e-3; % radius of curvature in m

M = struct;

M.pi.E = 2.1e9;                  % Chen and Iroh, 1999
M.pi.max_strain = 0.029;         % http://www.matweb.com/search/DataSheet.aspx?MatGUID=ab35b368ab9c40848f545c35bdf1a672
M.pi.ultimate_strength = 82e6;   % Chen and Iroh, 1999
M.pi.c = [255,140,0] / 255;

M.pl.E = 1.8e9;                  % chen et al., 2007
M.pl.max_strain = 0.025;         % http://www.matweb.com/search/DataSheet.aspx?MatGUID=718d010d3cbf4d2297de0c9d6be5459e
M.pl.ultimate_strength = 55e6;   % chen et al., 2007
M.pl.c = [255,192,203] / 255;

M.au.E = 70e9;                   % Wu et al (2005). Mechanical properties of ultrahigh-strength gold nanowires
M.au.max_strain = 1e-3;          % http://www.matweb.com/search/DataSheet.aspx?MatGUID=b9639c2f4ed84006923b2956f90cc13c
M.au.ultimate_strength = 3.5e9;  % Wu et al (2005). Mechanical properties of ultrahigh-strength gold nanowires
M.au.c = [255,255,0] / 255;

M.cr.E = 279e9;                  % Janda and Stefan (1984). Intrinsic stress in chromium thin films measured by a Novel method. Thin Solid Films, v112, issue 2, pp127-137. 
M.cr.max_strain = 0.0026;        % Pa http://www.matweb.com/search/DataSheet.aspx?MatGUID=25ce9b7f40364cf79d54ed0db5c8e41f (based on max stress = 360 MPa)
M.cr.ultimate_strength = 200e6;  % Brankovic and Stanko
M.cr.c = [122,122,122] / 255;

M.pdot.E = 2.6e9;                % Qu et al. (2015). Stiffness, strength and adhesion characterization of electrochemically deposited conjugated polymer films. Acta Biomater.
M.pdot.max_strain = 0.02;        % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4728054/
M.pdot.ultimate_strength = 56e6; % Qu et al. (2015). Stiffness, strength and adhesion characterization of electrochemically deposited conjugated polymer films. Acta Biomater.
M.pdot.c = [0,255,0] / 255;

M.si.E = 60e9;                   % Gleskova and Wagner 2001
M.si.max_strain = 0.0125;        % https://aip.scitation.org/doi/10.1063/1.5117282
M.si.ultimate_strength = 2e9;    % Gaspar et al 2010
M.si.c = [0,0,255] / 255;

M.dlc.E = 759e9;                  % Cho et al. (2005). Young's modulus, Poisson's ratio and failure properties of tetrahedral amorphous diamond-like carbon for MEMS devices. J. Micromech. Microeng. 15 728.  
M.dlc.max_strain = 0.03;          % https://www.cambridge.org/core/journals/journal-of-materials-research/article/abs/substrateindependent-stressstrain-behavior-of-diamondlike-carbon-thin-films-by-nanoindentation-with-a-spherical-tip/AC08D778BEF6C8A14DA5B0156FD3D7DE
M.dlc.ultimate_strength = 7.3e9;  % Cho et al. (2005). Young's modulus, Poisson's ratio and failure properties of tetrahedral amorphous diamond-like carbon for MEMS devices. J. Micromech. Microeng. 15 728.
M.dlc.c = [0,0,0] / 255;

%% Define the layers of the device
L = struct();

L(13).m = 'pi';
L(13).t = 23e-6;     % m

L(12).m = 'dlc';
L(12).t = 1e-6;     % m

L(11).m = 'pi';
L(11).t = 1e-6;     % m

L(10).m = 'cr';
L(10).t = 5e-9;      % m

L(9).m = 'au';
L(9).t = 100e-9;    % m

L(8).m = 'cr';
L(8).t = 5e-9;      % m

L(7).m = 'si';
L(7).t = 100e-9;     % m 

L(6).m = 'cr';
L(6).t = 5e-9;     % m

L(5).m = 'au';
L(5).t = 100e-9;    % m

L(4).m = 'cr';
L(4).t = 5e-9;     % m

% L(4).m = 'iro';
% L(4).t = 2.4e-6;

L(3).m = 'pl';
L(3).t = 24e-6;     % m

L(2).m = 'pdot';
L(2).t = 300e-9;     % m

L(1).m = 'pl';
L(1).t = 1e-6;     % m

%% Calculate the position of the neutral plane
% zn = numinator / denominator
numinator = 0;
denominator = 0;
bottom_layer = 0;
top_layer_array = zeros(1,length(L));
bottom_layer_array = zeros(1,length(L));
figure()
for i = 1:length(L)
    m = L(i).m;    % layer material
    t = L(i).t;    % layer thickness
    
    z_bar = bottom_layer + t / 2;
    numinator = numinator + M.(m).E * t * z_bar;
    denominator = denominator + M.(m).E * t;
    
    % increment bottom layer
    L(i).bottom = bottom_layer;
    L(i).top = bottom_layer + t;
    bottom_layer = bottom_layer + t;
    
    % Plot and output
    fill([0 0 1 1], [L(i).bottom, L(i).top, L(i).top, L(i).bottom], M.(m).c)
    hold on
    disp([m, ': bottom = ', num2str(L(i).bottom), ', top = ',  num2str(L(i).top)])
    
end
set(gcf,'Color','w', 'Units', 'Inches', 'Position', [1,1,5,5])
ylabel('Thickness (m)')
title('Device stack')

z_n = numinator / denominator;
yline(z_n, '--r', 'Linewidth', 2)

disp(' ');
disp(['Neutral plane: ', num2str(z_n)])
disp(['At ', num2str(z_n/bottom_layer), '% of device stack'])

%% Calculate strain and stress
disp(' ')
for i = 1:length(L)
    m = L(i).m;
    % Evaluate where the maximal strain will be (at top or at bottom)
    if abs(L(i).top-z_n) >= abs(L(i).bottom-z_n)
        z_i = L(i).top;
    else
        z_i = L(i).bottom;
    end
    L(i).strain = (z_i - z_n) / R;
    L(i).stress = M.(m).E * L(i).strain;
    disp(['layer ', num2str(i), '(',m,'), strain = ', num2str(100*L(i).strain), '%, stress = ', num2str(L(i).stress,'%.2e')])
end

%% Make a table
% find max strains in device
materials = fields(M);
max_strain_device = zeros(1, length(materials));
max_stress_device = zeros(1, length(materials));
max_strain_yield = zeros(1, length(materials));
max_stress_yield = zeros(1, length(materials));
youngs_modulus = zeros(1, length(materials));

for i = 1:length(materials)
    m = materials{i};
    max_strain = 0;
    max_stress = 0;
    % loop through layers and find max strain
    for j = 1:length(L)
        if isequal(L(j).m,m) && abs(L(j).strain) > abs(max_strain)
            max_strain = L(j).strain;
        end
        if isequal(L(j).m,m) && abs(L(j).stress) > abs(max_stress)
            max_stress = L(j).stress;
        end
    end
    max_strain_device(i) = max_strain;
    max_stress_device(i) = max_stress;
    max_strain_yield(i) = M.(m).max_strain;
    max_stress_yield(i) = M.(m).ultimate_strength;
    youngs_modulus(i) = M.(m).E;
end

too_large_strain = (abs(max_strain_device) > max_strain_yield/3);
T_strain = table(materials, 100*max_strain_device', 100*max_strain_yield', too_large_strain', ...
          'VariableNames', {'Material', 'Max strain in device', 'Max yield', 'Strain too large?'});

too_large_stress = (abs(max_stress_device) > max_stress_yield/3);
[sorted, ind] = sort(abs(max_stress_device));      
T_stress = table(materials(ind), (1e-9)*youngs_modulus', abs((1e-6)*max_stress_device(ind))', (1e-6)*max_stress_yield(ind)', too_large_stress(ind)', ...
          'VariableNames', {'Material', 'Elastic modulus (GPa)', '|Max stress in device| (MPa)', 'Ultimate strength (MPa)', 'Stress too large?'});

writetable(T_stress,'./maximum_stress.csv');
