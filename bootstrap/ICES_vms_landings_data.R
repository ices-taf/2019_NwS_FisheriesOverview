

taf.library("icesVMS")

vms_landings_data <- icesVMS::get_fo_landings("Barents Sea")
write.taf(vms_landings_data, file = "vms_landings_data.csv", quote = TRUE)

