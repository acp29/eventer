%  Function file: lsqfit
%
%  [x] = lsqfit (fun, x0, xdata, ydata)
%  [x] = lsqfit (fun, x0, xdata, ydata, lb)
%  [x] = lsqfit (fun, x0, xdata, ydata, lb, ub)
%  [x] = lsqfit (fun, x0, xdata, ydata, lb, ub, options)
%  [x, resnorm] = lsqfit (...)
%  [x, resnorm, residual] = lsqfit (...)
%  [x, resnorm, residual, exitflag] = lsqfit (...)
%  [x, resnorm, residual, exitflag, output] = lsqfit (...)
%  [x, resnorm, residual, exitflag, output, lambda, jacobian] = lsqfit (...)
%
%  Returns the parameters x that minimize the (weighted) sum-of-squared
%  residuals for the anonymous function f(x) and xdata with the observed
%  ydata, starting with initial guesses x0. This function uses the
%  Levenberg-Marquardt algorithm. This is suitable for typical non-linear
%  least-squares regression problems. To support box constraints, the
%  algorithm is wrapped with a parameter transformation [1,2,3].
%  The Jacobian matrix of the residuals is constructed from partial
%  derivatives determined by numerical differentiation. The dampening
%  factor lambda is selected as described in [4,5,6]. This function can
%  also use the delta method to calculate the standard errors and
%  confidence intervals for each fit parameter, and the confidence bands
%  evaluated at each value of xdata [7,8]. Specific usage information:
%
%  x = lsqfit(fun,x0,xdata,ydata) starts at x0 and finds coefficients
%      x to best fit the nonlinear function fun(x,xdata) to the data ydata
%      (in the least-squares sense). ydata must be the same size as the
%      vector returned by fun.
%
%  x = lsqfit(fun,x0,xdata,ydata,lb,ub) defines a set of lower and
%      upper bounds on the design variables in x so that the solution is
%      always in the range lb <= x <= ub.
%
%  x = lsqfit(fun,x0,xdata,ydata,lb,ub,options) minimizes with the
%      optimization options specified in options. Pass empty matrices for
%      lb and ub if no bounds exist.
%
%  [x,resnorm] = lsqfit(...) returns the value of the squared 2-norm
%      of the residual at x: sum((ydata-fun(x,xdata)).^2).
%
%  [x,resnorm,residual] = lsqfit(...) returns the value of the
%      residual ydata-fun(x,xdata) at the solution x.
%
%  [x,resnorm,residual,exitflag] = lsqfit(...) returns a value
%      exitflag that describes the exit condition.
%
%  [x,resnorm,residual,exitflag,output] = lsqfit(...) returns a
%      structure output that contains information about the optimization.
%
%  [x,resnorm,residual,exitflag,output,lambda] = lsqfit(...) returns
%      an empty structure for MATLAB compatibility.
%
%  [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqfit(...)
%      returns the Jacobian of fun at the solution x.
%
%
%  This function accepts the following fields in the structure 'options':
%
%   TolX        - Termination tolerance on x, a positive scalar.
%                 The default is 1e-6.
%
%   TolFun      - Termination tolerance on the function value,
%                 a positive scalar. The default is 1e-6.
%
%   MaxIter     - Maximum number of iterations allowed, a positive integer.
%                 The default is 400.
%
%   MaxFunEvals - Maximum number of function evaluations allowed, a
%                 positive integer. The default is 100*numberOfVariables.
%
%   Algorithm   - Only supported option is 'levenberg-marquardt'.
%                 Set the initial damping factor lambda by setting
%                 the 'Algorithm' field as a cell array:
%                 {'levenberg-marquardt',1.0}
%                 A higher initial lambda will make the algorithm
%                 more robust to initial values far from the optimum.
%                 The default initial lambda is 1e-03. Setting lambda to
%                 zero results in a purely Gauss-Newton algoritm.
%
%   Alpha       - Defines the 100*(1-Alpha) two-sided confidence intervals
%                 for the fit parameters and the confidence bands evaluated
%                 at each value of xdata [7,8]. The results are provided in
%                 the ConfInt and ConfBnd fields of the output structure.
%                 If Alpha is not specified, no intervals or bands are
%                 computed.
%                 This option field is not supported in MATLAB's
%                 lsqcurvefit function.
%
%   Weights     - See below for details.
%                 This option field is not supported in MATLAB's
%                 lsqcurvefit function.
%
%   The weights field allows the user to perform weighted least-
%   squares by providing a diagonal matrix.
%
%   For example, for weighted least squares (WLS):
%
%    > options.Weights = diag(variance(ydata).^-1)
%
%   This is equivalent to weighting the residuals with the standard
%   deviation.
%
%   Supported exit flags:
%     -4  Optimization could not make further progress
%     -2  Problem is infeasible: the bounds lb and ub are inconsistent.
%     0   Number of iterations exceeded options.MaxIter or number of
%         function evaluations exceeded options.MaxFunEvals.
%     1   Function converged to a solution x.
%     2   Change in x was less than the specified tolerance.
%     3   Change in the residual was less than the specified tolerance.
%
%    Bibliography:
%    [1] http://www.cern.ch/minuit
%         Author: Fred James, Matthias Winkler and Andras Zsenei
%         Current maintainer: Lorenzo Moneta
%         Copyright: CERN, Geneva 1994-1998
%         See also MINUIT User's Guide
%         License: (L)GPL
%    [2] https://github.com/jjhelmus/leastsqbound-scipy
%         Author: Helmus JJ
%    [3] http://lmfit.github.io/lmfit-py/
%         Author: LM-Fit Development Team; License: BSD
%    [4] Bevington & Robinson. Data Reduction and Error Analysis for the
%         Physical Sciences (McGraw-Hill, 3rd ed. 1992)
%    [5] Press et al. Numerical Recipes in C: The Art of Scientific
%         Computing (Cambridge University Press, 3rd ed. 2007) Ch. 15.5.2
%         http://apps.nrbook.com/empanel/index.html#
%    [6] SAS OnlneDoc Version 8 Chapter 45: The NLIN Procedure
%         http://www.math.wpi.edu/saspdf/
%         Copyright (c) 1999 SAS Institute Inc., Cary, NC, USA
%    [7] http://www.graphpad.com/guides/prism/6/curve-fitting/
%         index.htm?reg_how_standard_errors_are_comput.htm
%         Copyright (c) 2014 GraphPad Software
%    [8] http://www.graphpad.com/guides/prism/6/curve-fitting/
%         index.htm?reg_confidence_and_prediction_band.htm
%         Copyright (c) 2014 GraphPad Software
%
%  The syntax in this function code is known to be compatible with
%  recent versions of Octave (v3.2.4 on Debian 6 Linux 2.6.32) and
%  Matlab (v7.4.0 on Windows XP). This function is not compatible with
%  earlier versions of Matlab that do not support anonymous functions.
%
%  lsqfit v1.0 (29/08/2015)
%  Author: Andrew Charles Penn
%  https://www.researchgate.net/profile/Andrew_Penn/


function [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqfit(fun,x0,xdata,ydata,lb,ub,options)

  % Check for input errors
  if nargin<4
    error('Atleast 4 input arguments are required to run lsqfit')
  end

  % Check for errors in the variables defining the box constraints
  x0 = double(x0(:));
  xdata = double(xdata(:));
  ydata = double(ydata(:));
  n = numel(xdata);
  m = numel(x0);
  info = functions(fun);
  if ~strcmp(info.type,'anonymous')
    error('lsqfit only supports use of anonymous functions')
  end
  if nargin>4
    if ~isempty(lb)
      lb = lb(:);
    else
      lb = -inf(m,1);
    end
  else
    lb = -inf(m,1);
  end
  if nargin>5
    if ~isempty(ub)
      ub = ub(:);
    else
      ub = inf(m,1);
    end
  else
    ub=inf(m,1);
  end
  if ~isfloat(lb) || ~isfloat(ub) || ~isreal(lb) || ~isreal(ub)
    error('The lower and upper bounds must be defined by floating point real numeric vectors')
  end
  if length(lb) ~= m  &&  length(ub) ~= m
    error('Vectors of the parameter bounds must be the same length the vector of parameters')
  end
  if any(lb>=ub)
    error('-2: Problem is infeasible: the bounds lb and ub are inconsistent.')
  end
  if any(x0<=lb) || any(x0>=ub)
    error('-2: Problem is infeasible: the bounds lb and ub are inconsistent.')
  end
  % Avoid setting initial values at 0
  x0(x0==0 & ub>0)=sqrt(eps);
  x0(x0==0 & x0==ub)=-sqrt(eps);


  % Set default values
  lambda = 1e-03;

  % Update with user-defined options
  if nargin>6
    if isfield(options,'Algorithm')
      if iscell(options.Algorithm)
        if strcmp(options.Algorithm{1},'levenberg-marquardt')
          try
            lambda = options.Algorithm{2};
          catch
            % Use default value
          end
        else
          warning('lsqfit:noSupportAlgorithm',...
                  'Algorithm not recognised or supported. Levenberg-Marquardt will be used.')
        end
      else
        if ~strcmp(options.Algorithm,'levenberg-marquardt')
          warning('lsqfit:noSupportAlgorithm',...
                  'Algorithm not recognised or supported. Levenberg-Marquardt will be used.')
        end
      end
    end
    if isfield(options,'Alpha')
      alpha = options.Alpha;
      if ~isa(alpha,'numeric') || numel(alpha)~=1
        error('The Alpha value must be a numeric scalar value');
      end
      if alpha<=0 || alpha>=1
        error('The Alpha value must be a value between 0 and 1');
      end
    else
      alpha = [];
    end
  else
    options = struct;
    alpha = [];
  end

  % Redefine function to include parameter transformation for constrained optimization
  try
    if length(fun(x0))~=n
      error('Try alternative input arguments to function fun')
    end
    f = @(x)fun(i2e(x,lb,ub,m)); %#ok<NASGU>
    % Note that this is the fastest configuration of input arguments to run lsqfit
  catch
    try
      if length(fun(xdata,x0))~=n
        error('Try alternative input arguments to function fun')
      end
      f = @(x)fun(xdata,i2e(x,lb,ub,m)); %#ok<NASGU>
    catch
      try
        if length(fun(x0,xdata))~=n
          error('No suitable input arguments found for function fun')
        end
        f = @(x)fun(i2e(x,lb,ub,m),xdata);
      catch
        error('An error occurred whilst evaluating the input function')
      end
    end
  end

  % Transform bound initial paramater values x0 to internal initial values z0
  z0 = e2i(x0,lb,ub,m);

  % Execute Levenberg-Marquardt algorithm for non-linear least squares fitting
  [z,SSE,residual,exitflag,output,J,W] = levenberg_marquardt(f,z0,xdata,ydata,lambda,options);

  % Backtransform optimized internal values z to external parameter values x
  x = i2e(z,lb,ub,m);

  % Scale the jacobian of residuals with internal-to-external parameter gradients
  grad = grad_i2e(z,lb,ub,m);
  for j = 1:m
    J(:,j) = J(:,j)/grad(j);
  end

  % Specify in the output structure the method used for non-linear least-squares fitting
  if sum(any(tril(W,-1))) || sum(any(triu(W,+1)))
    output.Method = 'Generalized';
  elseif all(diag(W)==ones(n,1));
    output.Method = 'Ordinary';
  else
    output.Method = 'Weighted';
  end

  % Calculate standard errors of the fit parameters and add them to the output structure
  df = n-m;
  H = J'*W*J;
  [Q,R] = qr(H,0);
  C = R\Q';
  StdErr = sqrt(diag(C)*SSE/df);
  % Evaluate fun using fit parameters at each value of xdata
  Fit = ydata-residual;
  % Calculate confidence intervals and confidence bands
  if ~isempty(alpha)
    % Compute the two-tailed probability of Alpha from Student's t distribution
    t = tinv(1-alpha/2,df);
    % Compute the confidence interval for each fitted parameter
    ConfInt(:,1) = x-t*StdErr;
    ConfInt(:,2) = x+t*StdErr;
    % Compute the confidence bands evaluated at each value of xdata
    ConfErr = zeros(n,1);
    ConfBnd = zeros(n,2);
    for i=1:n
      ConfErr(i,1) = t*sqrt(J(i,:)*C*J(i,:)'*SSE/df);
      ConfBnd(i,1) = Fit(i)-ConfErr(i);
      ConfBnd(i,2) = Fit(i)+ConfErr(i);
    end
  else
    ConfInt = [];
    ConfBnd = [];
  end

  % Assign remaining supported output arguments
  resnorm = SSE;
  jacobian = J;
  output.StdErr = StdErr;
  output.df = df;
  output.Fit = Fit;
  output.Alpha = alpha;
  output.ConfInt = ConfInt;
  output.ConfBnd = ConfBnd;

  % Provide empty structures fields to unsupported output arguments
  lambda = struct('lower',[],'upper',[]);

end


%--------------------------------------------------------------------------

function [z0] = e2i(x0,lb,ub,m)

  % Function converts between external (constrained) and internal
  % (unconstrained) parameters

  z0 = x0;
  if all(isinf(lb)) && all(isinf(ub))
    % Do nothing
  else
    for i = 1:m
      if ~isinf(lb(i)) && ~isinf(ub(i))
        z0(i) = asin(((2*(x0(i)-lb(i))/(ub(i)-lb(i))))-1);
      elseif isinf(lb(i)) && ~isinf(ub(i))
        z0(i) = sqrt((ub(i)-x0(i)+1)^2-1);
      elseif ~isinf(lb(i)) && isinf(ub(i))
        z0(i) = sqrt((x0(i)-lb(i)+1)^2-1);
      elseif isinf(lb(i)) && isinf(ub(i))
        z0(i) = x0(i);
      end
    end
  end

end


%--------------------------------------------------------------------------

function [x] = i2e(z,lb,ub,m)

  % Function converts between internal (unconstrained) and external
  % (constrained) parameters

  x = z;
  if all(isinf(lb)) && all(isinf(ub))
    % Do nothing
  else
      for i = 1:m
        if ~isinf(lb(i)) && ~isinf(ub(i))
          x(i) = lb(i)+(sin(z(i))+1)*(ub(i)-lb(i))/2;
        elseif isinf(lb(i)) && ~isinf(ub(i))
          x(i) = ub(i)+1-sqrt(z(i)^2+1);
        elseif ~isinf(lb(i)) && isinf(ub(i))
          x(i) = lb(i)-1+sqrt(z(i)^2+1);
        elseif isinf(lb(i)) && isinf(ub(i))
          x(i) = z(i);
        end
      end
  end

end

%--------------------------------------------------------------------------

function [grad] = grad_i2e(z,lb,ub,m)

  % Calculate the internal (unconstrained) to external (constrained)
  % parameter gradients.

  grad = ones(m,1);
  if all(isinf(lb)) && all(isinf(ub))
    % Do nothing
  else
    for i = 1:m
      if ~isinf(lb(i)) && ~isinf(ub(i))
        grad(i) = (ub(i)-lb(i))*cos(z(i))/2;
      elseif isinf(lb(i)) && ~isinf(ub(i))
        grad(i) = -z(i)/sqrt(z(i)*z(i)+1);
      elseif ~isinf(lb(i)) && isinf(ub(i))
        grad(i) = z(i)/sqrt(z(i).*z(i)+1);
      elseif isinf(lb(i)) && isinf(ub(i))
        grad(i) = 1.0;
      end
    end
  end

end


%--------------------------------------------------------------------------

function [x,SSE,residual,exitflag,output,J,W] = levenberg_marquardt(fun,x0,xdata,ydata,lambda,options)

  % Check for input errors
  if nargin<5
    error('Not enough input arguments are specified')
  end

  % Initialize input variables and parameters
  n = numel(xdata);
  m = numel(x0);

  % Set default options
  TolX = 1e-06;
  TolFun = 1e-06;
  MaxIter = 400;
  MaxFunEvals = 100*m;
  W = diag(ones(n,1));

  % Update with user-defined options if they exist
  if nargin>5
    if isfield(options,'TolX')
      TolX = options.TolX;
      if ~isfloat(TolX) || numel(TolX)~=1 || ~isreal(TolX) || TolX<eps || isinf(TolX) || isnan(TolX)
        error('TolX must be a positive floating point real scalar value greater than the machine precision')
      end
    end
    if isfield(options,'TolFun')
      TolFun = options.TolFun;
      if ~isfloat(TolFun) || numel(TolFun)~=1 || ~isreal(TolFun) || TolFun<eps || isinf(TolFun) || isnan(TolFun)
        error('TolFun must be a positive floating point real scalar value greater than the machine precision')
      end
    end
    if isfield(options,'MaxIter')
      MaxIter = options.MaxIter;
      if ~isfloat(MaxIter) || numel(MaxIter)~=1 || ~isreal(MaxIter) || MaxIter<1 || isnan(MaxIter) || MaxIter~=round(MaxIter)
        error('MaxIter must be a positive floating point integer upto inf')
      end
    end
    if isfield(options,'MaxFunEvals')
      MaxFunEvals = options.MaxFunEvals;
      if ~isfloat(MaxFunEvals) || numel(MaxFunEvals)~=1 || ~isreal(MaxFunEvals) || MaxFunEvals<1 || isnan(MaxFunEvals) || MaxFunEvals~=round(MaxFunEvals)
        error('MaxFunEvals must be a positive floating point integer upto inf')
      end
    end
    if isfield(options,'Weights')
      W = options.Weights;
      if ~all(size(W)==ones(1,2)*n) || ~isfloat(W) || ~isreal(W)
        error('The weights must be provided as a diagonal matrix of floating point real numeric values')
      end
    end
  end

  % Check for errors in the variables and parameters
  if ~isfloat(x0) || ~isfloat(xdata) || ~isfloat(ydata)
    error('The data and initial values must be defined by floating point numeric objects')
  end
  if ~all(size(xdata)==size(ydata))
    error('The dimensions of the xdata and ydata variables must be the same')
  end
  if m>=n
    error('The number of parameters in x must be < the number of points in xdata')
  end
  if sum(size(lambda))==2
    if lambda > 0
      algorithm = 'levenberg-marquardt';
    elseif lambda == 0
      algorithm = 'gauss-newton';
    elseif lambda < 0
      error('The initial lambda must be a non-negative scalar value')
    end
  else
    error('Lambda must be a scalar')
  end

  % Check for errors in the function
  try
    fun(x0);
    % Check the dimensions of the function output
  catch
    error('An error occurred whilst evaluating the input function')
  end
  if ~all(size(fun(x0)) == size(ydata))
    error('The dimensions of the returned argument of the function fun must be the same as for ydata')
  end

  % Start iterative optimisation
  fx0 = fun(x0);
  k = 1; % Function evaluation counter
  residual = ydata-fx0;
  SSE = zeros(MaxIter+1,1);
  SSE(1) = sum(W*residual.^2);
  J = [];
  for i=1:MaxIter
    if isempty(J)
      % Compute the Jacobian matrix of the function (vectorized)
      h = sqrt(eps)*x0';
      F = zeros(n,m);
      X = x0(:,ones(1,m))+diag(h);
      for j=1:m
        F(:,j) = fun(X(:,j));
      end
      k = k+m;
      J = (F-fx0(:,ones(1,m)))./h(ones(1,n),:);
      % Compute the gradient vector and approximate the Hessian
      g = J'*W*residual;
      H = J'*W*J;
    end
    D = lambda*diag(diag(H));
    if any(any(isnan(H+D))) || any(any(isinf(H+D)))
      error('-4: Optimization could not make further progress')
    elseif cond(H+D)>1e+15 || any(abs(g)<eps)
      error('-4: Optimization could not make further progress')
    end
    % Solve the linear equations by QR decomposition and compute the new parameter value
    [Q,R] = qr(H+D,0);
    x = x0+R\Q'*g;
    % Calculate the change in x
    dx = x-x0;
    % Calculate sum-of-squared residual error for the new parameters
    fx = fun(x);
    k = k+1;
    residual = ydata-fx;
    SSE(i+1) = sum(W*residual.^2);
    if i>=MaxIter || k>=MaxFunEvals
      exitflag = 0;
      message = ['0: Number of iterations exceeded options.MaxIter or '...
                 'number of function evaluations exceeded options.MaxFunEvals.'];
      break
    end
    % Assess whether the algorithm has converged according to one of the criteria
    if all(abs(dx)<TolX) && abs(SSE(i)-SSE(i+1))<TolFun
      exitflag = 1;
      message = '1: Function converged to a solution x.';
      break
    elseif any(abs(dx)>TolX) && abs(SSE(i)-SSE(i+1))<TolFun
      exitflag = 2;
      message = '2: Change in the residual was less than the specified tolerance.';
      break
    elseif all(abs(dx)<TolX) && abs(SSE(i)-SSE(i+1))>TolFun
      exitflag = 3;
      message = '3: Change in x was less than the specified tolerance';
      break
    end
    % Prepare for next iteration
    % Adjust the dampening factor lambda for the next iteration
    if SSE(i+1)<SSE(i)
      % Increase Gauss-Newton component
      lambda = lambda*0.1;
      % Update input for the next iteration
      x0 = x;
      fx0 = fx;
      J = [];
    elseif SSE(i+1)>=SSE(i)
      % Increase steepest descent component and return
      lambda = lambda*10;
    end
  end

  % Assign output arguments
  SSE = SSE(SSE>0);
  SSE = SSE(end);
  output = struct('iterations',i,...
                  'funcCount',k,...
                  'algorithm',algorithm,...
                  'stepsize',dx,...
                  'message',message);

end
