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
stepSizeSD = 1.5;
% stepSizeDistribution = Gaussian

% Time and step interval per trial
tTrial = 150;
stepIntervalMean = 1;
stepIntervalSD = 5;

% Number of trials
nTrials = 800;


%% Random walk functions

% Choose two sample paths
iSamplePath1 = randi(nTrials); % pick random trial to plot
iSamplePath2 = randi(nTrials); % pick random trial to plot. TODO Unique

% Initialize cross-trial step counter 
nStepsTotal = 0

% Initialize vectors
stepIntervalArray = [];
nStepsArray = [];
stepSizeArray = [];
xSamplePath1 = [];
ySamplePath1 = [];
xSamplePath2 = [];
ySamplePath2 = [];
xEndPosition = [];
yEndPosition = [];

for iTrial = 1:nTrials
    xPosition = xStartLocation;
    yPosition = yStartLocation;

    % Calculate step intervals and number of steps
    tPassed = 0; % reset
    nSteps = 0; % reset
    while tPassed < tTrial
        stepInterval = normrnd(stepIntervalMean,stepIntervalSD); % compute step interval
        nSteps = nSteps + 1;
        tPassed = tPassed + stepInterval;
        stepIntervalArray(nSteps) = stepInterval;
    end
    
    nStepsArray(iTrial) = nSteps; % record nSteps for current trial
    
    for jStep = 1:nSteps
        r = randi(rangeAngleVaries);
        theta = ((r - 1)/rangeAngleVaries) * 2 * pi; % compute direction
        stepSize = normrnd(stepSizeMean,stepSizeSD); % compute step size
        stepSizeArray(nStepsTotal + jStep) = stepSize; % insert
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
    nStepsTotal = nStepsTotal + nSteps; % add to step counter
end

%% Summary stats and scatter plot

distances = sqrt(xEndPosition.^2 + yEndPosition.^2);
meanDistance = mean(distances);

FigHandle = figure('color', 'w', 'Position', [100, 100, 1200, 800]); % set figure res to 1200x800

    % Display config summary stats
    subplot(2,3,1); % first subplot
    str(1) = {['Configuration']};    
    str(2) = {['Trials:', num2str(nTrials)]};
    str(3) = {['Time per trial:', num2str(tTrial)]};
    str(4) = {['Step interval: N(', num2str(stepIntervalMean), ', ', num2str(stepIntervalSD), ')']};
    str(5) = {['Step size: N(', num2str(stepSizeMean), ', ', num2str(stepSizeSD), ')']};
    str(6) = {['Angle options:' num2str(rangeAngleVaries)]};
    str(7) = {[' ']};    
    str(8) = {['Results']};    
    str(9) = {['Translation distance: M = ', num2str(meanDistance),...
        ', SD = ', num2str(std(distances))]};
    str(10) = {['End x position: M = ', num2str(mean(xEndPosition)),...
        ', SD = ', num2str(std(xEndPosition))]};
    str(11) = {['End y position: M = ', num2str(mean(yEndPosition)),...
        ', SD = ', num2str(std(yEndPosition))]};
    str(12) = {['Steps per trial: M = ', num2str(mean(nStepsArray)),', SD = ', num2str(std(nStepsArray))]};
    str(13) = {['Step size: M = ', num2str(mean(stepSizeArray)),', SD = ', num2str(std(stepSizeArray))]};
    text(0,.7,str);axis off
    title('Summary');
   
    % Scatterplot of end positions   
    subplot(2,3,2); % second subplot
    s = (meanDistance/sqrt(nTrials)) * 40; % marker size
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
    
    % Line graph of sample path   
    subplot(2,3,5); % fifth subplot
    scatter(nStepsArray, distances, s, c, '.');
    h = lsline;
    set(h,'color','r');
    title('Relation between number of steps and translation distance'); 
    
    
    