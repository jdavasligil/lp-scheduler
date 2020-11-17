% Number of employees.
m = 12;

% Expected unavailability proportion:
p_unavail = 0.25;

% Expected preference proportion:
p_pref = 0.90;

% Every employee is fully available by default:
A1 = ...
[ 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Sun
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Mon
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Tue
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Wed
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Thu
  0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ... % Fri
  0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 ];  % Sat
  
A1 = repmat(A1, [m,1]);

% Randomized Unavailability Option
A = A1 .* discrete_rnd([0,1],[p_unavail, 1 - p_unavail], size(A1));

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
P = A .* discrete_rnd([0,1],[1 - p_pref, p_pref],size(P));

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
%mu = min(max(T),6*D);
%m_lb = ceil(sum(r) / mu) + 2;

S = scheduler(A,P,t,T,r,R,D);

%At = ww_format(A);
%Pt = ww_format(P);
%St = ww_format(S);

%conflicts = zeros(1000,1);
%for i = 1:1000
%    conflicts(i,1) = sum(sum(S.*A ~= S));
%    A = A1 .* discrete_rnd([0,1],[0.25,0.75], size(A1));
%    S = scheduler(A,P,t,T,r,R,D);
%end
%mean(conflicts)
%median(conflicts)
%std(conflicts)
%sum(~conflicts)/1000

ratios = zeros(100,1);
for i = 1:100
    sum_pref = sum(sum(P));
    ratios(i,1) = (sum_pref - sum(sum(P .* S ~= P))) / sum_pref;
    A = A1 .* discrete_rnd([0,1],[p_unavail, 1 - p_unavail], size(A1));
    P = zeros(m,168);
    P = A .* discrete_rnd([0,1],[1 - p_pref, p_pref],size(P));
    S = scheduler(A,P,t,T,r,R,D);
end

mean(ratios)
median(ratios)
std(ratios)
