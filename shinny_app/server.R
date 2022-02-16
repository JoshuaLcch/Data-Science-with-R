library(shiny)
library(readr)
library(caret)
library(e1071)

# import dataset
Admission_Predict_Ver1_1 <- read_csv("Admission_Predict_Ver1.1.csv")
Admission_Predict_Ver1_1 <- Admission_Predict_Ver1_1[, -c(1)]
# set the Chance of Admit to 0 or 1
count = 1
for(r in Admission_Predict_Ver1_1$`Chance of Admit`){
    if(r >= 0.8){
        Admission_Predict_Ver1_1$`Chance of Admit`[count] <- 1
    }
    else{
        Admission_Predict_Ver1_1$`Chance of Admit`[count] <- 0
    }
    count = count+1
}
Admission_Predict_Ver1_1$`Chance of Admit` <- as.factor(Admission_Predict_Ver1_1$`Chance of Admit`)

# data partition
set.seed(20191202)
train.ind <- createDataPartition(Admission_Predict_Ver1_1$`Chance of Admit`, p = 0.75, list = F)
Train <- Admission_Predict_Ver1_1[train.ind, ]
Test <- Admission_Predict_Ver1_1[-train.ind, ]

shinyServer(function(input, output) {
    rv <- reactiveValues(inputValues = 0, flag = FALSE, index = 0)
    observeEvent(input$predict_btn, {
        # create reaction values
        rv$inputValues = c(input$GRE, input$TOEFL, input$uni_rate, input$SOP, input$LOR, input$CGPA, input$research)
        # print the values of input
        for (i in rv$inputValues) print(i)
        # flag: prevent the user from inputing nothing
        rv$flag <- FALSE
        for (i in rv$inputValues){
            if(i != -1){
                rv$flag <- TRUE
            }
        }
        print(rv$flag)
        
        # get the index of those inputs who are not -1
        rv$index <- which(rv$inputValues != -1)
        print(rv$index)
        if(length(rv$index) == 0){
            output$result <- renderUI({
                tags$h3("Please at least input ONE Attribute!", class="font noinput", align="center")
            })
        }else{
            # get the right train set, test set columns by index
            train <- Train[,  c(rv$index, 8)]
            test <- Test[,  c(rv$index, 8)]
            print(head(train))
            print(head(test))
            
            # train the dataset
            model.lr <- glm(`Chance of Admit` ~ ., data = train, family = "binomial")
            
            
            # test the accuracy
            p <- predict(model.lr, test, type = "response")
            labels <- ifelse(p > 0.5, "1", "0")
            acc <- table(labels == test$`Chance of Admit`)/length(test$`Chance of Admit`)
            
            # predict the input
            newdat <- as.data.frame.list(rv$inputValues[rv$index])
            names(newdat) <- names(Train[0,  rv$index])
            print(newdat)
            
            p <- predict(model.lr, newdat)
            print(p)
            result <- ifelse(p > 0.5, "You will get an offer!", "You won't get an offer QAQ")
            img_src <- ifelse(p > 0.5, "https://media.giphy.com/media/xT0xezQGU5xCDJuCPe/giphy.gif", "https://media.giphy.com/media/26ybwvTX4DTkwst6U/giphy.gif")
            
            # render the result
            
            text_accuracy <- paste("Model Accuracy: ", round(acc[["TRUE"]], digits = 2))
            text_result <- paste("Result: ", result)
            
            output$result <- renderUI({
                div(
                    tags$h3(text_accuracy, class="font acc", align="center"),
                    tags$h3(text_result, class="font result", align="center"),
                    tags$div(tags$img(src=img_src, height = '250px'), align="center")
                )
                
            })
            
        }
    }) 
    
})