function [selected_numbers]=selection_frames(a,b,f)


step=ceil( (b-a)/f);
selected_numbers = a:step:b; 
num_remaining = f - length(selected_numbers);

if num_remaining > 0
    all_numbers = setdiff(a:b, selected_numbers);
    remaining_numbers = datasample(all_numbers, num_remaining, 'Replace', false);
    selected_numbers = sort([selected_numbers remaining_numbers]);
end
