% function invcompE(tol,N)
%
% Return metrics relating to receiver operator characterics (ROC) for
% Eventer output. The invcompE function must be run within an
% eventer.output/Data_chX_wavename directory. The root directory of the
% original eventer analysis should contain a text file called 
% 'EventTimes.txt' or Event Times.txt', which lists the event times  
% that are used as a reference. 
%
% tol is the absolute tolerance in ms
%
% Two event time (ms) values u and v are within tolerance if:
%    abs(u-v) <= tol
%
% A good value for tol is 1.2 ms
%
% The input argument N should be the total number of detections possible.
% N is used in the calculation of TN. If no N argument is provided, invcompE
% will find it in the Eventer output for sample point based analysis.
%
% Copyright (C) 2019, Dr Andrew Penn

function invcompE(tol,N)

  % Data scaling
  DS = 1e-3; % since tol is in ms

  % Open the SimPSCs Event Time
  try 
    fid = fopen('../../Event Times.txt');
  catch
    fid = fopen('../../Event Times.txt');
  end
  if fid < 0
    try
      fid = fopen('../../../EventTimes.txt');
    catch
      fid = fopen('../../../Event Times.txt');
    end
  end
  C = textscan(fid,'%f');
  J = cell2mat(C);
  E = numel(J); % Number of events simulated
  fclose(fid);
  if any(diff(J) < (DS*tol*2))
    error('Simulated event times cannot be within two times the tolerance')
  end

  % Open the detected event times
  fid =(fopen('./txt/times.txt'));
  C = textscan(fid, '%f');
  K = cell2mat(C);
  fclose(fid);

  % If applicable, open Eventer parameter file and get total number of peaks in deconvoluted wave
  if nargin < 2
    % For sample based calculation of true negative rate
    parameters = load('-ascii','_parameters');
    N = parameters(6);
  end

  % Analyse event times
  %
  % LIA = ismembertol(A,B,TOL) returns an array of the same size as A
  %  containing logical 1 (true) where the elements of A are within the
  %  tolerance TOL of the elements in B; otherwise, it contains logical 0
  %
  % Determine if simulated event time is within tolerance of any detected events
  L=ismembertol(K,J,tol,'DataScale',DS); % Data scale converts ms to s
  toloutput = double(L);
  assignin('base','toloutput',toloutput);
  A = repmat(J,[1 length(K)]);
  [minValue,closestIndex] = min(abs(A-K'));
  closestValue = J(closestIndex);
  assignin('base','closestValue',closestValue);
  fid=(fopen('results.txt','wt'));
  TP = sum(L);            % Number of simulated events within tolerance of one or more detected events
  FP = numel(K) - TP;     % Number of detections - the number of true positives
  FN = E - TP;            % Number of simulated events - the number of true positives
  TN = N - numel(K) - FN; % Number of possible detections - number of detections - number of false negatives
  TPR = TP/(TP + FN);
  TNR = TN/(FP + TN);
  FPR = FP/(FP + TN);
  FNR = FN/(TP + FN);
  FDR = FP/(FP + TP);
  ACC = (TP + TN) / (TP + TN + FP + FN);   % Note that (TP + TN + FP + FN) = N
  MCC = (TP * TN - FP * FN) / sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));

  format short g
  fprintf(fid,'Total number of events detected: %d\n',numel(K));
  fprintf(fid,'Number of true positives (TP): %d\n',TP);
  fprintf(fid,'Number of true negatives (TN): %d\n',TN);
  fprintf(fid,'Number of false positives (FP): %d\n',FP);
  fprintf(fid,'Number of false negatives (FN): %d\n',FN);
  fprintf(fid,'True positive rate (TPR): %g\n',TPR);
  fprintf(fid,'True negative rate (TNR): %g\n',TNR);
  fprintf(fid,'False positive rate (FPR): %g\n',FPR);
  fprintf(fid,'False negative rate (FNR): %g\n',FNR);
  fprintf(fid,'False discovery rate (FDR): %g\n',FDR);
  fprintf(fid,'Accuracy (ACC): %g\n',ACC);
  fprintf(fid,'Matthews correlation coefficient (MCC): %g\n\n',MCC);
  fclose(fid);
  type('results.txt')
