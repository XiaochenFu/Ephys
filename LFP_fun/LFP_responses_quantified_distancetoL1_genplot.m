figure(figure_idx)
cmp = colormap(cbrewer2('Greens'));
scatter(distance_all*1000,vtg,ptsize,estimated_cell_all,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',1.2);
clim([0 3000])
hold on; title(tt);xlabel('Fibre distance to L1 (um)');
xticks([0 200 400 600  1000 1200]); xticklabels({'0','200','400','600','Offtarget',' '})
colorbar;
saveimg(figure_idx,outputpath,'Ephys',tt_save,'111')