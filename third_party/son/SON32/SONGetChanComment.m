function [comment]=SONGetChanComment(fh, chan)
% SONGETCHANCOMMENT returns the comment string for the specified channel
%
% COMMENT=SONGETCHANCOMMENT(FH, CHAN)
%                         FH SON file handle
%                         CHAN Channel number (0 to SONMAXCHANS-1)
% Returns the channel comment as a string.  
% 
% Author:Malcolm Lidierth
% Matlab SON library:
% Copyright © The Author & King's College London 2005-2006

global SON_CHANCOMSZ;

% 26.07.09 Alter to prevent segmentation errors

%comment=char(zeros(1,SON_CHANCOMSZ));
comment='012345678901234567890123456789012345678901234567890123456789012345678901';
comment=calllib('son32','SONGetChanComment',...
                        fh,chan,comment,length(comment)-1);

