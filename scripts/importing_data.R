
# ------------ Sensory priming in aphantasia - Importing data ------------------

# Maël Delem
# Email : m.delem@univ-lyon2.fr

# ---- Packages ----------------------------------------------------------------

# librairian will ease the package management with the "shelf" function
if (!require(librarian)) install.packages(librarian)
library(librarian)

# now putting packages on our library's shelves:
shelf(
  quarto,
  # --- xlsx, json, txt file management
  readxl,
  jsonlite,
  fs,
  # --- data analysis packages:
  easystats,      # framework for data analysis functions
  # MASS,           # Box-Cox transformation
  # cluster,        # self-explanatory (i.e. cluster analyses)
  # mclust,         # mixture clustering
  # factoextra,     # multivariate analysis visualization
  # FactoMineR,     # multivariate analysis
  # rstanarm,       # bayesian models
  # BayesFactor,    # self-explanatory (i.e. Bayes Factors)
  # --- data visualization/exploration packages:
  ggpubr,         # layout and statistics display
  ggradar,        # radar charts
  ggsci,          # scientific palettes
  wesanderson,    # artistic palettes
  viridis,        # colour-blind friendly palettes
  # --- tables
  # qwraps2,        # mean_sd function
  # and the basics:
  tidyverse
)

# ---- Extraction --------------------------------------------------------------

# --- retrieving file paths for each .txt datafile
# listing all folders in the data folder
datafiles <-
  dir_ls(path = "data", regexp = "study") %>% 
  # transforming it into a character vector
  as.character() %>% 
  # searching the subfolder for each folder...
  map_chr(dir_ls) %>% 
  # ... and the datafile in each subfolder.
  map_chr(dir_ls)

# --- reading the .txt as JSON
jsons <- datafiles %>% map(read_json) 

# --- rectangling into a dataframe
df <-
  jsons %>% 
  tibble() %>% 
  rename(data = ".") %>% 
  unnest_wider(data) %>% 
  unnest_longer(data) %>% 
  unnest_wider(data)
