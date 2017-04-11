##This is a quick script to reformat rasters into functionmain LANDIS-II input maps
library(raster)
eco.raster <- raster("I:/SNPLMA3/LANDIS_modeling/LTW_NECN_H/Century_input_maps/ecoregions5.img")
eco.res<- res(eco.raster)
eco.crs<- crs(eco.raster) 
eco.extent<-extent(eco.raster)
eco.prj<-projection(eco.raster)

##Need to reclassify drainage to 0-1
drain.raster <- raster("I:/SNPLMA3/Data/GIS/drain_mosaic1.img", template = eco.raster)
projection(drain.raster) <- eco.prj
extent(drain.raster) <- eco.extent
new.drain<-projectRaster(drain.raster, eco.raster, crs=prj, method="bilinear")
new.drain[is.na(new.drain)] <- 0
rc <- c(-Inf, 0, 0, 0, 1, ((1/7)*1),  1, 2, ((1/7)*2), 2, 3, ((1/7)*3), 3, 4, ((1/7)*4), 
        4, 5, ((1/7)*5), 5, 6, ((1/7)*6), 6, 7.5, ((1/7)*7))
rc.mtrx <- matrix(rc, ncol=3, byrow=TRUE)
new.drain.rc <- reclassify(new.drain, rc.mtrx)
writeRaster(new.drain.rc, "I:/SNPLMA3/LANDIS_modeling/LTW_NECN_H/NECN_input_maps/drain_cont.img", overwrite=TRUE)
rm(rc)
rm(rc.mtrx)

depth.raster <- raster("I:/SNPLMA3/Data/GIS/depth_mosaic1.img", template = eco.raster)
projection(depth.raster) <- eco.prj
extent(depth.raster) <- eco.extent
new.depth<-projectRaster(depth.raster, eco.raster, crs=prj, method="bilinear")
new.depth[is.na(new.depth)] <- 1
rc <- c(-1, 2, 1.0, 100, 205, 100)
rc.mtrx <- matrix(rc, ncol=3, byrow=TRUE)
new.depth.rc <- reclassify(new.depth, rc.mtrx)
writeRaster(new.depth.rc, "I:/SNPLMA3/LANDIS_modeling/LTW_NECN_H/NECN_input_maps/depth_cont.img", overwrite=TRUE)

aws.raster <- raster("I:/SNPLMA3/Data/GIS/aws_mosaic.img", template = eco.raster)
projection(aws.raster) <- eco.prj
extent(aws.raster) <- eco.extent
new.aws<-projectRaster(aws.raster, eco.raster, crs=prj, method="bilinear")
writeRaster(new.aws, "I:/SNPLMA3/LANDIS_modeling/LTW_NECN_H/NECN_input_maps/aws_cont.img")
