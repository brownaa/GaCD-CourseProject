#Documentation for *run_analysis.r*
This document summarizes the analysis and provides information about how and why the analysis was performed.

##Purpose
The [run_analysis.r](https://github.com/brownaa/GaCD-CourseProject/blob/master/run_analysis.R) script is used to tidy and write a summary tidy dataset to the working directory.  This script was created to fulfill the requirements as outline in the Course Project for the [Getting and Cleaning Data](https://class.coursera.org/getdata-011/) Coursera class.

##Setup
The entire analysis can be run from the R script [run_analysis.r](https://github.com/brownaa/GaCD-CourseProject/blob/master/run_analysis.R).  All code was written using relative paths to whatever the current working directory is.

Cloning the Git repository will retrieve all of the necessary raw data, or the first tasks executed will download all of the necessary files for the analysis and save them to the relevant local directories.

**An internet connection is required to retrieve the files from Github or to execute the R script file.**

My **sessioninfo()** is below.

    R version 3.1.1 (2014-07-10)
    Platform: x86_64-w64-mingw32/x64 (64-bit)
    
    locale:
    [1] LC_COLLATE=English_United States.1252 
    [2] LC_CTYPE=English_United States.1252   
    [3] LC_MONETARY=English_United States.1252
    [4] LC_NUMERIC=C                          
    [5] LC_TIME=English_United States.1252    
    
    attached base packages:
    [1] stats     graphics 
    [3] grDevices utils    
    [5] datasets  methods  
    [7] base     
    
    other attached packages:
    [1] dplyr_0.2
    
    loaded via a namespace (and not attached):
    [1] assertthat_0.1  
    [2] digest_0.6.4    
    [3] htmltools_0.2.6 
    [4] magrittr_1.0.1  
    [5] parallel_3.1.1  
    [6] Rcpp_0.11.3     
    [7] rmarkdown_0.3.11
    [8] tools_3.1.1

##How the script works
The following steps describe how the raw data is read, formatted and labelled according the the course project requirements.

1. The script checks if the raw data is available.  If it is not present or the data is not in the correct directory, the script will create and download the data from the internet.
2. The downloaded files are unzipped and read into R's memory space.
    - We also read in associated files which help complete later steps (e.g., features.txt, activity_labels.txt)
3. Combining the test and training datasets into one table is accomplished by
      1. Row binding (rbind) the test and training datasets (R Objects: *subject*, *x*, and *y*)
      2. Column binding (cbind) the R objects *subject*, *x*, and *y*
      3. The final step is to replace the activity numbers with descriptive factors using the R object *activity.names* using the [merge](https://stat.ethz.ch/R-manual/R-patched/library/base/html/merge.html) function.
4. In the last cleanup step, we identify the variables that represent the mean and standard deviation and delete all of the other variables from the dataframe

The final task of the course project is to summarize the data by taking the average of each variable for each activity and each subject.  This is accomplished in one step using the [dplyr](http://cran.r-project.org/web/packages/dplyr/dplyr.pdf) package.

This final dataframe is then written to the file [summarized_data.txt](https://github.com/brownaa/GaCD-CourseProject/blob/master/summarized_data.txt) (a copy of this data is also uploaded to the course website).

##Codebook
The codebook for the file [summarized_data.txt](https://github.com/brownaa/GaCD-CourseProject/blob/master/summarized_data.txt) is located in the Github repository [here](replace this link).