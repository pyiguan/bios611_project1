library(shiny);
library(quanteda);
library(quanteda.textmodels);
library(readr);
source("utils.R");

args <- commandArgs(trailingOnly=T);
port <- as.numeric(args[[1]]);

model <- read_rds("./models/textmodel")

# Define UI
ui <- fluidPage(
    # Make a text input box
    textInput("text", label = h3("Test COVID-19 URL"), value = "", placeholder = "Enter URL..."),
    submitButton(text = "Predict domain maliciousness..."),
    hr(),
    textOutput("value")
)


# Define server logic required to calculate domain probability
server <- function(input, output) {
        output$value <- renderText({
        cleandfm <- remove_subdomain(input$text) %>% dfm_creator(3)
        t <- try(predict(model, cleandfm))
        if (inherits(t, "try-error")) 
            return("Too few ngrams to make a prediction")
        malprob <- percent_format()(predict(model, cleandfm, type = "probability")[,2])
        return(paste("This domain has a ", as.character(malprob), "chance of being malicious."))
        })
        
    }
# Run the application 
print(sprintf("Starting shiny on port %d", port));

shinyApp(ui = ui, server = server, options = list(port=port, host="0.0.0.0"))


