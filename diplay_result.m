function [] = diplay_result(results)

[n,k] = size(results);
results = round(results*10000)/10000;
results = results';

% disp(['&' num2str(results(1,1))  ' &' num2str(results(1,3)) ' &' num2str(results(1,4)) ' &' num2str(results(1,5))   '\\' ]);
% disp(['&' num2str(results(2,1))  ' &' num2str(results(2,3)) ' &' num2str(results(2,4)) ' &' num2str(results(2,5))   '\\' ]);
% disp(['&' num2str(results(3,1))  ' &' num2str(results(3,3)) ' &' num2str(results(3,4)) ' &' num2str(results(3,5))   '\\' ]);

% disp(['&' num2str(results(1,1))  ' &' num2str(results(1,3)) ' &' num2str(results(1,4)) ' &' num2str(results(1,5))  ' &' num2str(results(1,7))  '\\' ]);
% disp(['&' num2str(results(2,1))  ' &' num2str(results(2,3)) ' &' num2str(results(2,4)) ' &' num2str(results(2,5))  ' &' num2str(results(2,7))  '\\' ]);
% disp(['&' num2str(results(3,1))  ' &' num2str(results(3,3)) ' &' num2str(results(3,4)) ' &' num2str(results(3,5))  ' &' num2str(results(3,7))  '\\' ]);
disp('SC-ind SC-com STC MBC  TSC');
disp(['&' num2str(results(1,1))  ' &' num2str(results(1,7))  ' &' num2str(results(1,3)) ' &' num2str(results(1,4)) ' &' num2str(results(1,5))   '\\' ]);
disp(['&' num2str(results(2,1))  ' &' num2str(results(2,7))  ' &' num2str(results(2,3)) ' &' num2str(results(2,4)) ' &' num2str(results(2,5))   '\\' ]);
disp(['&' num2str(results(3,1))  ' &' num2str(results(3,7))  ' &' num2str(results(3,3)) ' &' num2str(results(3,4)) ' &' num2str(results(3,5))   '\\' ]);
end