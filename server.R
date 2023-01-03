library(shiny)

shinyServer(function(input, output) {
  
#un bouton de selection de compositeur
  output$comp <- renderUI({
    if (input$radio %in% c(1,3)){
      selectizeInput(
        inputId = "compositor",
        label = "Compositor",
        #autofill possible
        choices = unique(data$TI_COMP),
        #On choisira un compositeur connu par défaut
        selected = "Richard Wagner",
        multiple = FALSE, # allow for multiple inputs
        options = list(create = FALSE) # if TRUE, allows newly created inputs
      )
    }
  })
  
  #un bouton de selection de chanteur
  output$sing <- renderUI({
    if (input$radio == 2){
      selectizeInput(
        inputId = "singer",
        label = "Singer",
        #Un formatage des chanteurs est necessaire pour la selection
        choices = unique(unlist(strsplit(data$PERF_NAME, "\\|"))),
        #On choisira un chanteur connu par défaut
        selected = "Luciano Pavarotti",
        multiple = FALSE, # allow for multiple inputs
        options = list(create = FALSE) # if TRUE, allows newly created inputs
      )
    }
  })
  
  #un bouton de selection d'opéra (il faudra selectionner le compositeur ET le titre de l'opéra, 
  #pour éviter une erreur où un titre d'opéra a été utilisé par plusieurs compositeurs)
  output$op <- renderUI({
    if (input$radio == 3){
      selectizeInput(
        inputId = "opera",
        label = "Opera",
        #On ne propose que des opéras qui sont écrit par le compositeur selectionner précedemment
        choices = unique(data[which(data$TI_COMP == input$compositor), 'TI_TINAME']),
        #pas de préselection
        selected = NULL,
        multiple = FALSE, # allow for multiple inputs
        options = list(create = FALSE) # if TRUE, allows newly created inputs
      )
    }
  })
  
  #on stocke les différents plots, par exemple l'histogramme d'un compositeur ci-dessous
  output$histPlotComp <- renderPlot({
    histcompfun(nbr = input$radio, compositor = input$compositor, singer = "", data = dataforhist, vartime = input$time)
  })
  #l'histogramme d'un chanteur
  output$histPlotSing <- renderPlot({
    histcompfun(nbr = input$radio, compositor = "", singer = input$singer, data = dataforhist, vartime = input$time)
  })
  
  #Plot nombre de rep d'un compositeur
  output$LinePlotComp <- renderPlot({
    linecompfun(nbr = input$radio, compositor = input$compositor, singer = "", opera = "", data = data, vartime = input$time)
  })
  #Plot nombre de rep d'un chanteur
  output$LinePlotSing <- renderPlot({
    linecompfun(nbr = input$radio, compositor = "", singer = input$singer, opera = "", data = data, vartime = input$time)
  })
  #Plot nombre de rep d'un Opéra
  output$LinePlotOper <- renderPlot({
    linecompfun(nbr = input$radio, compositor = input$compositor, singer = "", opera = input$opera, data = data, vartime = input$time)
  })
  
  #Le tableau liés aux représentations d'un chanteur
  output$table <- renderDataTable({
    nbrandfirst(singer = input$singer, data = data)
  }, options = list(paging = FALSE, searching = FALSE))
  
  #Les images liés à un Opéra
  output$operaimg <- renderPlot({
    ggoperaimg(compositor = input$compositor, opera = input$opera)
  }, height = 1000, width = 1000)
  
  
  #Conditional UI : affichage des Textes/Plots/Tableau/Images, uniquement si la variable d'intérêt à été séléctionnée
  
  output$uiintrocomp <- renderUI({
    if (input$radio == 1){
      renderText(introfun(compsingoper = input$compositor))
    }
  })
  output$uiintrosing <- renderUI({
    if (input$radio == 2){
      renderText(introfun(compsingoper = input$singer))
    }
  })
  output$uiintrooper <- renderUI({
    if (input$radio == 3){
      renderText(introfun(compsingoper = input$opera))
    }
  })
  
  output$uihistplotcomp <- renderUI({
    if (input$radio == 1){
      plotOutput("histPlotComp")
    }
  })
  output$uihistplotsing <- renderUI({
    if (input$radio == 2){
      plotOutput("histPlotSing")
    }
  })
  
  output$uilineplotcomp <- renderUI({
    if (input$radio == 1){
      plotOutput("LinePlotComp")
    }
  })
  output$uilineplotsing <- renderUI({
    if (input$radio == 2){
      plotOutput("LinePlotSing")
    }
  })
  output$uilineplotoper <- renderUI({
    if (input$radio == 3){
      plotOutput("LinePlotOper")
    }
  })
  
  output$uitable <- renderUI({
    if (input$radio == 2){
      dataTableOutput("table")
    }
  })
  
  output$uioperaimg <- renderUI({
    if (input$radio == 3){
      plotOutput("operaimg")
    }
  })
  
})
