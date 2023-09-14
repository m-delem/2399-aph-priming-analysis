
# -------------- Sensory priming in aphantasia - Tidying data ------------------

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
  openxlsx,
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

# ---- Extraction and integrating previous data --------------------------------

# the last version of raw data
df_raw <- read_excel("data/aphantasia_priming_data_130923.xlsx")

# retrieving processed data for questionnaires
df_jasp <- read_excel("data/aphantasia_priming_processed.xlsx", sheet = "JASP") 

# finding the participant names with no questionnaire data (N = 15 / 166)
no_questionnaires <- 
  df_jasp %>% 
  filter(is.na(`TOTAL VVIQ /80`)) %>% 
  select(Participants) %>% 
  unlist %>% 
  as.character

# removing their data from the raw dataset
df_raw <- 
  df_raw %>% 
  filter(
    !subjectid %in% no_questionnaires & 
     subjectid != "sbasle" & subjectid != "tmaselli") %>% 
  # renaming some ugly columns
  rename(
    # association task
    correct_association = correct_association_task_response,
    rt_association = response_time_association_task_response,
    # implicit task
    correct_implicit = correct_implicit_task_response,
    rt_implicit = response_time_implicit_task_response,
    # explicit task
    correct_explicit = correct_explicite_task_response,
    rt_explicit = response_time_explicite_task_response,
    # rotation task
    correct_rotation = correct_keyboard_response_rotation_task,
    rt_rotation = response_time_keyboard_response_rotation_task
  ) %>% 
  # subjectid first
  select(subjectid, everything()) %>% 
  # alphabetical order
  arrange(subjectid)

# creating one dataset for each task with relevant columns
df_asso <- 
  df_raw %>% 
  filter(task == "association task") %>% 
  select(
    subjectid,
    orientation, response,
    correct_association,
    rt_association
  )

df_implicit <-
  df_raw %>% 
  filter(task == "implicit task") %>% 
  select(
    subjectid,
    color, congruence, orientation, response,
    correct_implicit,
    rt_implicit
  )

df_explicit <-
  df_raw %>% 
  filter(task == "explicit task") %>% 
  select(
    subjectid,
    color, congruence, orientation, response,
    correct_explicit,
    rt_explicit
  )

df_rotation <-
  df_raw %>% 
  filter(task == "rotation task") %>%   
  select(
    subjectid,
    response,
    correct_rotation,
    rt_rotation,
    stimuli
  )

# questionnaire data
df_questionnaires <-
  df_jasp %>% 
  filter(!is.na(`TOTAL VVIQ /80`)) %>% 
  select(
    Participants, `Âge`, Sexe,
    `TOTAL VVIQ /80`, `TOTAL OBJET /75`, `TOTAL SPATIAL /75`, `TOTAL SUIS /60`
    ) %>% 
  rename(
    subjectid = "Participants",
    age = "Âge",
    sexe = "Sexe",
    vviq80 = `TOTAL VVIQ /80`,
    osiq_o75 = `TOTAL OBJET /75`,
    osiq_s75 = `TOTAL SPATIAL /75`,
    suis60 = `TOTAL SUIS /60`
    ) %>% 
  mutate(sexe = if_else(sexe == "Femme", "f", "h") %>% as.factor) %>% 
  mutate(across(c(age, vviq80:suis60), as.numeric))

# saving in the xlsx
write.xlsx(
  list(
    "data_raw" = df_raw,
    "data_asso" = df_asso,
    "data_implicit" = df_implicit,
    "data_explicit" = df_explicit,
    "data_rotation" = df_rotation,
    "data_questionnaires" = df_questionnaires
    ),
  "data/aphantasia_priming_tidy_data.xlsx",
  asTable = TRUE,
  colNames = TRUE,
  colWidths = "auto",
  borders = "all",
  tableStyle = "TableStyleMedium16"
)
