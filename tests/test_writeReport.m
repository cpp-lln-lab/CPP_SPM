function test_suite = test_writeReport %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_writeReportBasic()

    opt.taskName = 'vismotion';
    opt.derivativesDir = fullfile(fileparts(mfilename('fullpath')), 'dummyData');

    writeReport(opt, 'stc');

end
