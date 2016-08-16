library(shiny)
# 30
 # 150
 # 850
shinyUI(
    fluidPage(
        verticalLayout(
            titlePanel("Carried Value Analysis"),
            fluidRow(
                column(4,
                    wellPanel(
                        h3("Funding History"),
                        inputPanel(
                            numericInput("round_size_1_global", 
                                "Round 1 Size",
                                value = 3, step = 1),
                            numericInput("pre_1_global", 
                                "Pre $ valuation 1", 
                                value = 10, step = 1)
                        ),
                        inputPanel(
                            numericInput("round_size_2_global", 
                                "Round 2 Size",
                                value = 15, step = 1),
                            numericInput("pre_2_global", 
                                "Pre $ valuation 2", 
                                value = 30, step = 1)
                        ),
                        inputPanel(
                            numericInput("round_size_3_global", 
                                "Round 3 Size",
                                value = 50, step = 1),
                            numericInput("pre_3_global", 
                                "Pre $ valuation 3", 
                                value = 150, step = 1)
                        ),
                        inputPanel(
                            numericInput("round_size_4_global", 
                                "Round 4 Size",
                                value = 350, step = 1),
                            numericInput("pre_4_global", 
                                "Pre $ valuation 4", 
                                value = 850, step = 1)
                        )
                    )
                ),
                column(4,
                    wellPanel(
                        h3("Scenario A"),
                        numericInput("investment_1_a", 
                            "Round 1 Investment", value = 1, step = 1),
                        numericInput("investment_2_a", 
                            "Round 2 Investment", value = 6, step = 1),
                        numericInput("investment_3_a", 
                            "Round 3 Investment", value = 25, step = 1),
                        numericInput("investment_4_a", 
                            "Round 4 Investment", value = 50, step = 1),
                        verbatimTextOutput("text_a")
                    )
                ),
                column(4,
                    wellPanel(
                        h3("Scenario B"),
                        numericInput("investment_1_b",
                            "Round 1 Investment", value = 1, step = 1),
                        numericInput("investment_2_b",
                            "Round 2 Investment", value = 6, step = 1),
                        numericInput("investment_3_b",
                            "Round 3 Investment", value = 25, step = 1),
                        numericInput("investment_4_b",
                            "Round 4 Investment", value = 50, step = 1),
                        verbatimTextOutput("text_b")
                    )
                )
            ),
            plotOutput("plot_A")
        )
    )
)
