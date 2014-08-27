% Random Walk Simulator

%% Configuration

% The range that the direction of the motion can change with each update
% Currently assumes 2D Cartesian (Euclidean?) space, ie, 360 degrees of
% variation 
rangeAngleVaries = 16;

% Starting location
xStartLocation = 0;
yStartLocation = 0;

% Displacement (distance travelled?) on each updated
stepSizeMean = 1;
stepSizeSD = 4;
% stepSizeDistribution = Gaussian

% Number of steps per iTrial
nSteps = 100;

% Number of trials
nTrials = 1000;


%% Random walk function

% Define vectors to hold terminal xPosition and yPosition for each iTrial
xEndPosition = 1:nTrials;
yEndPosition = 1:nTrials;
stepSizes = 1:(nTrials * nSteps);

% Define vector to hold sample path 1
xSamplePath1 = 1:nSteps;
ySamplePath1 = 1:nSteps;
iSamplePath1 = randi(nTrials); % pick random trial to plot

% Define vector to hold sample path 2
xSamplePath2 = 1:nSteps;
ySamplePath2 = 1:nSteps;
iSamplePath2 = randi(nTrials); % pick random trial to plot. TODO Unique

for iTrial = 1:nTrials
    xPosition = xStartLocation;
    yPosition = yStartLocation;
    for jStep = 1:nSteps
        r = randi(rangeAngleVaries);
        theta = ((r - 1)/rangeAngleVaries) * 2 * pi; % compute direction
        stepSize = normrnd(stepSizeMean,stepSizeSD); % compute step size
        stepSizes(((iTrial - 1) * nSteps) + jStep) = stepSize; % insert
            % stepSize in vector of all stepSizes
        if iTrial == iSamplePath1
            xSamplePath1(jStep) = xPosition;
            ySamplePath1(jStep) = yPosition;
        end
        if iTrial == iSamplePath2
            xSamplePath2(jStep) = xPosition;
            ySamplePath2(jStep) = yPosition;
        end        
        xPosition = xPosition + (stepSize * cos(theta)); % compute x displacement
        yPosition = yPosition + (stepSize * sin(theta)); % compute y displacement 
    end 
    xEndPosition(iTrial) = xPosition; % insert iTrial end xPosition to vector of all end positions
    yEndPosition(iTrial) = yPosition; % insert iTrial end yPosition to vector of all end positions
end

%% Summary stats and scatter plot

distances = sqrt(xEndPosition.^2 + yEndPosition.^2);
meanDistance = mean(distances);

FigHandle = figure('color', 'w', 'Position', [100, 100, 1200, 800]); % set figure res to 1200x800

    % Display config summary stats
    subplot(2,3,1); % first subplot
    str(1) = {['Configuration']};    
    str(2) = {['Trials:', num2str(nTrials)]};
    str(3) = {['Steps per trial:', num2str(nSteps)]};
    str(4) = {['Step size: N(', num2str(stepSizeMean), ', ', num2str(stepSizeSD), ')']};
    str(5) = {['Angle options:' num2str(rangeAngleVaries)]};
    str(6) = {[' ']};    
    str(7) = {['Results']};    
    str(8) = {['Distance from start: M = ', num2str(meanDistance),...
        ', SD = ', num2str(std(distances))]};
    str(9) = {['End x position: M = ', num2str(mean(xEndPosition)),...
        ', SD = ', num2str(std(xEndPosition))]};
    str(10) = {['End y position: M = ', num2str(mean(yEndPosition)),...
        ', SD = ', num2str(std(yEndPosition))]};    
    str(11) = {['Step size: M = ', num2str(mean(stepSizes)),', SD = ', num2str(std(stepSizes))]};
    text(0,.7,str);axis off
    title('Summary');
   
    % Scatterplot of end positions   
    subplot(2,3,2); % second subplot
    s = (meanDistance/nTrials) * 1000; % marker size
    c = [0 0 0]; % marker color
    scatter(xEndPosition, yEndPosition, s, c, '.');
    title('End positions');

    % Histogram of end distances   
    subplot(2,3,3); % third subplot
    hist(distances);
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',[0 0 0],'EdgeColor','w')
    title('End distances');

    % Line graph of sample path   
    subplot(2,3,4); % fourth subplot
    plot(xSamplePath1, ySamplePath1, 'k', xSamplePath2, ySamplePath2, 'r');
    title('Two sample paths');   
    