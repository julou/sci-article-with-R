plot_grid(
  plot_grid(
    myplots[['price-carat']] +
      coord_cartesian(xlim=c(0, 3)),
    myplots[['carat-histo']] +
      coord_cartesian(xlim=c(0, 3)),
    labels="AUTO", ncol=1, rel_heights=c(2, 1), align='v'),
  NULL, # panel C is not ready yet
  nrow=1, labels=c('', 'C'), rel_widths=c(2, 1)
) %>% 
  save_plot(here("plots", "fig1.pdf"), .,
            base_height=NULL, base_width=4.75 * 14/8, # 2 cols
            base_aspect_ratio = 1.6
  )
