%% import and plotting functions

fn=('130625_001.2.wcp'); 

out=import_wcp(fn,'debug')

%% 
plot_wcp(out,'recordings',10:20)
plot_wcp(out)
plot_wcp(fn)

