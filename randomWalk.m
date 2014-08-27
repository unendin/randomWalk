% Random Walk Simulator

%% Configuration

% The range that the direction of the motion can change with each update
% Currently assumes 2D Cartesian (Euclidean?) space, ie, 360 degrees of
% variation 
rangeAngleVaries = 180;

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

for iTrial = 1:nTrials
    xPosition = xStartLocation;
    yPosition = yStartLocation;
    for jStep = 1:nSteps
        r = randi(rangeAngleVaries);
        theta = ((r - 1)/rangeAngleVaries) * 2 * pi; % compute direction
        stepSize = normrnd(stepSizeMean,stepSizeSD); % compute step size
        stepSizes(((iTrial - 1) * nSteps) + jStep) = stepSize; % insert
            % stepSize in vector of all stepSizes
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
    str(1) = {['Steps:', num2str(nSteps),'. Trials:', num2str(nTrials),...
        '. Angles:' num2str(rangeAngleVaries), '.']};
    str(2) = {['Distance walked: M = ', num2str(meanDistance),...
        ', SD = ', num2str(std(distances))]};
    str(3) = {['End x position: M = ', num2str(mean(xEndPosition)),...
        ', SD = ', num2str(std(xEndPosition))]};
    str(4) = {['End y position: M = ', num2str(mean(yEndPosition)),...
        ', SD = ', num2str(std(yEndPosition))]};    
    str(5) = {['Step size: M = ', num2str(mean(stepSizes)),', SD = ', num2str(std(stepSizes))]};
    text(0,.8,str);axis off
    
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
