library(tidyverse)
library(here)
library(cowplot)

knitr::opts_chunk$set(
  echo=FALSE, message=FALSE, warning=FALSE
)

mydata <- diamonds

# RENDER ANALYSIS FILES #####
myplots <- list()

rmarkdown::render('./src/sci_article_with_R_analysis1.Rmd', output_dir='html')
source('src/sci_article_with_R_figs.R')


# RENDER MANUSCRIPT FILES #####
rmarkdown::render("manuscript/article_ms.Rmd", 
                  bookdown::pdf_book(base_format=rticles::plos_article, fig_width=4.75*14/9, fig_height=2.25*14/9))

rmarkdown::render("manuscript/article_SM.Rmd", 
                  bookdown::pdf_book(base_format=rticles::plos_article, fig_width=4.75*14/9, fig_height=2.25*14/9))

(function(.dir, .files) {
  setwd("manuscript")
  tinytex::pdflatex("article_ms.tex", clean=FALSE)
  tinytex::pdflatex("article_SM.tex", clean=FALSE)
  
  tinytex::pdflatex("article_ms.tex", clean=TRUE)
  tinytex::pdflatex("article_SM.tex", clean=TRUE)
  setwd('..')
})()
