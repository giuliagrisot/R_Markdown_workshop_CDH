# How to create a corpus of texts for analyses with R Studio -----

# RECAP:

# This is an R script file, created by Giulia (reads like English "Julia")

# Everything written after an hashtag is a comment (normally appears in green). If you don't want to type the hash manually every time, you can type your comments normally, and after you finish, with the cursor on the sentence, press ctrl+shift+c. it will turn text into a comment and vice versa.

# Everything else is R code. To execute the code, place the cursor on the corresponding line and press Ctrl+Enter (windows)

# To complete this script, you will not need much knowledge of R: the codes are provided for you.
# If you are unfamiliar with R language and basic operations and want to learn more about it, there is plenty of tutorials online. Have a look at the resources at the end of this script for a few recommendations.

# before you start, check the working directory!
# you can click on the Files panel, go to the Bielefeld_Hackaton_2022 folder, and once you are inside click on the little arrow near the "More" button, and select "Set as working directory"


# now we're ready to start!




# PS: Have you noticed that there is a little symbol on the top right of this panel, made of little horizontal lines? It shows and hide the document outline. if you write a comment and put a series of --------- (any number, more than 4) after it, the comment will become the header of a section, which you can then see in the outline for an easier navigation of the script.



# Creating your dataset ----------

# Often, one of the factors that prevents us humanists from working with RStudio for analysing texts is that tutorials assume a certain amount of (magically) pre-existing knowledge. 
# Unfortunately, we often do not have that, nor a magic wand.
# So it happens that right when you want to finally try to use someone else's existing scripts and make them work with your lovely literary texts (yes, thas's how we often do, and it's ok!), you are not really sure how to put those books into a shape that you can use.

# Here we will try and show how different text formats can be imported in R and made ready for some analysis.

## packages -----


# Before you begin you will need to load some packages. These allow you to execute specific operations.
# If you have not done so already, you have to install them first: it might take a few minutes and you only have to do it once. If R asks you whether you want to install dependencies for the packages, say yes.
# 
# install.packages("tidyverse")
# install.packages("readr")
# install.packages("data.table")
# install.packages("tm")
# install.packages("tidytext")
# install.packages("syuzhet")
# install.packages("sjPlot")
# install.packages("wordcloud")
# install.packages("readxl")

# NB!!! Once you have installed the packeges, comment the installation code:
# you can do this by selecting the relevant lines and clicking CRTL+SHIFT+C (Cmd+Shift+C on Mac)

# the text should then become green, and this operation will not be 
# executed again in the future, unless you uncomment the lines again.

# what you will need to do (every time you restart RStudio to work on a script)
# is to load the packages you'll need.

library(tidyverse)
library(readxl)
library(readr)
library(data.table)
library(tm)
library(tidytext)
library(sjPlot)
library(wordcloud)


# Importing data ----

## txt ----

# One easy way to import texts into R is to start from txt files.

# You might have more than one, so it is important that you store them all together in one folder, and ideally with a consistent filename. Information in the filename can be used later on to add metadata to your dataset. The format "surname_title_year.txt" could be a good option, for example, where the surname and the title have to be one word.

# In order to import a txt file, you can use the "read.delim" function from base R (which means you do not need to install extra packages). 

# let's try it out. As you can see in the files panels, there is a folder called "samples", where some texts in different formats are stored.

# before you execute the code, make sure the working directory is set to "04_Working_with_texts"

setwd("04_Working_with_texts")


pride <- read.delim("samples/austen_pride_1813.txt", # this is the url to your file
                    fileEncoding = "utf-8",  # we want to read it as unicode text
                    header = F) %>% # we do not want the first line as a header 
  rename(text = V1) # we can name the column text

# your file has been imported! 
# Have a look at the first rows to see how it looks
# execute the next code cunk or click on the "pride" element in your environment

head(pride)




# when importing a txt file, the paragraphs are automatically converted into new rows. if you want to have a single string instead, you can transform it, telling R to combine the rows, and to add "\n " (a conventional code for a new line) between one piece of string and the next, as follows:

pride_whole <- paste(unlist(pride), collapse ="\n")

head(substr(pride_whole, 1,100)) # the function substr() allows yiou to select a portion of a tring of characters.

pride_whole_tibble <- as_tibble(pride_whole)

# you can then split it into sentences, for instance with packages syuzhet (the result will be a list of strings)

pride_sentences <- syuzhet::get_sentences(pride_whole)

head(pride_sentences, 1)

# or with the package tidytext (this will turn into a dataframe)

pride_sentences <- unnest_sentences(pride, 
                                    input = text,
                                    output = "sentence_text",
                                    to_lower = F)

head(pride_sentences)

## multiple txt files ----------

# if you have more than one text, you probably won't want to repeat this operations manually several times.
# you can then proceed as follows:
# (this is just one way but there are many out there)

# - create a silt of the files inside the folder that match the criteria (txt)

corpus_files <- list.files(path = "samples", pattern = "*.txt", full.names = T)


corpus_source <- corpus_files %>%  
  set_names(.) %>% 
  map_df(read.delim, fileEncoding = "utf-8", 
         .id = "FileName", 
         header = F) %>%
  rename(text = V1)


head(corpus_source)


# let's see which files are in our corpus:

corpus_source %>% 
  select(FileName) %>%
  distinct()


# now, as we mentioned you might want to use the information in the filename to create more variables (that's how "columns" are called in R) in our corpus

corpus <- corpus_source %>%
  mutate(FileName = str_remove_all(FileName, "samples/")) %>% # let's remove the directory from the filename
  separate(FileName, into = c("author", "title", "year"), sep = "_", remove = T) %>% # and separate the metadata
  mutate(year = str_remove(str_trim(year, side = "both"), ".txt")) # and make sure there are no extra spaces before/after the words

corpus$year <- as.numeric(corpus$year)

# click on corpus and see how it looks. Neat, right?

# you might also want to add an identification number for the sentences, which can be useful for later analysis

corpus <- corpus %>%
  group_by(title) %>%
  mutate(sentence_id = seq_along(text)) %>%
  ungroup()


head(corpus, 5)


## csv and xslx ----

# another common format for texts is csv or xlsx. Importing a this is very easy, because R understands the csv and xslx formats well. You can either use code, or click directly on the file you want to import in the files panel.
# R studio will ask if you want to import it, and you will be able to determine options with a friendly interface.

# navigate into the samples folder and click on the file small_corpus.xlsx. or 
# execute the following code

pride_excel <- read_excel("../R_Markdown_workshop_CDH/05_Working_with_texts/samples/pride.xlsx") %>%
  unnest_sentences(input = text, output = sentence, to_lower = F)

# have a look at it

head(pride_excel)


## multiple files ----

# the procedure similar to the one we saw for the txt files, except it has read_excel as function, and it does not need to add a header or other variables

corpus_files <- list.files(path = "samples", pattern = "*.xlsx",  full.names = T)


corpus_source <- corpus_files %>%  
  set_names(.) %>% 
  map_df(read_excel)

head(corpus_source)

## epubs ----------

## another format that is quite popular today, especially for books, is the epub
## for these files you will need a specific package, calle "epubr"

install.packages("epubr")

library(epubr)

kafka_all <- epubr::epub("samples/kafka.epub")

# have a look a the dataset "kafka_all": epubs often have a more complex internal structure, and you might need to modify your dataset according to your needs

kafka_werke <- kafka_all[[9]][[1]]

# the content is often nested and you really need to know what you are looking for to extract it

kafka_werke %>%
  filter(nword!=0) %>%
  head()


setwd("../../R_Markdown_workshop_CDH/")
