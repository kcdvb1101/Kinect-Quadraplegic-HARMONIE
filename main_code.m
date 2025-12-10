cd 'C:\Users\guy\Desktop\Segmentation_testing\blank\IR\'
blank_path = 'C:\Users\guy\Desktop\Segmentation_testing\blank\IR\';

blank_cell = cellstr(ls);
blank_cell(cellfun('isempty',strfind(blank_cell,'txt'))) = [];
blank_cell = strrep(blank_cell, '''', '');
cd ..;
cd ..;
cd 'spread apart/trial/IR';
trial_path = [pwd '\']; 
trial_cell = cellstr(ls);
trial_cell(cellfun('isempty',strfind(trial_cell,'txt'))) = [];
trial_cell = strrep(trial_cell, '''', '');
cd 'C:\Users\guy\Desktop\Segmentation_testing\export'

backgroundsubtractionseg(char(strcat(blank_path,blank_cell(1))),char(strcat(trial_path,trial_cell(1)))); 