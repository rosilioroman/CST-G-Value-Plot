%% G Functions and Signal_Model.m Code for the Moving Charged Particle
% AUTHOR: Austin M Smith and Abraham Jaet
% IMPACT-LASP
close all 
clear
clc

%% Converting Raw CST.txt Files to One Array With All Data
clear, clc

main_path = 'CST_Data_V4'; % folder containing the files
og_files = dir([main_path '/*']);
actual_files = og_files(3:length(og_files)); % skipping the first two folders which are '.', '..' and contain no data

CST_output = []; % every data point (row), columns: [object, x, y, z, V]
for k = 1:length(actual_files) % goes through each z folder (Ex. z = 0,6,12,..)
    folderpath = [main_path '/' actual_files(k).name];
    folder     = dir([folderpath '/*.txt']);

    % pulling the z values from the names of the folders
    z_val = actual_files(k).name;
    z_num = str2double(z_val);

    for i = 1:height(folder) % going through each file within each folder (Ex. ANT1, SC, ANT2,...)
        filename = [folderpath '/' folder(i).name];

        data_file = [];
        data_table = readtable(filename, 'Delimiter', '	', 'VariableNamingRule','preserve');

        data_table.Properties.VariableNames = {'Var1', 'Var2'};
        data_col1 = data_table.Var1;
        data_col2 = data_table.Var2;

        % fixing the issue if there are only 2 data points
        if iscell(data_col1)
            data_col1 = str2double(data_table.Var1);
        end

        data_file(1:height(data_col1), 1) = data_col1;
        data_file(1:height(data_col2), 2) = data_col2;

        % making changes for the new automatic simulation style, pulling the y vals
        data_name  = readtable(filename, 'Delimiter', "=", 'VariableNamingRule', 'preserve');
        if width(data_name) > 1
            data_t = data_name(:,2);
            data_a = table2array(data_t);
            data_c = NaN([length(data_a) 1]);
            if iscell(data_a) % stops the issue if there is only one y value
                for row = 1:length(data_a)
                    datap = strsplit(data_a{row,1}, ')');
                    datar = str2double(datap{1,1});
                    data_c(row) = datar;
                end
            end
            first_row_cell = data_t.Properties.VariableNames;
            f_r            = strsplit(first_row_cell{1,1}, ')');
            first_row      = str2double(f_r{1,1});
            y_vals = [first_row; data_c];
        end

        % pulling the object names
        object_namer = strsplit(filename, '/');
        object_name  = strsplit(object_namer{1,3}, '.');
        object       = object_name{1,1};

        if strcmp(object, 'ANT1') == 1
            object = 1;
        elseif strcmp(object, 'ANT2') == 1 
            object = 2;
        elseif strcmp(object, 'ANT3') == 1 
            object = 3;
        elseif strcmp(object, 'ANT4') == 1 
            object = 4;
        elseif strcmp(object, 'SC') == 1 
            object = 0;
        else
            object = 'ERROR';
        end

        data_folder = NaN([height(data_file) 5]);
        for data = 1:height(data_file)
            data_folder(data,1)             = object;
            data_folder(data,2)             = data_file(data,1);
            data_folder(1:height(y_vals),3) = y_vals;
            data_folder(1:data,4)           = z_num;
            data_folder(data,5)             = data_file(data,2)/2; % divided by two to cancel the symmetry effects
        end

        % sets the y-values up correctly (since they are only defined at
        % the first experiment it sets all the ones after to it equal until
        % y changes again)
        for row = 1:height(data_folder)
            if isnan(data_folder(row, 3))
                data_folder(row,3) = data_folder(row-1,3);
            end
        end

        CST_output(end+1:end+height(data_folder), :) = data_folder; 
    end
end

CST_V4 = CST_output;
for row = 1:height(CST_V4)
    if isnan(CST_V4(row, 2))
        CST_V4(row,:) = NaN;
    end

    if CST_V4(row, 1) == 0 && CST_V4(row, 5) == 0
        CST_V4(row,:) = NaN;
    end
end

% getting rid of repeat values
[~, ia] = unique(CST_V4(:, 1:4), 'rows', 'stable');
CST_data = CST_V4(ia, :);

% making sure all the values do not have random decimal places
CST_data(:,1:4) = round(CST_data(:,1:4),2);

% removing NaN's
non_NaN_rows = find(~isnan(CST_data(:,1)));
CST_data = CST_data(non_NaN_rows,1:5);

% save('CST_data.mat','CST_data')


%% Plotting V Potential Values
clear, clc
load("CST_data.mat")

% seperating the data based on the object (ANT1, ANT2, ANT3, ANT4, SC) into smaller arrays
[~,~,oi] = unique(CST_data(:,1), 'rows');
seperated_data = arrayfun(@(x) CST_data(oi==x,:), unique(oi), 'UniformOutput', 0);

SC_data   = seperated_data(1,:,:);
ANT1_data = seperated_data(2,:,:);
ANT2_data = seperated_data(3,:,:);
ANT3_data = seperated_data(4,:,:);
ANT4_data = seperated_data(5,:,:);

V_SC   = SC_data{:}(:,2:5);
V_ANT1 = ANT1_data{:}(:,2:5);
V_ANT2 = ANT2_data{:}(:,2:5);
V_ANT3 = ANT3_data{:}(:,2:5);
V_ANT4 = ANT4_data{:}(:,2:5);

X_0 = V_SC(:,1);   Y_0 = V_SC(:,2);   Z_0 = V_SC(:,3);   V_0 = V_SC(:,4);
X_1 = V_ANT1(:,1); Y_1 = V_ANT1(:,2); Z_1 = V_ANT1(:,3); V_1 = V_ANT1(:,4);
X_2 = V_ANT2(:,1); Y_2 = V_ANT2(:,2); Z_2 = V_ANT2(:,3); V_2 = V_ANT2(:,4);
X_3 = V_ANT3(:,1); Y_3 = V_ANT3(:,2); Z_3 = V_ANT3(:,3); V_3 = V_ANT3(:,4);
X_4 = V_ANT4(:,1); Y_4 = V_ANT4(:,2); Z_4 = V_ANT4(:,3); V_4 = V_ANT4(:,4);


%% Finding the G-Values
Q_test = 1e-10; % C of "point" charge

% inputting the grounded capacitance matrices from CST Studio
% Format:
% [SC-SC ...                             SC-ANT4;
%  ANT1-SC ANT1-ANT1 ANT1-ANT2 ANT1-ANT3 ANT1-ANT4; 
%  ANT2-SC ...                           ANT2-ANT4;
%  ...                                            ;
%  ...                                   ANT4-ANT4]

cap_matrix_1 = [1.181302e-11 -1.214110e-12 -1.213814e-12 -1.213960e-12 -1.213958e-12;
                -1.21411e-12 3.145912e-12 -7.329293e-14 -2.685904e-14 -7.329455e-14;
                -1.213814e-12 -7.329293e-14 3.145215e-12 -7.328081e-14 -2.685234e-14;
                -1.213960e-12 -2.685904e-14 -7.328081e-14 3.145390e-12 -7.327984e-14;
                -1.213958e-12 -7.329455e-14 -2.685234e-14 -7.327984e-14 3.145176e-12];

cap_matrix_2 = [1.181342e-11 -1.213891e-12 -1.214367e-12 -1.214158e-12 -1.214028e-12;
                -1.213891e-12 3.145372e-12 -7.329294e-14 -2.685777e-14 -7.329149e-14;
                -1.214367e-12 -7.329294e-14 3.145701e-12 -7.330090e-14 -2.685831e-14;
                -1.214158e-12 -2.685777e-14 -7.330090e-14 3.145756e-12 -7.329941e-14;
                -1.214028e-12 -7.329149e-14 -2.685831e-14 -7.329941e-14 3.145527e-12];

cap_matrix_3 = [1.172459e-11 -1.229417e-12 -1.227060e-12 -1.227220e-12 -1.226450e-12;
                -1.229417e-12 3.132915e-12 -7.683583e-14 -2.988283e-14 -7.679279e-14; 
                -1.227060e-12 -7.683583e-14  3.128642e-12 -7.675580e-14 -2.982875e-14; 
                -1.227220e-12 -2.988283e-14 -7.675580e-14  3.128887e-12 -7.671201e-14; 
                -1.226450e-12 -7.679279e-14 -2.982875e-14 -7.671201e-14  3.127004e-12];

cap_matrix_4 = [1.151919e-11 -1.255774e-12 -1.255190e-12 -1.255094e-12 -1.256065e-12;
                -1.255774e-12 3.092912e-12 -8.512406e-14 -3.776918e-14 -8.512667e-14;
                -1.255190e-12 -8.512406e-14 3.097969e-12 -8.517712e-14 -3.778491e-14;
                -1.255094e-12 -3.776918e-14 -8.517712e-14 3.097730e-12 -8.514359e-14;
                -1.256065e-12 -8.512667e-14 -3.778491e-14 -8.514359e-14 3.093646e-12];

cst_cap_matrix = (cap_matrix_3 + cap_matrix_2 + cap_matrix_1 + cap_matrix_4)/4;

shen_cap_matrix = [52 -6.5 -6.5 -6.5 -6.5;
                   -6.5 16 0 0 0;
                   -6.5 0 17 0 0;
                   -6.5 0 0 19 0;
                   -6.5 0 0 0 16.5]*10^-12;

sorted_CST = sortrows(CST_data,[2 3 4 1]);

G_data = []; % formats the data [x,y,z,G_SC,G_ANT1,G_ANT2,G_ANT3,G_ANT4]
for i = 1:height(sorted_CST)/5
    g_matrix = (1/Q_test)*cst_cap_matrix*sorted_CST(5*i-4:5*i,5);
    coord    = sorted_CST(5*i,2:4);
    G_data(end+1,1:8) = [coord g_matrix']; 
end


%% Hard Coding Contact Points
% SC Contact Points (Internal)
xyz_lin1 = linspace(0,7.6,39); % 39 in order to get spacing of 0.2 between points
[x_c1,y_c1,z_c1] = ndgrid(xyz_lin1,xyz_lin1,xyz_lin1);
xyz_c1 = [x_c1(:),y_c1(:),z_c1(:)];

xyzG_c1 = [xyz_c1 NaN([length(xyz_c1) 5])];
for i = 1:length(xyz_c1)
    if sqrt(xyz_c1(i,1)^2 + xyz_c1(i,2)^2 + xyz_c1(i,3)^2) < 7.62
         xyzG_c1(i,4:8) = [1 0 0 0 0];
    end
end
xyzG_c1(isnan(xyzG_c1(:,4)), :) = [];

% ANT 1 Contact Points (Internal)
x_lin2 = linspace(8,27.2,((27.2-8)/0.2)+2);
y_lin2 = 0; z_lin2 = 0;
[x_c2,y_c2,z_c2] = ndgrid(x_lin2,y_lin2,z_lin2);
xyzG_c2 = [x_c2(:),y_c2(:),z_c2(:),zeros([length(x_c2) 1]),ones([length(x_c2) 1]),zeros([length(x_c2) 1]),zeros([length(x_c2) 1]),zeros([length(x_c2) 1])];

% ANT 4 Contact Points (Internal)
y_lin3 = linspace(8,27.2,((27.2-8)/0.2)+2);
x_lin3 = 0; z_lin3 = 0;
[x_c3,y_c3,z_c3] = ndgrid(x_lin3,y_lin3,z_lin3);
xyzG_c3 = [x_c3(:),y_c3(:),z_c3(:),zeros([length(x_c3) 1]),zeros([length(x_c3) 1]),zeros([length(x_c3) 1]),zeros([length(x_c3) 1]),ones([length(x_c3) 1])];

% Edge of SC Contact Points (External)
r_sat_vals = 7.6:0.01:7.62;
xyzG_c4 = [];
for r = 1:length(r_sat_vals)
    theta = linspace(0,pi/2,501);
    phi = linspace(0,pi/2,501);
    for i = 1:length(theta)
        for j = 1:length(phi)
            x_temp = r_sat_vals(r)*cos(theta(i))*sin(phi(j));
            y_temp = r_sat_vals(r)*sin(theta(i))*sin(phi(j));
            z_temp = r_sat_vals(r)*cos(phi(j));
    
            xyzG_c4(end+1, 1:8) = [x_temp y_temp z_temp 1 0 0 0 0];
    
        end
    end
end

% Edge of ANT 1 Contact Points (External)
x_ANT1_edged = 7.65:0.01:34.96;
xyzG_c5 = [];
for i = 1:length(x_ANT1_edged)
    z_ANT1_edged = 0:0.01:0.08;
    for j = 1:length(z_ANT1_edged)
        y_ANT1_edged = sqrt(0.08^2 - z_ANT1_edged(j)^2);
        xyzG_c5(end+1, 1:8) = [x_ANT1_edged(i) y_ANT1_edged z_ANT1_edged(j) 0 1 0 0 0];
    end
end

% Edge of ANT 4 Contact Points (External)
y_ANT4_edged = 7.65:0.01:34.96;
xyzG_c6 = [];
for i = 1:length(y_ANT4_edged)
    z_ANT4_edged = 0:0.01:0.08;
    for j = 1:length(z_ANT4_edged)
        x_ANT4_edged = sqrt(0.08^2 - z_ANT4_edged(j)^2);
        xyzG_c6(end+1, 1:8) = [x_ANT4_edged y_ANT4_edged(i) z_ANT4_edged(j) 0 0 0 0 1];
    end
end

G_contact = [xyzG_c1; xyzG_c2; xyzG_c3; xyzG_c4; xyzG_c5; xyzG_c6];

% getting rid of repeat values
[~, iG_cont] = unique(G_contact(:,1:3), 'rows', 'stable');
G_contact = G_contact(iG_cont, :);

%%
figure
scatter3(G_contact(:,1),G_contact(:,2),G_contact(:,3),2,G_contact(:,4))
set(gca,'XLim',[0 48],'YLim',[0 48],'ZLim',[0 48])
xlabel('x (cm)')
ylabel('y (cm)')
zlabel('z (cm)')
colormap("jet");
h = colorbar;
ylabel(h,'Voltage (V)')
title('Voltage Induced on the Modeled Spacecraft')

G_data = [G_data; G_contact];
G_data(:,1:3) = round(G_data(:,1:3), 2);


%% Interpolating the ZONES
% Defining the Zones 
% ZONE 1: x,y,z = (0:6:48) cm (everywhere by 6)
% ZONE 2: x,y = (0:3:36), z = (0:3:12) cm (close to the antenna plane by 3)
% ZONE 3: x,y,z = (0:1:9) cm (around the SC)
% ZONE 4: x = (9:3:36), y,z = (0:0.2:3) cm (along ANT 1)
% ZONE 5: x,z = (0:0.2:3), y = (9:3:36) cm (along ANT 4)

% ZONE 1
[int_X, int_Y, int_Z] = meshgrid(0:6:48);
[Xq,Yq,Zq] = meshgrid(0:3:48);
XYZG_SC1   = int_plus_contact(G_data, int_X, int_Y, int_Z, Xq, Yq, Zq, 4); % object_num is 4,5,6,7, or 8 corresponding to SC, ANT1, ANT2, ...
XYZG_ANT11 = int_plus_contact(G_data, int_X, int_Y, int_Z, Xq, Yq, Zq, 5);
XYZG_ANT21 = int_plus_contact(G_data, int_X, int_Y, int_Z, Xq, Yq, Zq, 6);
XYZG_ANT31 = int_plus_contact(G_data, int_X, int_Y, int_Z, Xq, Yq, Zq, 7);
XYZG_ANT41 = int_plus_contact(G_data, int_X, int_Y, int_Z, Xq, Yq, Zq, 8);

% ZONE 2
[int_X2, int_Y2, int_Z2] = meshgrid(0:3:36,0:3:36,0:3:12);
[Xq2,Yq2,Zq2] = meshgrid(0:1:36,0:1:36,0:1:12);
XYZG_SC2   = int_plus_contact(G_data, int_X2, int_Y2, int_Z2, Xq2, Yq2, Zq2, 4);
XYZG_ANT12 = int_plus_contact(G_data, int_X2, int_Y2, int_Z2, Xq2, Yq2, Zq2, 5);
XYZG_ANT22 = int_plus_contact(G_data, int_X2, int_Y2, int_Z2, Xq2, Yq2, Zq2, 6);
XYZG_ANT32 = int_plus_contact(G_data, int_X2, int_Y2, int_Z2, Xq2, Yq2, Zq2, 7);
XYZG_ANT42 = int_plus_contact(G_data, int_X2, int_Y2, int_Z2, Xq2, Yq2, Zq2, 8);

% ZONE 3
[int_X3, int_Y3, int_Z3] = meshgrid(0:1:9,0:1:9,0:1:9);
[Xq3,Yq3,Zq3] = meshgrid(0:0.1:9,0:0.1:9,0:0.1:9);
XYZG_SC3   = int_plus_contact(G_data, int_X3, int_Y3, int_Z3, Xq3, Yq3, Zq3, 4);
XYZG_ANT13 = int_plus_contact(G_data, int_X3, int_Y3, int_Z3, Xq3, Yq3, Zq3, 5);
XYZG_ANT23 = int_plus_contact(G_data, int_X3, int_Y3, int_Z3, Xq3, Yq3, Zq3, 6);
XYZG_ANT33 = int_plus_contact(G_data, int_X3, int_Y3, int_Z3, Xq3, Yq3, Zq3, 7);
XYZG_ANT43 = int_plus_contact(G_data, int_X3, int_Y3, int_Z3, Xq3, Yq3, Zq3, 8);

% ZONE 4
[int_X4, int_Y4, int_Z4] = meshgrid(9:3:36,0:0.2:3,0:0.2:3);
[Xq4,Yq4,Zq4] = meshgrid(9:0.1:36,0:0.1:3,0:0.1:3);
XYZG_SC4   = int_plus_contact(G_data, int_X4, int_Y4, int_Z4, Xq4, Yq4, Zq4, 4);
XYZG_ANT14 = int_plus_contact(G_data, int_X4, int_Y4, int_Z4, Xq4, Yq4, Zq4, 5);
XYZG_ANT24 = int_plus_contact(G_data, int_X4, int_Y4, int_Z4, Xq4, Yq4, Zq4, 6);
XYZG_ANT34 = int_plus_contact(G_data, int_X4, int_Y4, int_Z4, Xq4, Yq4, Zq4, 7);
XYZG_ANT44 = int_plus_contact(G_data, int_X4, int_Y4, int_Z4, Xq4, Yq4, Zq4, 8);

% ZONE 5
[int_X5, int_Y5, int_Z5] = meshgrid(0:0.2:3,9:3:36,0:0.2:3);
[Xq5,Yq5,Zq5] = meshgrid(0:0.1:3,9:1:36,0:0.1:3);
XYZG_SC5   = int_plus_contact(G_data, int_X5, int_Y5, int_Z5, Xq5, Yq5, Zq5, 4);
XYZG_ANT15 = int_plus_contact(G_data, int_X5, int_Y5, int_Z5, Xq5, Yq5, Zq5, 5);
XYZG_ANT25 = int_plus_contact(G_data, int_X5, int_Y5, int_Z5, Xq5, Yq5, Zq5, 6);
XYZG_ANT35 = int_plus_contact(G_data, int_X5, int_Y5, int_Z5, Xq5, Yq5, Zq5, 7);
XYZG_ANT45 = int_plus_contact(G_data, int_X5, int_Y5, int_Z5, Xq5, Yq5, Zq5, 8);


%% Consolidating G-Values for Each Object by Piecewise Combining the ZONES
% G_SC_contact   = G_contact(:,1:4);
% G_ANT1_contact = G_contact;
% G_ANT1_contact(:,[4, 6, 7, 8]) = [];
% G_ANT2_contact = G_contact;
% G_ANT2_contact(:,[4, 5, 7, 8]) = [];
% G_ANT3_contact = G_contact;
% G_ANT3_contact(:,[4, 5, 6, 8]) = [];
% G_ANT4_contact = G_contact;
% G_ANT4_contact(:,[4, 5, 6, 7]) = [];

% Desired Output:
% G_SC   = [x y z G]
% G_ANT1 = [x y z G]
% ... 
G_SC   = combo_piece_G(XYZG_SC1,XYZG_SC2,XYZG_SC3,XYZG_SC4,XYZG_SC5);
G_ANT1 = combo_piece_G(XYZG_ANT11,XYZG_ANT12,XYZG_ANT13,XYZG_ANT14,XYZG_ANT15);
G_ANT2 = combo_piece_G(XYZG_ANT21,XYZG_ANT22,XYZG_ANT23,XYZG_ANT24,XYZG_ANT25);
G_ANT3 = combo_piece_G(XYZG_ANT31,XYZG_ANT32,XYZG_ANT33,XYZG_ANT34,XYZG_ANT35);
G_ANT4 = combo_piece_G(XYZG_ANT41,XYZG_ANT42,XYZG_ANT43,XYZG_ANT44,XYZG_ANT45);

save('G_fixed_intpcon.mat','G_SC','G_ANT1','G_ANT2','G_ANT3','G_ANT4')

% figure 
% scatter3(G_SC(:,1),G_SC(:,2),G_SC(:,3),2,G_SC(:,4))
% set(gca,'XLim',[0 48],'YLim',[0 48],'ZLim',[-48 48])
% xlabel('x (cm)')
% ylabel('y (cm)')
% zlabel('z (cm)')
% colormap("jet");
% h = colorbar;
% ylabel(h,'Voltage (V)')
% title('Voltage Induced on the Modeled Spacecraft')


%% Interpolation for the Particle's Path
clear
% clearvars -except G_SC G_ANT1 G_ANT2 G_ANT3 G_ANT4
load('G_fixed_intpcon.mat')

x_domain = G_SC(:,1);
y_domain = G_SC(:,2);
z_domain = G_SC(:,3);

% x_domain = G_data_pm(:,1);
% y_domain = G_data_pm(:,2);
% z_domain = G_data_pm(:,3);

F_SC   = scatteredInterpolant(x_domain,y_domain,z_domain,G_SC(:,4),'linear','nearest');
F_ANT1 = scatteredInterpolant(x_domain,y_domain,z_domain,G_ANT1(:,4),'linear','nearest');
F_ANT2 = scatteredInterpolant(x_domain,y_domain,z_domain,G_ANT2(:,4),'linear','nearest');
F_ANT3 = scatteredInterpolant(x_domain,y_domain,z_domain,G_ANT3(:,4),'linear','nearest');
F_ANT4 = scatteredInterpolant(x_domain,y_domain,z_domain,G_ANT4(:,4),'linear','nearest');

save("F_fixed_intpcon_linpnear.mat","F_SC","F_ANT1","F_ANT2","F_ANT3","F_ANT4")


%% Functions
function XYZGqp = int_plus_contact(coord_extra,mesh_X,mesh_Y,mesh_Z,Xq,Yq,Zq,object_num) % object_num 4:8 (SC, ANT1, ANT2, ANT3, ANT4)
    [lf,wf,hf] = size(mesh_X);
    col_X = reshape(mesh_X, [lf*wf*hf 1]);
    col_Y = reshape(mesh_Y, [lf*wf*hf 1]);
    col_Z = reshape(mesh_Z, [lf*wf*hf 1]);
    test_zone = [col_X col_Y col_Z];
    test_zone = round(test_zone,2);

    li = ismember(coord_extra(:,1:3),test_zone,"rows");
    zone = coord_extra(li,:);

    % testing for missing points
    li_anti = ~ismember(test_zone,zone(:,1:3),"rows");
    [~, li_b] = ismember(test_zone,zone(:,1:3),"rows");
    xyz = test_zone(li_anti,:);

    G_zone = test_zone;
    for i = 1:length(test_zone)
        % touching the spacecraft: G_SC = 1 & G_ANT# = 0
        if sqrt(test_zone(i,1)^2 + test_zone(i,2)^2 + test_zone(i,3)^2) <= 7.62
            G_zone(i,4:8) = [1 0 0 0 0];
        % touching ANT 1
        elseif (sqrt(test_zone(i,2)^2 + test_zone(i,3)^2)) <= 0.08 && ((test_zone(i,1) < 35.23))
            G_zone(i,4:8) = [0 1 0 0 0];
        % touching ANT 4
        elseif (sqrt(test_zone(i,1)^2 + test_zone(i,3)^2)) <= 0.08 && ((test_zone(i,2) < 35.23))
            G_zone(i,4:8) = [0 0 0 0 1];
        elseif li_b(i) ~= 0 
            G_zone(i,4:8) = zone(li_b(i),4:8); 
        end
    end

    G = reshape(G_zone(:,object_num),size(mesh_X));
    Gq = interp3(mesh_X,mesh_Y,mesh_Z,G,Xq,Yq,Zq,'makima'); 

    Xqp = reshape(Xq, [numel(Xq) 1]);
    Yqp = reshape(Yq, [numel(Yq) 1]);
    Zqp = reshape(Zq, [numel(Zq) 1]);
    Gqp = reshape(Gq, [numel(Xqp) 1]);

    XYZGqp = [Xqp Yqp Zqp Gqp];
end

function G_combined = combo_piece_G(XYZG_obj1,XYZG_obj2,XYZG_obj3,XYZG_obj4,XYZG_obj5)
    % re-including the contact points
    % G_obj_init0 = G_touch;
    
    % (1) initalize the matrix to be all the data from ZONE 3, 4, 5 (should only have a couple points of overlap)
    G_obj_init1 = [XYZG_obj3; XYZG_obj4; XYZG_obj5];
    
    % getting rid of repeat values
    [~, iG] = unique(G_obj_init1(:, 1:3), 'rows', 'stable');
    G_obj_init2 = G_obj_init1(iG, :);
    
    % making sure all the values do not have random very small errors
    G_obj_init2(:,1:3) = round(G_obj_init2(:,1:3),2);
    XYZG_obj2(:,1:3) = round(XYZG_obj2(:,1:3),2);
    XYZG_obj1(:,1:3) = round(XYZG_obj1(:,1:3),2);
    
    % (2) create a test that sees which values in ZONE 2 are not in the int matrix and put those in
    li_G_obj = ~ismember(XYZG_obj2(:,1:3),G_obj_init2(:,1:3),"rows");
    
    G_obj_init3 = [G_obj_init2; XYZG_obj2(li_G_obj,:)];
    
    % (3) repeat step (2) with ZONE 1
    li_G_obj2 = ~ismember(XYZG_obj1(:,1:3),G_obj_init3(:,1:3),"rows");
    
    G_combined = [G_obj_init3; XYZG_obj1(li_G_obj2,:)];
    
    % correcting the negative G values (caused by the interpolation between points of 0)
    G_combined(G_combined(:,4) < 0, 4) = 0;

    % correcting values greater than 1
    G_combined(G_combined(:,4) > 1, 4) = 1;
end
