% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Math 464 Linear Programming Project: Pugs n' Mugs Coffee and Kitchen.       %
% By Jaedin Davasligil (2020/04/21).                                          %
%                                                                             %
% Description: An example of a staff schedule for a small coffee shop.        %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% First visible column represents 01:00, last is 00:00 [24:00].
% Weekday pre-open hour is 05:00; weekend is 06:00.
% All days have closing (afterhour) at 21:00.
%
% Rules of Thumb: 1 FTE can work 5 shifts, hire 2 more than necessary.
% Currently we are scheduling 12.
%
% The following table presentation is called workweek (ww) format.

% Number of employees.
m = 12;

% Expected unavailability proportion:
p_unavail = 0.25;

% Expected preference proportion:
p_pref = 0.10;

% Every employee is fully available by default:
A = ...
[ 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Sun
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Mon
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Tue
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Wed
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Thu
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Fri
  0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ];  % Sat
  
A = repmat(A, [m,1]);

% Randomized Unavailability Option
%A = A .* discrete_rnd([0,1],[p_unavail, 1 - p_unavail], size(A));

% For custom preference:
P = ...
[ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];

% Same for each employee. For full customization,
% we need to manually fill out P for each worker.
P = repmat(P, [m,1]);

% Randomized Preference Option 
%P = A .* discrete_rnd([0,1],[1 - p_pref, p_pref],size(P));

t = 15*ones(m,1);

T = 35*ones(m,1);

% Minimum employees required for each workweek-hour.
r =...
[ 0 0 0 0 0 1 2 2 3 3 3 3 3 2 2 2 2 3 3 3 1 0 0 0 ... % Sun
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Mon
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Tue
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Wed
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Thu
  0 0 0 0 1 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 1 0 0 0 ... % Fri
  0 0 0 0 0 1 2 2 3 3 3 3 3 3 3 3 3 3 3 3 1 0 0 0 ]'; % Sat

% Maximum employees required for each workweek-hour.
R =...
[ 0 0 0 0 0 1 2 2 3 4 4 4 4 3 3 3 4 4 4 3 1 0 0 0 ... % Sun
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Mon
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Tue
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Wed
  0 0 0 0 1 2 2 2 2 2 3 3 3 2 2 2 2 2 2 2 1 0 0 0 ... % Thu
  0 0 0 0 1 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 1 0 0 0 ... % Fri
  0 0 0 0 0 1 3 3 3 4 4 4 4 3 3 3 4 4 4 3 1 0 0 0 ]'; % Sat

% Maximum hours an employee may work per day.
D = 8;

% Lower bound on number of employees.
mu = min(max(T), 6*D);
m_lb = ceil(sum(r) / mu) + 2;

tic();
S = scheduler(A,P,t,T,r,R,D);
runtime = toc()

At = ww_format(A);
Pt = ww_format(P);
St = ww_format(S)

% To check for schedule conflicts
schedule_conflict_total = sum(sum(S.*A ~= S))

% To check for preference conflicts
sum_pref = sum(sum(P));
preferences_met_ratio = (sum_pref - sum(sum(P .* S ~= P))) / sum_pref
