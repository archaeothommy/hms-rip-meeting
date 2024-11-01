# Function to programmatically turn abstracts in table into single quarto markdown documents for listings page 

# import abstract data and clean-up table

library(googlesheets4)
library(readxl)

date <- "2024" # year of workshop

max_author <- 6 # maximum number of authors in table

data <- read_excel("../2024/Abstracts.xlsx", range = "D1:AQ23", col_types = "text")

data <- subset(
  data, select = c(
    "Order",
    "Email Address", 
    "Title of abstract", 
    "Keywords", 
    "Abstract", 
    grep("^Full", names(data), value = TRUE), 
    grep("^Affiliation", names(data), value = TRUE), 
    grep("^ORCID", names(data), value = TRUE), 
    grep("^Institution", names(data), value = TRUE)
  ), 
  subset = !is.na(Abstract)
)

names(data) <- c("Order", "Mail", "Title", "Keywords", "Abstract", paste0("Author_", 1:max_author), paste0("Affiliation_", 1:max_author), paste0("ORCID_", 1:max_author), paste0("Institution_", 1:5))

data$Keywords <- gsub(";", ",", data$Keywords)

# create article

for (i in 1:nrow(data)) {
  
  cat(
    '---', 
    paste0('title: "', data$Title[i], '"'), 
    paste0('date: "', date, '"'), 
    'date-format: "YYYY"',
    paste0('categories: [', data$Keywords[i], ']'), 
    
    # Author 1
    'author: ',
    paste0('  - name: ', data$Author_1[i]), 
    if (!is.na(data$ORCID_1[i])) {paste0('    orcid: ', data$ORCID_1[i])},
    '    corresponding: true', 
    paste0('    email: ', data$Mail[i]), 
    
    # Author 2
    if (!is.na(data$Author_2[i])) {paste0('  - name: ', data$Author_2[i])},
    if (!is.na(data$ORCID_2[i])) {paste0('    orcid: ', data$ORCID_2[i])}, 
    
    # Author 3
    if (!is.na(data$Author_3[i])) {paste0('  - name: ', data$Author_3[i])},
    if (!is.na(data$ORCID_3[i])) {paste0('    orcid: ', data$ORCID_3[i])}, 
    
    # Author 4
    if (!is.na(data$Author_4[i])) {paste0('  - name: ', data$Author_4[i])},
    if (!is.na(data$ORCID_4[i])) {paste0('    orcid: ', data$ORCID_4[i])}, 
    
    # Author 5
    if (!is.na(data$Author_5[i])) {paste0('  - name: ', data$Author_5[i])},
    if (!is.na(data$ORCID_5[i])) {paste0('    orcid: ', data$ORCID_5[i])}, 
    
    # Author 6
    if (!is.na(data$Author_6[i])) {paste0('  - name: ', data$Author_6[i])},
    if (!is.na(data$ORCID_6[i])) {paste0('    orcid: ', data$ORCID_6[i])}, 
    
#    # Author 7
#    if (!is.na(data$Author_7[i])) {paste0('  - name: ', data$Author_7[i])},
#    if (!is.na(data$ORCID_7[i])) {paste0('    orcid: ', data$ORCID_7[i])}, 
    
#    # Author 8
#    if (!is.na(data$Author_8[i])) {paste0('  - name: ', data$Author_8[i])},
#    if (!is.na(data$ORCID_8[i])) {paste0('    orcid: ', data$ORCID_8[i])}, 
    
#    # Author 9
#    if (!is.na(data$Author_9[i])) {paste0('  - name: ', data$Author_9[i])},
#    if (!is.na(data$ORCID_9[i])) {paste0('    orcid: ', data$ORCID_9[i])}, 
    
#    # Author 10
#    if (!is.na(data$Author_10[i])) {paste0('  - name: ', data$Author_10[i])},
#    if (!is.na(data$ORCID_10[i])) {paste0('    orcid: ', data$ORCID_10[i])}, 
    
    '---', 
    '', 
    data$Abstract[i], 
    '', 
    '::: {layout="[ 20 , 85 ]"}

::: {#column-image}
[![](https://i.creativecommons.org/l/by/4.0/88x31.png){width=88}](http://creativecommons.org/licenses/by/4.0/)
:::

::: {#column-text}
This work are licensed under a<br>[Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).
:::

:::',
    sep = "\n", 
    file = paste0('abstracts/', date, "-", data$Order[i], '.qmd')
  )
}

