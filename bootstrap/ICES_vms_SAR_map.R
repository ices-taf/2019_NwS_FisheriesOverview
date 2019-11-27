
taf.library("icesVMS")

vms_sar <- icesVMS::get_sar_map("Norwegian Sea", year = 2017)

# convert to sf
vms_sar <- sf::st_as_sf(vms_sar, wkt = "wkt", crs = 4326)

sf::st_write(vms_sar, "vms_sar.csv", layer_options = "GEOMETRY=AS_WKT")
