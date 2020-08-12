# Tidyverse-Data-Pipeline

This R package extracts data from CSV files, transform it and saves the results as separate files. 
It also allows user to load data into the Postgres database. 


The package was uploaded to R Studio Cloud. 
You can find it here:
https://rstudio.cloud/project/1516312

The Package is already deployed there - you can run it without any installation.

All you have to do is to type this command in its R console:

```R
devtools::load_all(".")
```


If you'd prefer not to log in to the R Studio Cloud follow the steps below.

## 1. Local package installation

You can skip this part if you are going to use R Studio Cloud.
Otherwise, follow the steps below.

### Download and install R
To install the package you need to have R installed on your machine (https://www.r-project.org/).

### Install required R packages
There are also required two packages, *devtools* and *roxygen2*, which you can install by typing this command in bash:

```console
$ R -e "install.packages(c('devtools', 'roxygen2'))"
```

### Install ETLPackage

Pull the *Tidyverse-Data-Pipeline* repository, for example:

```console
$ git pull https://github.com/vonshick/Tidyverse-Data-Pipeline.git
```

Go to the source code directory, for example:

```console
$ cd ~/Tidyverse-Data-Pipeline/
```

Run the package installation:

```console
$ R -e "devtools::install()"
```


## 2. Scripts description

### 2.1 extract_data_from_files.R

This script extracts data from CSV files and checks if the data is correct (tasks 1 and 2).

I used *readr* package to load the data. It automatically infers the schema of a CSV file (also the column types). If any record does not match the pattern we get the warning. 
In case of loading the three files no warning appeared (all the numeric columns were parsed correctly).

Only one step of data validation was added to the script - testing if ID is unique for each data set. 
I didn't see a reason to remove any of the records.
E.g. I found some special characters in class names but I was not convinced if it's the reason to drop the appropriate values.

In my opinion decision to remove some records (or to automate removing of them) may be taken after a conversation with the data owner / client who knows their business purpose best.

I attached the example tests I made during the data exploration in ```exploration.R``` file.

Command to run (in RStudio Cloud):
```R
get_raw_data_sets()
```

To run the function in bash you need to type the function this way:
```shell
$ R -e "get_raw_data_sets()"
```

Similarly for all the examples below.

### 2.2 transform_data_to_result_dataset.R

This script executes the first script and transforms the data to the desired aggregations (tasks 3 and 4). 

Command to run:
```R
generate_output_data_sets()
```

### 2.3 save_output_files.R

The script runs previous scripts and saves the result to separate CSV files in ```data_files``` directory.

Command to run:
```R
save_output_csv_files()
```

### 2.4 load_tables_to_db.R

The script connects to Postgres database and loads the result tables into it. 
Information necessary to create a connection (database name, host, port, etc.) need to be passed in ```environment_variables.R``` file.

Command to run:
```R
load_tables_to_database()
```

## 3. Unit tests

There were also provided three simple unit tests. 
They check whether data sets contain appropriate columns.

Command to run the tests:
```R
devtools::test()
```