% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Math 464 Linear Programming Project: Pugs n' Mugs Coffee and Kitchen.       %
%                                                                             %
% This code is for educational purposes only and is not for any other use,    %
% quotation, or distribution without written consent of the author.           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Function 'ww_format' transforms a given m employee by n workweek-hour matrix
% into a standard workweek (ww) table form with 24 columns ranging from hour
% 01:00 to 24:00. Every 7 rows represents an employee's daily schedule.
%
% Author: J.U. Davasligil
% Version: 2020-04-13 (ISO 8601)
%
% INPUTS:
%
%    A    An m employee by n workweek-hour matrix.
%
% OUTPUT: 
%
%    At   A workweek formatted table.

function At = ww_format(A)

m = rows(A);
n = columns(A);

if n != 168
	return
end

At = zeros(7*m,24);

k = 0;
for i = 1:(7*m)
	j = mod(i-1,7) + 1;
	if j == 1
		k = k + 1;
	end
	At(i,:) = A(k,(1+(j-1)*24):(j*24));
end
