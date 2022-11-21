### Welcome! --------

# This is an R script file
# Everything written after an hash symbol (#) is a comment
# Everything else is R code

# To execute the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)

# (the command will be automatically "copy/pasted" into the console and executed)

### 1. Creating variables -------

# with R, you can create various kinds of "objects", that can then be manipualted and stored.
# these objects must be named, and can be named however you fancy: be careful though, because object names CANNOT contain spaces.
# The standard naming practices use short but meaningful labesl, in the formats word_word (ex. giulia_object), word_number (giulia_1), or wordWord (giuliaObject), wordN (giulia1).
# R is CASE SENSITIVE: an object called "giulia_object" will not considered the same as an object called Giulia_object.



# several types of objects:

# numbers
my_number <- "1"
my_number # nb. executing an object alone will "print" it in the console

# strings of text (note that strings must be enclosed in quotation marks)
my_string <- "to be or not to be"
my_string

# vectors
my_first_vector <- c(1,2,3,4,5)
my_first_vector

# tip: you can get the same by writing
my_first_vector <- 1:5
my_first_vector

# vectors (of strings)
my_second_vector <- c("to", "be", "or", "not", "to", "be")
my_second_vector

# lists
my_list <- list(1:5, c("to", "be", "or", "not", "to", "be"))
my_list

# tip: you can get the same by writing
my_list <- list(my_first_vector, my_second_vector)
my_list

# dataframes
my_df <- data.frame(
  author = c("Shakespeare", "Dante", "Cervantes", "Pynchon"), 
  nationality = c("English", "Italian", "Spanish", "American")
  )

my_df

View(my_df)

### Your Turn (1) - start

# create a new dataframe with other authors substituting the XXXX
# AFTER you enter your values, press ctrl*ENTER (mac: command+enter) to execute
# you can complete the code here below:

my_new_df <- data.frame(
  author = c(XXXXXX), 
  nationality = c(XXXXX))
View(my_new_df)


## Working directory

# It is very important, as a first step of any project, to check that
# you are working in the right directory.
# try and run this code:

getwd() # getwd is the name of a function, and it tells you it just means "get working directory"

# you will see the working directory you are currently in in the console
# if you want to change the wd, you can do so with the "setwd" function.
# for example:

setwd("05_Working_with_texts/corpus/") # this will make the subfolder "corpus" (already in your project) your working directory
# have a look to check
getwd()


# EXERCISE: Now try and reset the working directory to the original folder (the previous one)
setwd(XXXX)

# you can achieve the same result from the "Files" quadrant of RStudio:
# just navigate inside the folder you'd like to set as wd, click on the little 
# blue wheel on the top right, and click on "Set as working directory".
# You will see that the same formula will appear in the console.



### 2. Accessing variables

# vector subsets
my_first_vector[1]
my_second_vector[1]
my_second_vector[4]
my_second_vector[1:4]
my_second_vector[c(1,4)]

# list subsets
my_list[[1]]
my_list[[1]][4]
my_list[[2]][4]
my_list[[2]][1:3]

# dataframes
my_df$author 
my_df[,1] # the same!!
my_df$nationality
my_df[,2] # the same!!
my_df$author[1:3]
my_df[1:3,1] # the same!!
my_df[1,]
my_df[3,]

# accessing variables in a meaningful way
my_df$author == "Dante"
which(my_df$author == "Dante")
my_df$nationality[which(my_df$author == "Dante")]

### Your Turn (2) - start

# find the author who has "Spanish" nationality
my_df$author[which()]

### Your Turn (2) - end


### 3. Manipulating variables
my_first_vector+1
my_first_vector[2]+1
my_second_vector+1 # this produces an error!!

# manipulating strings
paste(my_string, "?")
strsplit(my_string, " ")
strsplit(my_string, " ")[[1]]
substr(my_string, 1, 5)

### Your Turn (3) - start

# use the "substr" function to extract the second "be" from my_string:
substr()

### Your Turn (3) - end

### 4. Reading/writing text files

#check where your wd is
getwd()
# and set "corpus" as wd
setwd()

# read text line by line
my_text <- readLines("Cbronte_Jane_1847.txt")
head(my_text, 5)


# write file
cat("The cat is on the table")
cat("The cat is on the table", file = "Cat.txt")

### 5. Making loops

# basic loop
for(i in 1:10){
  print(i)
}

# if conditions
for(i in 1:10){
  if(i == 1){
    print(i)
  }
}

# if/else conditions
for(i in 1:10){
  if(i == 1){
    print(i)
  }else{
    print("more than one")
  }
}

# the sapply/lapply functions
# (with a simple example: increase the values in one vector)
my_vector <- 1:10
my_vector
for(i in 1:10){
  
  my_vector[i] <- my_vector[i]+1
  
}
my_vector

# it is the same of this sapply function:
my_vector <- 1:10
my_vector <- sapply(my_vector, function(x) x+1)
my_vector

# if you are working with lists, then you can use lapply
my_list <- list(1:10, 2:20)
my_list <- lapply(my_list, function(x) x+1)
my_list

# why use sapply/lapply? Because they are faster than a loop

### 6. Functions

# basic (stupid) example
my_function <- function(){
  cat("Ciao")
}

my_function()

### 7. Packages

# install (this should be done just once)
install.packages("tidyverse")

# load (this should be done every time you start R!)
library(tidyverse)
# more efficient ways to manage dataframes

# for example: find the Italian author in our dataframe of authors
# with base R, you should do like that
my_df[which(my_df$nationality == "Italian"),]

# with tidyverse, you do like
my_df %>% filter(nationality == "Italian")

### Appendix
# note: the "<-" sign can be substitited by "="
my_variable <- "Shakespeare"
my_variable = "Shakespeare"
# still, it is advised to distinguish between the two, as the "<-" sign has a "stronger" function. See for example in the creation of a dataframe
my_df <- data.frame(author = c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality = c("English", "Italian", "Spanish", "American"))
author # it does not exist!!

my_df_2 <- data.frame(author <- c("Shakespeare", "Dante", "Cervantes", "Pynchon"), nationality <- c("English", "Italian", "Spanish", "American"))
author # now it exists!!
