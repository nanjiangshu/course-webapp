library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Basic Shiny App"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Number of observations:", min = 1, max = 1000, value = 500)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    hist(rnorm(input$n))
  })
}

# Run the application
shinyApp(ui = ui, server = server)

