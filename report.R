# All plots and data outputs are produced here

library(icesTAF)
taf.library(icesFO)
library(sf)
library(ggplot2)
library(tidyr)

mkdir("report")

##########
#Load data
##########
catch_dat <- read.taf("data/catch_dat.csv")

trends <- read.taf("model/trends.csv")
catch_current <- read.taf("model/catch_current.csv")
catch_trends <- read.taf("model/catch_trends.csv")

#error with number of columns, to check
clean_status <- read.taf("data/clean_status.csv")

effort_dat <- read.taf("bootstrap/data/ICES_vms_effort_data/vms_effort_data.csv")
landings_dat <- read.taf("bootstrap/data/ICES_vms_landings_data/vms_landings_data.csv")


ices_areas <-
  sf::st_read("bootstrap/data/ICES_areas/areas.csv",
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ices_areas <- dplyr::select(ices_areas, -WKT)

ecoregion <-
  sf::st_read("bootstrap/data/ICES_ecoregions/ecoregion.csv",
              options = "GEOM_POSSIBLE_NAMES=WKT", crs = 4326)
ecoregion <- dplyr::select(ecoregion, -WKT)

# read vms fishing effort
effort <-
  sf::st_read("bootstrap/data/ICES_vms_effort_map/vms_effort.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
effort <- dplyr::select(effort, -WKT)

# read vms swept area ratio
sar <-
  sf::st_read("bootstrap/data/ICES_vms_sar_map/vms_sar.csv",
               options = "GEOM_POSSIBLE_NAMES=wkt", crs = 4326)
sar <- dplyr::select(sar, -WKT)

###############
##Ecoregion map
###############

plot_ecoregion_map(ecoregion, ices_areas)
ggplot2::ggsave("2019_NwS_FO_Figure1.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

#################################################
##1: ICES nominal catches and historical catches#
#################################################

#~~~~~~~~~~~~~~~#
# By common name
#~~~~~~~~~~~~~~~#
#Plot
plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 7, plot_type = "line")
ggplot2::ggsave("2019_NwS_FO_Figure5.png", path = "report/", width = 170, height = 100.5, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "COMMON_NAME", line_count = 7, plot_type = "line", return_data = TRUE)
write.taf(dat, "2019_NwS_FO_Figure5.csv", dir = "report")


#~~~~~~~~~~~~~~~#
# By country
#~~~~~~~~~~~~~~~#
#Plot
plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 5, plot_type = "area")
ggplot2::ggsave("2019_NwS_FO_Figure2.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "COUNTRY", line_count = 9, plot_type = "area", return_data = TRUE)
write.taf(dat, file= "2019_NwS_FO_Figure2.csv", dir = "report")

#~~~~~~~~~~~~~~~#
# By guild
#~~~~~~~~~~~~~~~#

#Plot
plot_catch_trends(catch_dat, type = "GUILD", line_count = 6, plot_type = "line")
# Undefined is too big, will try to assign guild to the biggest ones

# check <- catch_dat %>% filter (GUILD == "undefined")
# unique(check$COMMON_NAME)
# catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Polar cod")] <- "Demersal"
# Redfishes of Sebastes spp attributed to pelagic
catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Atlantic redfishes nei")] <- "Pelagic"

plot_catch_trends(catch_dat, type = "GUILD", line_count = 6, plot_type = "line")
ggplot2::ggsave("2019_NwS_FO_Figure4bis.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

#data
dat <- plot_catch_trends(catch_dat, type = "GUILD", line_count = 3, plot_type = "line", return_data = TRUE)
write.taf(dat, file= "2019_NwS_FO_Figure4.csv", dir = "report")

###########
## 2: SAG #
###########

#~~~~~~~~~~~~~~~#
# A. Trends by guild
#~~~~~~~~~~~~~~~#
unique(trends$FisheriesGuild)

# 1. Demersal
#~~~~~~~~~~~
plot_stock_trends(trends, guild="demersal", cap_year = 2019, cap_month = "October", return_data = FALSE)
ggplot2::ggsave("2019_NwS_FO_Figure12b.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="demersal", cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(dat, file ="2019_NwS_FO_Figure12b.csv", dir = "report")

# 2. Pelagic
#~~~~~~~~~~~
plot_stock_trends(trends, guild="pelagic", cap_year = 2019, cap_month = "October", return_data = FALSE)
ggplot2::ggsave("2019_NwS_FO_Figure12c.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="pelagic", cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(dat,file ="2019_NwS_FO_Figure12c.csv", dir = "report")

# 3. Elasmobranchs
#~~~~~~~~~~~
plot_stock_trends(trends, guild="elasmobranch", cap_year = 2019, cap_month = "October", return_data = FALSE)
ggplot2::ggsave("2019_NwS_FO_Figure12d.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
trends2 <- trends %>% dplyr::filter(Year > 1980)
plot_stock_trends(trends2, guild="elasmobranch", cap_year = 2019, cap_month = "October", return_data = FALSE)
ggplot2::ggsave("2019_NwS_FO_Figure12d_from1980.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="elasmobranch", cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(dat,file ="2019_NwS_FO_Figure12d.csv", dir = "report")


#~~~~~~~~~~~~~~~~~~~~~~~~~#
# Ecosystem Overviews plot
#~~~~~~~~~~~~~~~~~~~~~~~~~#
guild <- read.taf("model/guild.csv")

plot_guild_trends(guild, cap_year = 2019, cap_month = "October",return_data = FALSE )
ggplot2::ggsave("2019_NwS_EO_GuildTrends.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild2 <- guild %>% dplyr::filter(Year > 1943)
plot_guild_trends(guild2, cap_year = 2019, cap_month = "October",return_data = FALSE )
ggplot2::ggsave("2019_NwS_EO_GuildTrends_short.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

guild3 <- guild %>% dplyr::filter(FisheriesGuild != "MEAN")
plot_guild_trends(guild3, cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_NwS_EO_GuildTrends_noMEAN.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
guild4 <- guild3 %>% dplyr::filter(Year > 1943)
plot_guild_trends(guild4, cap_year = 2019, cap_month = "November",return_data = FALSE )
ggplot2::ggsave("2019_NwS_EO_GuildTrends_short_noMEAN.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


dat <- plot_guild_trends(guild, cap_year = 2019, cap_month = "October",return_data = TRUE)
write.taf(dat, file ="2019_NwS_EO_GuildTrends.csv", dir = "report" )

warning("no varialble called sid")
if (FALSE) {
  dat <- trends[,1:2]
  dat <- unique(dat)
  dat <- dat %>% dplyr::filter(StockKeyLabel != "MEAN")
  dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
  dat <- left_join(dat,dat2)
  write.taf(dat, file ="2019_NwS_EO_SpeciesGuild_list.csv", dir = "report" )
}

#~~~~~~~~~~~~~~~#
# B.Current catches
#~~~~~~~~~~~~~~~#
## Bar plots are not in order, check!!


# 1. Demersal
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "October", return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(bar_dat, file ="2019_NwS_FO_Figure13_demersal.csv", dir = "report" )

kobe <- plot_kobe(catch_current, guild = "demersal", caption = T, cap_year = 2019, cap_month = "October", return_data = FALSE)
#kobe_dat is just like bar_dat with one less variable
#kobe_dat <- plot_kobe(catch_current, guild = "Demersal", caption = T, cap_year = 2019, cap_month = "October", return_data = TRUE)

png("report/2019_NwS_FO_Figure13_demersal.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
gridExtra::grid.arrange(kobe, bar, ncol = 2, respect = TRUE, top = "demersal")
dev.off()

# 2. Pelagic
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "pelagic", caption = T, cap_year = 2019, cap_month = "October", return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "pelagic", caption = T, cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(bar_dat, file ="2019_NwS_FO_Figure13_pelagic.csv", dir = "report")

kobe <- plot_kobe(catch_current, guild = "pelagic", caption = T, cap_year = 2019, cap_month = "October", return_data = FALSE)
catch_current <- unique(catch_current)
kobe <- plot_kobe(catch_current, guild = "pelagic", caption = T, cap_year = 2019, cap_month = "October", return_data = FALSE)
png("report/2019_NwS_FO_Figure13_pelagic.png",
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
gridExtra::grid.arrange(kobe, bar, ncol = 2, respect = TRUE, top = "pelagic")
dev.off()


# 3. All
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year = 2019, cap_month = "October", return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "All", caption = T, cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(bar_dat, file ="2019_NwS_FO_Figure13_All.csv", dir = "report" )

kobe <- plot_kobe(catch_current, guild = "All", caption = T, cap_year = 2019, cap_month = "October", return_data = FALSE)
png("report/019_NwS_FO_Figure13_All.png",
    width = 137.32,
    height = 88.9,
    units = "mm",
    res = 300)
gridExtra::grid.arrange(kobe, bar, ncol = 2, respect = TRUE, top = "All stocks")
dev.off()


#~~~~~~~~~~~~~~~#
# C. Discards
#~~~~~~~~~~~~~~~#
discardsA <- plot_discard_trends(catch_trends, 2019, cap_year = 2019, cap_month = "October")

# Most discards are of spurdog, which was not assessed in 2019,
# will plot only elasmobranchs up to 2018

catch_trends2 <- catch_trends %>% dplyr::filter(FisheriesGuild == "elasmobranch")
discardsA <- plot_discard_trends(catch_trends2, 2019, cap_year = 2019, cap_month = "October")

dat <- plot_discard_trends(catch_trends2, 2019, cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(dat, file ="2019_NwS_FO_Figure7_trends.csv", dir = "report" )

discardsB <- plot_discard_current(catch_trends, 2019, cap_year = 2019, cap_month = "October")
catch_trends2 <- catch_trends %>% dplyr::filter(FisheriesGuild != "elasmobranch")
discardsB <- plot_discard_current(catch_trends2, 2019, cap_year = 2019, cap_month = "October")

dat <- plot_discard_current(catch_trends, 2019, cap_year = 2019, cap_month = "October", return_data = TRUE)
write.taf(dat, file ="2019_NwS_FO_Figure7_current.csv", dir = "report" )

png("report/2019_NwS_FO_Figure7.png",
    width = 137.32,
    height = 88.9,
    units = "mm",
    res = 300)
gridExtra::grid.arrange(discardsA, discardsB, ncol = 2, respect = TRUE)
dev.off()

#~~~~~~~~~~~~~~~#
#D. ICES pies
#~~~~~~~~~~~~~~~#


unique(clean_status$StockSize)
# clean_status$StockSize <- gsub("qual_RED", "RED", clean_status$StockSize)

unique(clean_status$FishingPressure)
# clean_status$FishingPressure <- gsub("qual_GREEN", "GREEN", clean_status$FishingPressure)

plot_status_prop_pies(clean_status, "October", "2019")
ggplot2::ggsave("2019_NwS_FO_Figure10.png", path = "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_status_prop_pies(clean_status, "October", "2019", return_data = TRUE)
write.taf(dat, file= "2019_NwS_FO_Figure10.csv", dir = "report")

#~~~~~~~~~~~~~~~#
#E. GES pies
#~~~~~~~~~~~~~~~#

plot_GES_pies(clean_status, catch_current, "October", "2019")
ggplot2::ggsave("2019_NwS_FO_Figure11.png", path = "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_GES_pies(clean_status, catch_current, "October", "2019", return_data = TRUE)
write.taf(dat, file= "2019_NwS_FO_Figure11.csv", dir = "report")

#~~~~~~~~~~~~~~~#
#F. ANNEX TABLE
#~~~~~~~~~~~~~~~#

warning("Annex table not running, and format_annex_table readng in data")
if (FALSE) {
dat <- format_annex_table(clean_status, 2019)

write.taf(dat, file = "2019_NwS_FO_annex_table.csv", dir = "report")
}
# This annex table has to be edited by hand,
# For SBL and GES only one values is reported,
# the one in PA for SBL and the one in MSY for GES


###########
## 3: VMS #
###########

#~~~~~~~~~~~~~~~#
# A. Effort map
#~~~~~~~~~~~~~~~#

gears <- c("Static", "Midwater", "Otter", "Demersal seine")

effort <-
    effort %>%
      dplyr::filter(fishing_category_FO %in% gears) %>%
      dplyr::mutate(
        fishing_category_FO =
          dplyr::recode(fishing_category_FO,
            Static = "Static gears",
            Midwater = "Pelagic trawls and seines",
            Otter = "Bottom otter trawls",
            `Demersal seine` = "Bottom seines")
        )

plot_effort_map(effort, ecoregion) +
  ggplot2::ggtitle("Average MW Fishing hours 2014-2017")

ggplot2::ggsave("2019_NwS_FO_Figure9.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

#~~~~~~~~~~~~~~~#
# B. Swept area map
#~~~~~~~~~~~~~~~#

plot_sar_map(sar, ecoregion, what = "surface") +
  ggtitle("Average surface swept area ratio 2014-2017")

ggplot2::ggsave("2019_NwS_FO_Figure17a.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

plot_sar_map(sar, ecoregion, what = "subsurface")+
  ggtitle("Average subsurface swept area ratio 2014-2017")

ggplot2::ggsave("2019_NwS_FO_Figure17b.png", path = "report", width = 170, height = 200, units = "mm", dpi = 300)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# C. Effort and landings plots
#~~~~~~~~~~~~~~~~~~~~~~~~~~~#

## Effort by country
plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2019, cap_month= "October", line_count= 6)
effort_dat$kw_fishing_hours <- effort_dat$kw_fishing_hours/1000
effort_dat <-
  effort_dat %>%
  dplyr::mutate(
    country = dplyr::recode(country,
                       NO = "Norway",
                       ESP = "Spain",
                       GBR = "United Kingdom",
                       DEU = "Germany",
                       FRA = "France",
                       LTU = "Lithuania",
                       NLD = "Netherlands",
                       DNK = "Denmark")
    )

plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2019, cap_month= "October", line_count= 6)
ggplot2::ggsave("2019_NwS_FO_Figure3.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(effort_dat, metric = "country", type = "effort", cap_year= 2019, cap_month= "October", line_count= 6, return_data = TRUE)
write.taf(dat, file= "2019_NwS_FO_Figure3.csv", dir = "report")

## Landings by gear
plot_vms(landings_dat, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "October", line_count= 4)
landings_dat$totweight <- landings_dat$totweight/1000000
landings_dat <-
  landings_dat %>%
  dplyr::mutate(
    gear_category = dplyr::recode(gear_category,
                                   Static = "Static gears",
                                   Midwater = "Pelagic trawls and seines",
                                   Otter = "Bottom otter trawls",
                                   `Demersal seine` = "Bottom seines",
                                   Dredge = "Dredges",
                                   Beam = "Beam trawls",
                                   'NA' = "Undefined"))

plot_vms(landings_dat, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "October", line_count= 4)
landings_dat2 <- landings_dat %>% filter(year < 2018)
plot_vms(landings_dat2, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "October", line_count= 4)
ggplot2::ggsave("2019_NwS_FO_Figure6.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_vms(landings_dat, metric = "gear_category", type = "landings", cap_year= 2019, cap_month= "October", line_count= 4, return_data = TRUE)
write.taf(dat, file= "2019_NwS_FO_Figure6.csv", dir = "report")

## Effort by gear
plot_vms(effort_dat, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "October", line_count= 6)
effort_dat <-
  effort_dat %>%
  dplyr::mutate(
    gear_category = dplyr::recode(gear_category,
                                   Static = "Static gears",
                                   Midwater = "Pelagic trawls and seines",
                                   Otter = "Bottom otter trawls",
                                   `Demersal seine` = "Bottom seines",
                                   Dredge = "Dredges",
                                   Beam = "Beam trawls",
                                   'NA' = "Undefined"))

effort_dat2 <- effort_dat %>% filter(year < 2018)
plot_vms(effort_dat2, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "October", line_count= 6)

ggplot2::ggsave("2019_NwS_FO_Figure8.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

dat <-plot_vms(effort_dat, metric = "gear_category", type = "effort", cap_year= 2019, cap_month= "October", line_count= 6, return_data = TRUE)
write.taf(dat, file= "2019_NwS_FO_Figure8.csv", dir = "report")
