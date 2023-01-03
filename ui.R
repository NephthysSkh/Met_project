library(shiny)
library(kableExtra)

shinyUI(fluidPage(
  
  #On fera en sorte que la fenetre de selection des variable soit "sticky" pour faciliter le changement de variables pendant la lecture
  tags$style(HTML("div.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  z-index: 1;
}")),

  titlePanel("Metropolitan Opera Archives Explorer"),
  
  sidebarLayout(
    tagAppendAttributes(sidebarPanel(
      #Des Radios Buttons pour la selection de variable d'interet
      radioButtons("radio",
                   label = h3("What are you interested in?"),
                   choices = list("Compositor" = 1,
                                  "Singer" = 2,
                                  "Opera" = 3),
                   selected = 1),
      
      #affichage d'une zone de texte si variable d'interet choisie
      uiOutput("comp"),
      uiOutput("sing"),
      uiOutput("op"),
      
      #un slider pour limiter l'étude dans le temps des graphiques
      sliderInput(inputId = "time",
                  label = "Time restriction on the number of representation:",
                  min = 1883,
                  max = 2018,
                  value = c(1883,2018)),
      hr(),
      fluidRow(column(3, verbatimTextOutput("value"))),
    ),
      class = "sticky",
    ),
    
    #Les Textes/Plots/Tableaux/Images
    mainPanel(
      titlePanel("An Introduction :"),
      uiOutput("uiintrocomp"),
      uiOutput("uiintrosing"),
      uiOutput("uiintrooper"),
      titlePanel("A Few Graphics :"),
      uiOutput("uihistplotcomp"),
      uiOutput("uihistplotsing"),
      uiOutput("uilineplotcomp"),
      uiOutput("uilineplotsing"),
      uiOutput("uilineplotoper"),
      uiOutput('uitable'),
      uiOutput('uioperaimg')
    )
  )
))
