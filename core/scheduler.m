% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Math 464 Linear Programming Project: Pugs n' Mugs Coffee and Kitchen.       %
%                                                                             %
% This code is for educational purposes only and is not for any other use,    %
% quotation, or distribution without written consent of the author.           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Function 'scheduler' creates an availability and preference based staff
% schedule in the form of an employee by workweek-hour matrix. This matrix
% can be transformed into a daily schedule format using the given interval I.
%
% Author: J.U. Davasligil
% Version: 2020-04-21 (ISO 8601)
%
% INPUTS:
%
%    A    An m employee by n workweek-hour binary availability matrix.
%
%    P    An m employee by n workweek-hour binary preference matrix.
%
%    t    A column vector of the min hours/week for each employee.
%
%    T    A column vector of the max hours/week for each employee.
%
%    r    A column vector of the min employees for each workweek-hour.
%
%    R    A column vector of the max employees for each workweek-hour.
%
%    D    A constant enforcing a maximum on the hours/day for each employee.
%
% OUTPUT: 
%
%    S    An m employee by n workweek-hour binary staff schedule.
%
% NOTES: A workweek is a fixed, regularly-recurring period of 168 hours.
%        The model does not account for rest periods since we assume the
%        business is not open 24 hours. This requirement can, however,
%        be met manually with 8 hour rest periods in the A matrix.
%
%        This model assumes a workweek starts Sunday at 01:00.
%
%        We know a business is closed if r_j = R_j = 0.

function S = scheduler(A,P,t,T,r,R,D)

%% Default values

m = rows(A);
n = columns(A);
S = [];

%% Input Validation

if n != 168
	disp('Error: Not a valid workweek. Must be 7 * 24 = 168 hours long.')
	return
end

if m < 1
	disp('Error: There must be at least one employee.')
	return
end

if floor(D) != D || D < 1
	disp('Error: D must be a positive integer')
	return
end

if any(size(A) != size(P))
	disp('Error: Availability and preference matrices are not the same size.')
	return
end

if   m != rows(t)...
  || m != rows(T)...
  || n != rows(r)...
  || n != rows(R)
	disp('Error: Dimension mismatch. Check vectors t, T, r, and R.')
	return
end

if any(P != (A .* P))
	disp('Error: Preference marked when unavailable.')
	return
end

mu = min(max(T), 6*D);
lb_m = ceil(sum(r) / mu);
lb_warning = sprintf('Warning: %d employees minimum.', lb_m);

if m < lb_m
    disp(lb_warning)
end

%% Calculated parameters and constants

% Largest number of hours available to any employee (for scale).
alpha = max(sum(A'));

% Big M method: Upper bound on total weight possible.
M = n*alpha;

% How each employee's preferences get weighted. Division by zero = 0.
weights = alpha ./ sum(P');
weights = min(weights, M + 1).*(weights ~= Inf);

% Building the weight matrix:
W = P;
for i = 1:m
	W(i,:) = W(i,:) .* weights(i);
end

%% Optimization Model: glpk (c, B, b, lb, ub, ctype, vartype, sense, param)

c = vec(W) - M * (1 - vec(A));

b = [(-1)*t ; T ; (-1)*r ; R ; D*ones(7*m,1)];

B = [ (-1)*repmat(eye(m),1,n) ;
           repmat(eye(m),1,n) ;
      (-1)*kron(eye(n),ones(1,m)) ;
           kron(eye(n),ones(1,m)) ;
           kron(eye(7),repmat(eye(m),1,24)) ];

lb = zeros(m*n,1);

ub = ones(m*n,1);

ctype = repmat('U',1,rows(b));

vtype = repmat('I',1,m*n);

sense = -1;

[dv,ov] = glpk(c, B, b, lb, ub, ctype, vtype, sense);
      
S = reshape(dv, m, n);
