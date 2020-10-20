% (C) Copyright 2019 CPP BIDS SPM-pipeline developpers

function matlabbatch = setBatchSelectAnat(matlabbatch, BIDS, opt, subID)
    % matlabbatch = setBatchSelectAnat(matlabbatch, BIDS, opt, subID)
    %

    anatType = opt.anatReference.type;
    anatSession = opt.anatReference.session;

    % get all anat images for that subject fo that type
    sessions = getInfo(BIDS, subID, opt, 'Sessions');
    anat = spm_BIDS(BIDS, 'data', ...
                    'sub', subID, ...
                    'ses', sessions{anatSession}, ...
                    'type', anatType);

    % TODO
    % We assume that the first anat of that type is the correct one
    % could be an issue for dataset with more than one anatomical of the same type
    anat = anat{1};
    anatImage = unzipImgAndReturnsFullpathName(anat);

    matlabbatch{end + 1}.cfg_basicio.cfg_named_file.name = 'Anatomical';
    matlabbatch{end}.cfg_basicio.cfg_named_file.files = { {anatImage} };

end