%     Function File: [X] = sinv (A)
%
%     Compute the inverse of the square matrix A by singular value
%     decomposition. This is a more stable alternative to the native
%     inverse function when the matrix A is nearly singular (i.e. if
%     its determinant, or det(A) approaches zero).
%
%     The singular value decomposition of A is:
%     [U, S, V] = svd(A)
%
%     Since A = U * S * V', then:
%     X = inv(A) = inv(U * S * V') = inv(V') * inv(S) * inv(U)
%
%     Since V and U are orthoganol matrices, this simplifies to:
%     X = V * inv(S) * U'
%
%     sinv v1.0 (last updated: 09/08/2013)
%     Author: Andrew Charles Penn
%     https://www.researchgate.net/profile/Andrew_Penn/


function [X] = sinv(A)

  [m,n] = size(A);

  if m ~= n
    error('sinv: argument must be a square matrix');
  end

  [U,S,V] = svd(A);
  X = V*inv(S)* U';
