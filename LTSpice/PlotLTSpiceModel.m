close all

PATH_SHUNT = 'results_shunt.txt';
PATH_NO_SHUNT = 'results_no_shunt.txt';
D = struct;

A_shunt = readmatrix( PATH_SHUNT );

D.shunt.time = A_shunt(:,1);
D.shunt.V = A_shunt(:,2);
D.shunt.I = A_shunt(:,3);
D.shunt.I_inj = A_shunt(:,4);

A_no_shunt = readmatrix( PATH_NO_SHUNT );

D.no_shunt.time = A_no_shunt(:,1);
D.no_shunt.V = A_no_shunt(:,2);
D.no_shunt.I = A_no_shunt(:,3);
D.no_shunt.I_inj = A_no_shunt(:,4);

% Plot the results
axes = gobjects(2,1);

figure()
axes(1,1) = subplot(2,1,1);
plot(D.no_shunt.time,D.no_shunt.I*1e6,'LineWidth',2)
hold on
plot(D.no_shunt.time,D.no_shunt.I_inj*1e6,':','LineWidth',2);
ylabel('I injected [\mu A]')
title('No shunt resistor')
%text(0.01,0.95,'B','Units','normalized', 'FontWeight','bold')
ylim([-0.2,0.33])

axes(1,2) = subplot(2,1,2);
plot(D.shunt.time,D.shunt.I*1e6,'LineWidth',2)
hold on
plot(D.shunt.time,D.shunt.I_inj*1e6,':','LineWidth',2);
ylabel('I injected [\mu A]')
title('R_{shunt} = 400 k \Omega')
ylim([-0.2,0.33])
xlabel('time [s]')
%text(0.01,0.95,'C','Units','normalized', 'FontWeight','bold')

linkaxes(axes, 'xy')
set(gcf,'Color','w', 'Units', 'Inches', 'Position', [1,1,4,4.5])
saveas(gcf,'LTspice_current.png')

% Voltage
axes = gobjects(2,1);

figure()
axes(2,1) = subplot(2,1,1);
plot(D.no_shunt.time,D.no_shunt.V*1e3,'LineWidth',2);
ylabel('V active electrode [mV]')
xlabel('time [s]')
text(0.01,0.95,'C','Units','normalized', 'FontWeight','bold')


axes(2,2) = subplot(2,1,2);
plot(D.shunt.time,D.shunt.V*1e3,'LineWidth',2);
xlabel('time [s]')
ylabel('V active electrode [mV]')
text(0.01,0.95,'D','Units','normalized', 'FontWeight','bold')

linkaxes(axes, 'x')

%set(gcf,'Color','w', 'Units', 'Inches', 'Position', [1,1,8,4.5])
%saveas(gcf,'LTspice_voltage.png')



