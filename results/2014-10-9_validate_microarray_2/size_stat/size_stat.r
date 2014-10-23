
#/home/chuan/footprint/results/2014-10-9_validate_microarray_2/size_stat

> default <- read.table("size_default.txt", header=F)
> loose <- read.table("size_loose.txt", header=F)
> strict <- read.table("size_strict.txt", header=F)
> summary(default)
V1       
Min.   : 32.0  
1st Qu.: 57.0  
Median : 90.0  
Mean   :105.9  
3rd Qu.:132.2  
Max.   :526.0  
> summary(loose)
V1       
Min.   : 32.0  
1st Qu.: 60.0  
Median :105.0  
Mean   :122.7  
3rd Qu.:148.0  
Max.   :588.0  
> summary(strict)
V1        
Min.   : 41.00  
1st Qu.: 51.00  
Median : 59.00  
Mean   : 66.84  
3rd Qu.: 70.00  
Max.   :250.00  

> nrow(default)
[1] 500
> nrow(loose)
[1] 500
> nrow(strict)
[1] 500
> 

