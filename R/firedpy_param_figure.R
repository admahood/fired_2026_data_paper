# create map of st parameters
library(tidyverse);library(sf)
params <- readr::read_csv('~/projects/firedpy/firedpy/data/parameters_for_individual_countries.csv') |>
  dplyr::select(1:4)

filez <- list.files('~/projects/firedpy/firedpy/data/individual_countries', full.names = TRUE)
namez <- filez |> str_remove_all('/home/a/projects/firedpy/firedpy/data/individual_countries/') |> str_remove_all('.gpkg')

countries <- filez |>
  lapply(st_read) |>
  bind_rows() |>
  mutate(country_name = namez) |>
  left_join(params) |>
  dplyr::mutate(spatial = ifelse(spatial > 1, str_c(spatial, " Pixels"), str_c(spatial, " Pixel")),
                temporal = ifelse(temporal > 1, str_c(temporal, " Days"), str_c(temporal, " Day")))
  

countries |>
  ggplot() +
  geom_sf(aes(fill = as.factor(str_c(spatial, ' ', temporal)))) +
  coord_sf(crs = '+proj=robin') +
  scale_fill_brewer(palette = "Set1", name = 'Parameters') +
  theme_bw() +
  theme(legend.position = c(0,0),
        legend.justification = c(0,0),
        legend.background = element_rect(fill = 'white', color = 'black'))

ggsave('out/param_map.png', width= 15, height =7, bg='white')

