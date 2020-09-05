folderToCover = fullfile(pwd, '..', 'src');

coverage = mocov( ...
    '-expression', @moxunit_runtests, ...
    '-verbose', ...
    '-cover', folderToCover, ....
    '-cover_xml_file', 'coverage.xml', ...
    '-cover_html_dir', 'coverage_html');