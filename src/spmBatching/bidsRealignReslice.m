function bidsRealignReslice(opt)
    % bidsRealignReslice(opt)
    %
    % The scripts realigns the functional
    % Assumes that bidsSTC ha already been run

    %% TO DO
    % find a way to paralelize this over subjects

    % if input has no opt, load the opt.mat file
    if nargin < 1
        load('opt.mat');
        fprintf('opt.mat file loaded \n\n');
    end

    % load the subjects/Groups information and the task name
    [group, opt, BIDS] = getData(opt);

    % creates prefix to look for
    prefix = getPrefix('preprocess', opt);

    fprintf(1, 'DOING PREPROCESSING\n');

    %% Loop through the groups, subjects, and sessions
    for iGroup = 1:length(group)

        groupName = group(iGroup).name;

        for iSub = 1:group(iGroup).numSub

            matlabbatch = [];
            % Get the ID of the subject
            % (i.e SubNumber doesnt have to match the iSub if one subject
            % is exluded for any reason)
            subID = group(iGroup).subNumber{iSub}; % Get the subject ID

            printProcessingSubject(groupName, iSub, subID);

            % identify sessions for this subject
            [sessions, nbSessions] = getInfo(BIDS, subID, opt, 'Sessions');

            %% REALIGN
            fprintf(1, ' BUILDING SPATIAL JOB : REALIGN\n');

            sesCounter = 1;

            for iSes = 1:nbSessions  % For each session

                % get all runs for that subject across all sessions
                [runs, nbRuns] = getInfo(BIDS, subID, opt, 'Runs', sessions{iSes});

                for iRun = 1:nbRuns  % For each run

                    % get the filename for this bold run for this task
                    [fileName, subFuncDataDir] = getBoldFilename( ...
                        BIDS, ...
                        subID, sessions{iSes}, runs{iRun}, opt);

                    % check that the file with the right prefix exist
                    files = inputFileValidation(subFuncDataDir, prefix, fileName);

                    fprintf(1, ' %s\n', files{1});

                    matlabbatch{1}.spm.spatial.realign.estwrite.data{sesCounter} = ...
                        cellstr(files);

                    sesCounter = sesCounter + 1;

                end
            end

            matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = {''};

            % The following lines are commented out because those parameters
            % can be set in the spm_my_defaults.m
            % matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 1;
            % matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
            % matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
            % matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
            % matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
            % matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
            % matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
            % matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 3;
            % matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
            % matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;

            saveMatlabBatch(matlabbatch, 'RealignReslice', opt, subID);

            spm_jobman('run', matlabbatch);

        end
    end

end