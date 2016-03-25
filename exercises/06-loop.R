library(rmarkdown)

weekdays <- c("Sunday", "Monday", "Tuesday", 
  "Wednesday", "Thursday", "Friday", "Saturday")

for (i in weekdays) {
  rmarkdown::render("exercises/06-parameters-answer.Rmd", 
    params = list(dow = i),
    output_file = paste0("delays_", i, ".html")
  )
}