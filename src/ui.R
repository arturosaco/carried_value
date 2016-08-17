library(shiny)
library(shinythemes)
# 30
 # 150
 # 850
shinyUI(
    fluidPage(theme = shinytheme("flatly"),
        verticalLayout(
            titlePanel("Carried Value Analysis"),
            fluidRow(
                column(4,
                    wellPanel(
                        h3("Funding History"),
                        inputPanel(
                            numericInput("round_size_1_global", 
                                "Round 1 Size ($m)",
                                value = 3.7, step = 1),
                            numericInput("pre_1_global", 
                                "Pre valuation 1 ($m)", 
                                value = 16, step = 1)
                        ),
                        inputPanel(
                            numericInput("round_size_2_global", 
                                "Round 2 Size ($m)",
                                value = 20, step = 1),
                            numericInput("pre_2_global", 
                                "Pre valuation 2 ($m)", 
                                value = 86, step = 1)
                        ),
                        inputPanel(
                            numericInput("round_size_3_global", 
                                "Round 3 Size ($m)",
                                value = 59, step = 1),
                            numericInput("pre_3_global", 
                                "Pre valuation 3 ($m)", 
                                value = 281, step = 1)
                        ),
                        inputPanel(
                            numericInput("round_size_4_global", 
                                "Round 4 Size ($m)",
                                value = 88, step = 1),
                            numericInput("pre_4_global", 
                                "Pre valuation 4 ($m)", 
                                value = 525, step = 1)
                        )#,
                        # inputPanel(
                        #     numericInput("latest_valuation_global", 
                        #         "Last Known Valuation ($m)",
                        #         value = NULL, step = 1)
                        # )
                    )
                ),
                column(4,
                    wellPanel(
                        h3("Scenario A"),
                        numericInput("investment_1_a", 
                            "Round 1 Investment ($m)", value = 3, step = 1),
                        numericInput("investment_2_a", 
                            "Round 2 Investment ($m)", value = 6.2, step = 1),
                        numericInput("investment_3_a", 
                            "Round 3 Investment ($m)", value = 22.7, step = 1),
                        numericInput("investment_4_a", 
                            "Round 4 Investment ($m)", value = 6.4, step = 1),
                        verbatimTextOutput("text_a")
                    )
                ),
                column(4,
                    wellPanel(
                        h3("Scenario B"),
                        numericInput("investment_1_b",
                            "Round 1 Investment ($m)", value = 3, step = 1),
                        numericInput("investment_2_b",
                            "Round 2 Investment ($m)", value = 6.2, step = 1),
                        numericInput("investment_3_b",
                            "Round 3 Investment ($m)", value = 22.7, step = 1),
                        numericInput("investment_4_b",
                            "Round 4 Investment ($m)", value = 6.4, step = 1),
                        verbatimTextOutput("text_b")
                    )
                )
            ),
            plotOutput("plot_A")
        )
    )
)
