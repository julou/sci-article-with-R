This is a template for an RStudio project with data analysis and manuscript writing (including main text and supp mat with crossreferences).


## Directory structure

- `src` contains .Rmd files or notebook for data analysis (which can be rendered individually or as a small website).
- `manuscript` contains .Rmd files to write the article, intermediate compilation files and final pdf files.
- `plots` contains the figures used in the article (but not necessarily in the supplement).
- `sci_article_with_R.R` contains all command to load data, run the analysis by executing tye notebook files, and render the article by running the manuscript file.
- it is recommended to create a `data` directory to store files with raw data; alternatively, it can be a symlink to a centralised data directory.


## Design choices

Although Rmarkdown makes it easy to analyse data and render reports / manuscripts, there are various caveats on how to conveniently achieve these tasks together. Here are several recommendations to conveniently use this template:

- the general workflow is organised as follow, in order to separate as much as possible code and writing:
    + data are loaded in the main R script `sci_article_with_R.R`.
    + various analysis are run in notebooks, possibly including tables / plots that won't make it to the final report; it is recommended to document the analysis strategy and the main conclusion at each point with short paragraphs.
    + manuscripts are written with minimal R code (calling already saved tables / plots) in order to maximise the readability.
- render Rmarkdown analysis files from the command line so that they are all executed in the global environment; in particular this allows to structure the analysis in several files which can be rendered one after the other.
- in order to avoid duplication of figures' code, I recommend to store figures used in the final reports / manuscript in a list (e.g. `myplots <- list()`); note that it is possible to print an object (in this case a plot) while assigning it to a variable by enclosing the expression in brackets: `(myplots[['carat-histo']] <- qplot(carat, data=diamonds))`
- crossreferences between files are possible thanks to latex `xr` package, included in the `header-includes` field of the YAML header. In order to resolve them, the `.aux` files should not be cleaned which is not possible with pandoc, hence the final pdf is rendered in 3 steps (each run on both files at the same time):
    1. `rmarkdown::render()` is called to produce both `.tex` files
    2. `tinytex::pdflatex(..., clean=FALSE)` to compile them while keeping the `.aux` files
    3. `tinytex::pdflatex()` is called again to compile the `.tex` files with the crossreferences resolved since both `.aux` files are present.


## Polishing figures
- the package `cowplot` provides a slick theme for publication-ready figures.
- in order to use text and symbols (points, lines, strokes, etc) of compatible weight in the figure, it is convenient to keep the default base_size of the theme and to scale the entire figure. If the joural guidelines specify figures of 4.75 in width with font 9pt, knowing `cowplot`'s base_size is 14, the figure will be saved with width 4.75 * 14/9 and displayed with 4.75 in.
- when many low opacity points are overlapped, it looks nicer to set `stroke = 0`.

## Writing the manuscript
- use html syntax for comments (RStudio's shortcut is cmd-shift-C): `<!-- # this is a comment -->`
- references are best achieved using bookdown's syntax `\@(fig:this-fig-label)` which also allows crossreferencing between files.
- figures saved independently (e.g. or the main txt or prepared outside of R) should be included using `knitr::include_graphics()`
- figures' captions are conveniently written using the syntax based on reference (allows to use markdown syntax in the caption):

````
(ref:this-fig-caption) A useful figure title.
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. 

```{r this-fig, out.width="100%", fig.cap='(ref:this-fig-caption)'}
knitr::include_graphics(here('plots', 'this_fig.pdf'))
```
````

- citations are conveniently inserted (and the reference added to the .bib file) directly from a reference manager using the `citr` addin.

