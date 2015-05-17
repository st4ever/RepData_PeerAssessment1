Reproducible Research: Peer Assessment 1
========================================

Load the data (note that the data is already archived in the repository).


```r
unzip("activity.zip")
```

```
## Warning in unzip("activity.zip"): error 1 in extracting from zip file
```

```r
activityDF <- read.csv( "activity.csv",
  sep=",",
	header=TRUE,
	na.strings="NA",
	colClasses=c("numeric", "character", "numeric")
	)
```

```
## Warning in file(file, "rt"): cannot open file 'activity.csv': No such file
## or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

We ignore (filter out) the missing values (NAs) in the dataset for the first part.


```r
completeDF <- activityDF[!is.na(activityDF$steps),]
```

Summarize complete (without NAs) activity data.


```r
summary(completeDF)
```

```
##      steps            date              interval     
##  Min.   :  0.00   Length:15264       Min.   :   0.0  
##  1st Qu.:  0.00   Class :character   1st Qu.: 588.8  
##  Median :  0.00   Mode  :character   Median :1177.5  
##  Mean   : 37.38                      Mean   :1177.5  
##  3rd Qu.: 12.00                      3rd Qu.:1766.2  
##  Max.   :806.00                      Max.   :2355.0
```

Now we examine the mean total number of steps taken per day.

A Histogram of the total number of steps taken each day,


```r
stepsByDate <- aggregate(steps ~ date, data = completeDF, FUN=sum)
barplot(stepsByDate$steps, names.arg=stepsByDate$date, xlab = "Date", ylab = "Number of Steps")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

Mean total number of steps taken per day,


```r
mean(stepsByDate$steps)
```

```
## [1] 10766.19
```

Median total number of steps taken per day,


```r
median(stepsByDate$steps) 
```

```
## [1] 10765
```

Now let's look at the average daily activity pattern

Time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
stepsByInterval <- aggregate(steps ~ interval, data=completeDF, FUN=mean)
plot(stepsByInterval, type="l")
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 

Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
stepsByInterval$interval[which.max(stepsByInterval$steps)]
```

```
## [1] 835
```


## Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

Total number of missing values in the data set is the number of measured steps minus the number of complete rows,


```r
length(activityDF$steps) - length(completeDF$steps)
```

```
## [1] 2304
```

Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
Create a new dataset that is equal to the original dataset but with the missing data filled in.


```r
stepsByDate <- aggregate(steps ~ date, data = activityDF, FUN=sum)
filledDF <- merge(activityDF, stepsByDate, by="date", suffixes=c("",".new"))
naSteps <- is.na(filledDF$steps)
filledDF$steps[naSteps] <- filledDF$steps.new[naSteps]
filledDF <- filledDF[,1:3]
```

Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 


```r
stepsByDate <- aggregate(steps ~ date, data=filledDF, FUN=sum)
barplot(stepsByDate$steps, names.arg=stepsByDate$date, xlab="Date", ylab="Number of Steps")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 

Mean for the missing data filled in.


```r
mean(stepsByDate$steps)
```

```
## [1] 10766.19
```

Median for missing data filled in.


```r
median(stepsByDate$steps)
```

```
## [1] 10765
```
*Do these values differ from the estimates from the first part of the assignment?*

No, they do not.

*What is the impact of imputing missing data on the estimates of the total daily number of steps?*

Little to no impact.

## Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

Create a new factor variable in the dataset with two levels 
