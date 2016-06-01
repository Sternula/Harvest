library( shiny )
library( markdown )

source( "tabPanels.R", local = TRUE )

shinyUI( 
  navbarPage( "Harvest Case", 
              tabPanel( "Introduction", 
                        withMathJax(), 
                        includeMarkdown( "introduction.md" ), 
                        value = "tP0" ), 
              tabPanel( "Model", tP1, value = "tP1" ), 
              id = "panels" )
)