% Calculation of circuit constants and overall dimensions in ReTRIna device.

close all
clear all
clc

%% Stimulation strategy
radius = 40e-6; % radius of electrode
h = 0;
PW = 4e-3;

area = calculate_area(radius, h);

Q_density = 20e-2; % C / m^2
Q_injected = area .* Q_density;
I_injected = Q_injected / PW;
disp(['Q injected = ', num2str(Q_injected, '%.2e'), ' C'])
disp(['I injected = ', num2str(I_injected, '%.2e'), ' A'])

plot(h, Q_injected)
ylabel('Injected charge (C)')
xlabel('Height (cm)')
yline(4e-9)
ylim([0,5e-9])

%% Circuit 
resistivity_saline = 68.9e-2; % Ohm m
Re = resistivity_saline / (4*radius);
Rf = 100e9;
Rshunt= 400e3;

Rload = 1 / (1/Rshunt + 1/(Rf+Re));

%% Shunt resistance
l = 49e-6;
resisitivity_conductor = 10e-2; % Ohm m
W = 20e-6; % choice of shunt width

thickness = linspace(1e-9, 10e-6, 1e7);
A = 2 * W .* thickness;
Rshunt_calc = resisitivity_conductor * l ./ A;

h = resisitivity_conductor*l / (W*Rshunt);
disp(h)

figure()
semilogy(thickness, Rshunt_calc)
yline(400e3)
xlabel('thickness (m)')
ylabel('Rshunt')
xlim([0,1e-6])

[m,ind] = min(abs(Rshunt_calc - Rshunt));
disp(thickness(ind))

%% Calculations Rtrack
resistivity_pedot = 10e-2;   % Ω.m, https://scholar.google.ch/scholar?q=PDOT:PSS+resistivity&hl=nl&as_sdt=0&as_vis=1&oi=scholart
height_pedot = 20e-6;       % m
Rtrack = resistivity_pedot * height_pedot / area;

%% Number of pixels
radius_of_curvature = 11e-3;
diameter_device = 5e-3;
perimeter = 2*pi*radius_of_curvature;
theta = 2*pi* diameter_device / perimeter / 2;

area_device = 2*pi*(radius_of_curvature^2)*(1-cos(theta)); % see wikipedia 'area of spherical cap'

nine_pixels_length = 535e-6;
nine_pixels_area = nine_pixels_length^2 * (sqrt(3)/4);
num_pixels = 9*area_device/nine_pixels_area;

%% Functions
function area = calculate_area(radius, h)
    area = (h .* 2*pi*radius + pi*(radius)^2);
end
