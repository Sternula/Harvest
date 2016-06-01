library( shiny )
library( ggplot2 )
library( gridExtra )
library( tidyr )

shinyServer( 
  function( input, output, session ){
    
    toTime <- 100
    
    theFacts <- reactive( {
      
      factsdf <- data.frame( t = 1:toTime, 
                             N_o = input$N0 )
      
      
      ## K <-  input$K
      ## updateSliderInput( session, "N0", max = K )
      parameters <- list( b0 = ifelse( ( input$b0 + ( 0.5 * input$hqlty ) ) >= 0, input$b0 + ( 0.5 * input$hqlty ), 0 ), 
                          d0 = input$d0, 
                          K = input$K )
      
      for( i in 2:toTime ){
        factsdf$N_o[ i ] <- factsdf$N_o[ i - 1 ] * exp( ( parameters$b0 - parameters$d0 ) * ( 1 - ( factsdf$N_o[ i - 1 ] / parameters$K ) ) )
      }
      
      if( "fp" %in% input$hType ){
        factsdf$N_fpH <- factsdf$N_o
        for( i in 2:toTime ){
          factsdf$N_fpH[ i ] <- factsdf$N_fpH[ i - 1 ] * exp( ( parameters$b0 - parameters$d0 ) * ( 1 - ( factsdf$N_fpH[ i - 1 ] / parameters$K ) ) ) - ( input$fpH * factsdf$N_fpH[ i - 1 ] )
        }
      }
      
      if( "fq" %in% input$hType ){
        factsdf$N_fqH <- factsdf$N_o
        for( i in 2:toTime ){
          h <- ifelse( input$fqH > factsdf$N_fqH[ i - 1 ], factsdf$N_fqH[ i - 1 ], input$fqH )
          factsdf$N_fqH[ i ] <- factsdf$N_fqH[ i - 1 ] * exp( ( parameters$b0 - parameters$d0 ) * ( 1 - ( factsdf$N_fqH[ i - 1 ] / parameters$K ) ) ) - ( h )
        }
      }
      
      factsdf <- factsdf %>% gather( key = Scenario, value = N, starts_with( "N" ) )

      factsdf
    } )
    
    output$popPlot <- renderPlot( {
      ggplot( data = theFacts(), 
              aes( x = t, 
                   y = N, 
                   by = Scenario ) ) + 
        geom_line( size = 1.5, 
                   colour = "dodgerblue", 
                   lineend = "round" ) + 
        theme_classic() + 
        theme( axis.title = element_text( size = 16 ), 
               axis.text = element_text( size = 14 ) ) + 
        scale_x_continuous( name = "Time", 
                            breaks = pretty( c( 0, toTime ), 10 ), 
                            limits = c( 0, toTime ), 
                            expand = c( 0, 0 ) ) + 
        scale_y_continuous( name = "Population size", 
                            breaks = pretty( c( 0, max( theFacts()$N ) ), 7 ), 
                            limits = c( 0, 1.2 * max( theFacts()$N ) ), 
                            labels = scales::comma, 
                            expand = c( 0, 0 ) )
    } )
    
    output$ratePlot <- renderPlot( {

      parameters <- list( b0 = ifelse( ( input$b0 + ( 0.5 * input$hqlty ) ) >= 0, input$b0 + ( 0.5 * input$hqlty ), 0 ), 
                          a = ( ( input$d0 - input$b0 ) / input$K ) * ( 2 - input$hqnty ), 
                          d0 = input$d0, 
                          K = input$K )

      ratePlot <- ggplot( data = theFacts(), 
                          aes( x = N ) ) + 
        geom_abline( slope = parameters$a, 
                     intercept = parameters$b0, 
                     size = 1, 
                     colour = "mediumseagreen" ) + 
        geom_abline( slope = 0, 
                     intercept = parameters$d0, 
                     size = 1, 
                     colour = "tomato2" ) + 
        theme_classic() + 
        theme( axis.title = element_text( size = 16 ), 
               axis.text = element_text( size = 14 ) ) + 
        scale_x_continuous( name = "Population size", 
                            limits = c( 0, 1.25 * parameters$K ) ) + 
        scale_y_continuous( name = "Per-capita rate of change", 
                            limits = c( 0, 1.2 * parameters$b0 ) )
      
      ratePlot
    } )
    
  }
)