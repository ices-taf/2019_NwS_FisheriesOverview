

taf.library("icesVMS")

vms_effort <- icesVMS::get_effort_map("Norwegian Sea", year = 2017)

# convert to sf
vms_effort <- sf::st_as_sf(vms_effort, wkt = "wkt", crs = 4326)

sf::st_write(vms_effort, "vms_effort.csv", layer_options = "GEOMETRY=AS_WKT")
