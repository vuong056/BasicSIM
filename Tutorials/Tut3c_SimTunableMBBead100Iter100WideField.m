run("../CIRLSetup.m")
run("SimTunableBead100Setup.m");
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableBead100.mat";
load(CIRLDataPath + "/Results/201909222309_SimTunableGWFBead/201909222309_SimTunableGWFBead.mat", 'retVars');
initGuess = retVars{7};

%% run RunReconstruction
numIt = 100;
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;
picIn = 20;    % picture every 5 interations
RunReconstruction(...
            'savemat',          1,  ...
            'u',                um, ...
            'uc',               uc, ...
            'X' ,               X , ...
            'Y' ,               Y , ...
            'Z' ,               Z , ...
            'Nphi',             length(phi), ...
            'Nthe',             length(theta), ...
            'phi',              phi, ...
            'theta',            theta, ...
            'w',                wm, ...
            'dXY',              dXY, ...
            'dZ',               dZ, ...
            'psfParam',         psfpar, ...
            'reconVars',        {"numIt"}, ...
            'reconVals',        {numIt}, ...
            'dataFile',         matFile, ...
            'psfFunction',      @PSFAgard, ...
            'psfArgs',          {"X", "Z", "dXY", "dZ"}, ...
            'patternFunction',  @PatternTunable3DNSlits, ...
            'patternArgs',      {"X", "Y", "Z", "u", "w", "dXY", "dZ", "phi", "offs", "theta", phizDeg, Nslits},...
            'reconFunction',    @GradientDescent, ...
            'reconArgs',        {@ForwardModel, ...
                                 @CostFunction, ...
                                 @Gradient, ...
                                 @StepSize, ...
                                 "g", "h", "im", "jm", "numIt" ,...
                                 5e-20 , initGuess, -1, picIn},...
            ...
            'reportFolder',     CIRLReportPath,...
            'reportFile',       "SimTunableMBBead100Iter100.tex")
