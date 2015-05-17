require(knitr)
require(markdown)
knit("PA1.Rmd", encoding="UTF-8")
markdownToHTML("PA1.md", "PA1.html")