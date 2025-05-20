%%
mainpath = '/Users/jahidulislam/Downloads'; % Change to your local path
shapepath1 = sprintf('%s/data/province', mainpath); % Province border files
shapepath   = sprintf('%s/data/worldboundaries/World_Countries_shp',mainpath); %province border files
filename = '/Users/jahidulislam/GCHP/GCHP_146/Streched_grid_C60_Pullman_201907/OutputDir/GEOSChem.AerosolMass.20190701_0000z.nc4';
%filePath1 = '/Users/jahidulislam/Movies/output_gfed/GEOSChem.AerosolMass.20190701_0000z1.nc4';
% Read latitude, longitude, and PM2.5 data
% Step 2: Read corner_lats and corner_lons
corner_lats = ncread(filename, 'corner_lats');  % Replace 'corner_lats' with the exact variable name in the NetCDF file
corner_lons = ncread(filename, 'corner_lons');  % Replace 'corner_lons' with the exact variable name in the NetCDF file

% Step 3: Read PM25 variable (replace with the actual variable name if it's different)
PM25 = ncread(filename, 'PM25');  % Replace 'PM25' with the correct variable name
pm25_base1 = squeeze(PM25(:, :,6, 1));
corner_lats1=squeeze(corner_lats(:, :,6));
corner_lons1 = squeeze(corner_lons(:, :, 6));

% Check if any value is greater than 180 and modify it
corner_lons1(corner_lons1 > 180) = corner_lons1(corner_lons1 > 180)-360;


% Step 2: Initialize the new 60x60 data array
new_lat = zeros(60, 60);  % Preallocate a 60x60 matrix for the new data

% Step 3: Compute the average of the row and column neighbors for the new data
for i = 1:60
    for j = 1:60
        % Average of the corresponding row and column data
        new_lat(i, j) = (corner_lats1(i, j) + corner_lats1(i+1, j) + corner_lats1(i, j+1) + corner_lats1(i+1, j+1)) / 4;
    end
end
% Step 2: Initialize the new 60x60 data array
new_lon = zeros(60, 60);  % Preallocate a 60x60 matrix for the new data

% Step 3: Compute the average of the row and column neighbors for the new data
for i = 1:60
    for j = 1:60
        % Average of the corresponding row and column data
        new_lon(i, j) = (corner_lons1(i, j) + corner_lons1(i+1, j) + corner_lons1(i, j+1) + corner_lons1(i+1, j+1)) / 4;
    end
end

figure;
pcolor(new_lon,new_lat,pm25_base1);
shading interp;
colorbar;
t = title('PM2.5 Concentrations C60 with S2 at Base Level - July 2019');
x = xlabel('Longitude');
y = ylabel('Latitude');

set(t, 'FontSize', 40, 'FontWeight', 'bold');
set(x, 'FontSize', 18, 'FontWeight', 'bold');
set(y, 'FontSize', 18, 'FontWeight', 'bold');

ax = gca;
set(ax, 'FontSize', 16, 'FontWeight', 'bold'); % Adjust axis text size
caxis([0, 50]); % Adjust color limits
xlim([-165 -72]);
ylim([20 70]);
grid on;

% % Set axis properties to bold
% ax = gca;
% ax.FontSize = 12;
% ax.FontWeight = 'bold';

% Set colorbar properties to bold
cb = colorbar;
cb.Label.String = 'PM2.5 Concentration (\mug/m^3)';
cb.Label.FontWeight = 'bold';
cb.Label.FontSize = 16;
cb.FontWeight = 'bold';

% set(gca, 'FontSize', 12);
%colormap jet; % Use 'jet' colormap

grid on;

% Enhance visualization
grid on;
% Read province and state boundaries
S = shaperead(sprintf('%s/PROVINCE.SHP', shapepath1), 'UseGeoCoords', true); % Import province border files
states = shaperead('usastatehi', 'UseGeoCoords', true); % US states border files

% Show Canada province boundaries with enhanced visibility
for iii = 1:length(S)
    geoshow(flipud(S(iii).Lat), flipud(S(iii).Lon), 'DisplayType', 'polygon', ...
        'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.2); % Darker and thicker lines
end

% Show US state boundaries with enhanced visibility
for iii = 1:length(states)
    geoshow(flipud(states(iii).Lat), flipud(states(iii).Lon), 'DisplayType', 'polygon', ...
        'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.2); % Darker and thicker lines
end
% % % Read and plot country boundaries from the shapefile
 countries = shaperead(shapepath, 'UseGeoCoords', true);
 for k = 1:length(countries)
    geoshow(countries(k).Lat, countries(k).Lon, 'DisplayType', 'polygon', 'FaceColor', 'none', 'EdgeColor', 'black');
end

    colormap jetx; % pick a colar map
%%
mainpath = '/Users/jahidulislam/Downloads'; % Change to your local path
shapepath1 = sprintf('%s/data/province', mainpath); % Province border files
shapepath   = sprintf('%s/data/worldboundaries/World_Countries_shp',mainpath); % Country shapefile
filename = '/Users/jahidulislam/GCHP/GCHP_146/Streched_grid_C60_Pullman_201907/OutputDir/GEOSChem.AerosolMass.20190701_0000z.nc4';

% Read all data once
corner_lats = ncread(filename, 'corner_lats');  
corner_lons = ncread(filename, 'corner_lons');  
PM25 = ncread(filename, 'PM25');  

% Prepare figure
figure('Units', 'inches', 'Position', [1 1 6.25 3.27]);
hold on;

alpha_value = 0.3; % transparency for layering plots
colors = parula(6); % colormap with 6 distinct colors (not used directly with pcolor but just for reference)

for k = 1:6
    % Extract layer data
    pm25_layer = squeeze(PM25(:, :, k, 1));
    corner_lats1 = squeeze(corner_lats(:, :, k));
    corner_lons1 = squeeze(corner_lons(:, :, k));
    
    % Correct longitudes > 180
    corner_lons1(corner_lons1 > 180) = corner_lons1(corner_lons1 > 180) - 360;
    
    % Initialize averaged lat/lon arrays
    new_lat = zeros(60, 60);
    new_lon = zeros(60, 60);
    
    % Compute averages of corner points
    for i = 1:60
        for j = 1:60
            new_lat(i, j) = (corner_lats1(i, j) + corner_lats1(i+1, j) + corner_lats1(i, j+1) + corner_lats1(i+1, j+1)) / 4;
            new_lon(i, j) = (corner_lons1(i, j) + corner_lons1(i+1, j) + corner_lons1(i, j+1) + corner_lons1(i+1, j+1)) / 4;
        end
    end
    
    % Plot with pcolor
    h = pcolor(new_lon, new_lat, pm25_layer);
    shading interp;
    %set(h, 'FaceAlpha', alpha_value); % Set transparency to see overlapping layers
end

% Colorbar and labels (single colorbar for all layers)
cb = colorbar;
cb.Label.String = 'PM2.5 Concentration (\mug/m^3)';
cb.Label.FontWeight = 'bold';
cb.Label.FontSize = 16;
cb.FontWeight = 'bold';

title('PM2.5 Concentrations C60 with S2 at Base Level - July 2019', 'FontSize', 40, 'FontWeight', 'bold');
xlabel('Longitude', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Latitude', 'FontSize', 18, 'FontWeight', 'bold');

ax = gca;
set(ax, 'FontSize', 16, 'FontWeight', 'bold');
caxis([0, 100]); % Adjust color limits
xlim([-180 180]);
ylim([-90 90]);
grid on;

colormap jetx;

% Read province and state boundaries
S = shaperead(sprintf('%s/PROVINCE.SHP', shapepath1), 'UseGeoCoords', true);
states = shaperead('usastatehi', 'UseGeoCoords', true);
countries = shaperead(shapepath, 'UseGeoCoords', true);

% Overlay Canada province boundaries
for iii = 1:length(S)
    geoshow(flipud(S(iii).Lat), flipud(S(iii).Lon), 'DisplayType', 'polygon', ...
        'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.2);
end

% Overlay US state boundaries
for iii = 1:length(states)
    geoshow(flipud(states(iii).Lat), flipud(states(iii).Lon), 'DisplayType', 'polygon', ...
        'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.2);
end

% Overlay country boundaries
for k = 1:length(countries)
    geoshow(countries(k).Lat, countries(k).Lon, 'DisplayType', 'polygon', ...
        'FaceColor', 'none', 'EdgeColor', 'black');
end

hold off;
