tP1 <- fluidPage( 
  sidebarLayout( 
    sidebarPanel( 
      tabsetPanel( 
        tabPanel(
          "Base Parameters", 
          sliderInput( inputId = "b0", 
                       label = "Per-capita birth rate at N = 0:", 
                       min = 0, 
                       max = 2, 
                       value = 0.25, 
                       step = 0.01 ),
          sliderInput( inputId = "d0", 
                       label = "Per-capita death rate at N = 0:", 
                       min = 0, 
                       max = 1, 
                       value = 0.01, 
                       step = 0.01 ), 
          sliderInput( inputId = "N0", 
                       label = "Initial population size:", 
                       min = 0, 
                       max = 5000, 
                       value = 50, 
                       step = 5 ), 
          sliderInput( inputId = "K", 
                       label = "Carrying capacity:", 
                       min = 0, 
                       max = 100000, 
                       value = 20000, 
                       step = 100 )
          
         ), 
        tabPanel(
          "Habitat Parameters", 
          sliderInput( inputId = "hqlty", 
                       label = "Indicate relative habitat quality:", 
                       min = -1, 
                       max = 1, 
                       value = 0, 
                       step = 0.1 ), 
          sliderInput( inputId = "hqnty", 
                       label = "Indicate relative habitat quantity:", 
                       min = 0, 
                       max = 2, 
                       value = 1, 
                       step = 0.1 )
        ),
        tabPanel( 
          "Harvest Parameters", 
          radioButtons( inputId = "hType", 
                        label = "Select harvest type:", 
                        choices = c( "None" = "n", 
                                     "Fixed Proportion" = "fp", 
                                     "Fixed Quota" = "fq" ), 
                        selected = "n", 
                        inline = TRUE ), 
          conditionalPanel( condition = "input.hType == 'fp'", 
                            sliderInput( inputId = "fpH", 
                                         label = "Indicate proportion of harvest:", 
                                         min = 0, 
                                         max = 1, 
                                         value = 0, 
                                         step = 0.01 ) ), 
          conditionalPanel( condition = "input.hType == 'fq'", 
                            sliderInput( inputId = "fqH", 
                                         label = "Indicate harvest quota:", 
                                         min = 0, 
                                         max = 1000, 
                                         value = 0, 
                                         step = 10 ) )
        )
      ) 
    ), 
    mainPanel(
      plotOutput( outputId = "popPlot" ), 
      plotOutput( outputId = "ratePlot" )
    )
  )
)
tP2 <- fluidPage()