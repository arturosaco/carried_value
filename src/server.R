# docker run -p 3838:3838 -v /Users/asc/Projects/carried_value/src/:/mounted_f -it arturosaco/docker-shiny /bin/bash

compute.round <- function(list.in, new_investment, new_round_size, new_pre){
    
    ### inputs:
    # - index investment
    # - n index shares
    # - new pre
    # - total investment
    # - n total shares

    ### outputs
    # - new n_index_shares
    # - new ownership
    # - new pre (appended)
    # - total investment (appended)
    
    investment_h <- list.in[["investment_h"]]
    round_size_h <- list.in[["round_size_h"]]
    pre_h <- list.in[["pre_h"]]
    n_shares_h <- list.in[["n_shares_h"]]
    n_shares_owned_h <- list.in[["n_shares_owned_h"]]
    n_shares_owned_round <- list.in[["n_shares_owned_round"]]
    

    price.per.share <- new_pre / n_shares_h[length(n_shares_h)]
    new.shares.owned <- new_investment / price.per.share
    new.shares <- new_round_size / price.per.share
    n_shares_h.out <- c(n_shares_h, n_shares_h[length(n_shares_h)] + new.shares)
    n_shares_owned_h.out <- c(n_shares_owned_h, 
        n_shares_owned_h[length(n_shares_owned_h)] + new.shares.owned)
    investment_h.out <- c(investment_h, new_investment)
    round_size_h.out <- c(round_size_h, new_round_size)
    pre_h.out <- c(pre_h, new_pre)
    n_shares_owned_round.out <- c(n_shares_owned_round, new.shares.owned)

    return(
        list(
            investment_h = investment_h.out,
            round_size_h = round_size_h.out, 
            pre_h = pre_h.out, 
            n_shares_h = n_shares_h.out, 
            n_shares_owned_h = n_shares_owned_h.out,
            n_shares_owned_round = n_shares_owned_round.out
        )
    )
}

# global.parameters <- list(
#     n_shares_h = c(1000), 
#     round_size_h = c(1), 
#     pre_h = c(10)
# )

# case.parameters <- list(
#     investment_h = c(1),
#     n_shares_owned_h = c(90.90909091),
#     n_shares_owned_round = c(90.90909091)
# )

## the user inputs are:
# investment_h
# 

# ==========================
# = Your Comment Goes here =
# ==========================

library(data.table)
library(magrittr)
library(ggplot2)
library(shiny)
library(wesanderson)

cap.table <- function(input){
    n.shares.dummy <- 100000
    list(
        investment_h = c(input$investment_1),
        round_size_h = c(input$round_size_1), 
        pre_h = c(input$pre_1), 
        n_shares_h = c(n.shares.dummy), 
        n_shares_owned_h = c(input$investment_1/ (input$pre_1 / n.shares.dummy)),
        n_shares_owned_round = c(input$investment_1/ (input$pre_1 / n.shares.dummy))
     ) %>%
        compute.round(input$investment_2, input$round_size_2, input$pre_2) %>%
        compute.round(input$investment_3, input$round_size_3, input$pre_3) %>%
        compute.round(input$investment_4, input$round_size_4, input$pre_4) %>%
        data.frame %>%
        data.table ->
    funding.history.dt
     

    latest.valuation <- funding.history.dt$round_size_h[nrow(funding.history.dt)] +
        funding.history.dt$pre_h[nrow(funding.history.dt)]
    latest.price.per.share <- latest.valuation / 
        funding.history.dt$n_shares_h[nrow(funding.history.dt)]

    funding.history.dt[, carried.value := latest.price.per.share * n_shares_owned_round]
    funding.history.dt[, multiple := carried.value / investment_h]
    funding.history.dt[, profit := carried.value - investment_h]
    funding.history.dt[, ownership := n_shares_owned_h / n_shares_h]
    funding.history.dt[, round_id := 1:.N]
    return(funding.history.dt)

}

plot.cap.table <- function(funding.history.dt){
    setnames(funding.history.dt, c("profit", "investment_h"), c("Return", "Cost"))

    funding.history.dt[, list(round_id, scenario, multiple, Return, Cost)] %>% 
        melt(id.vars = c("round_id", "scenario", "multiple")) %>%
        data.frame ->
    data.m
    
    data.m$variable <- factor(data.m$variable, c("Return", "Cost"))
    data.m <- data.m[order(data.m$variable, decreasing = TRUE), ]
    
    data.m %>%
        ggplot(aes(x = round_id,
            y = value, fill = variable)) +
        facet_wrap(~scenario, nrow = 1) + 
        geom_bar(stat = "identity", position = "stack") + 
        ylab("Carried Value") + 
        xlab("Round") + theme_bw() +
        scale_fill_manual(values = wes_palette("Royal1")) +
        geom_text(data = data.m[data.m$variable == "Return", ], 
            aes(x = round_id, 
                label = paste("Multiple:", round(multiple, 1), "\n Return: $", round(value, 1), "m") , 
                y = value))


    # funding.history.dt %>% ggplot(aes(x = round_id, y = multiple)) + 
    #     geom_line() + geom_point()

}

function(input, output) {
    ### To avoide the complexity of changing the number of rounds 
    ### set it initially to 4

    cap.table.a <- reactive({
        input.l <- reactiveValuesToList(input)
        input_a <- input.l[grepl("\\_a|\\_global", names(input.l))]
        names(input_a) <- gsub("\\_a|\\_global", "", names(input_a))
        cap.a <- cap.table(input_a)
        cap.a[, scenario := "A"]
        return(cap.a)
    })
    cap.table.b <- reactive({
        input.l <- reactiveValuesToList(input)
        input_b <- input.l[grepl("\\_b|\\_global", names(input.l))]
        names(input_b) <- gsub("\\_b|\\_global", "", names(input_b))
        cap.b <- cap.table(input_b)
        cap.b[, scenario := "B"]
        return(cap.b)
    })
    
    output$text_a <- renderText({
        cap <- cap.table.a()
        print(cap)
        ownership <- cap$ownership[nrow(cap)]
        carried.value <- sum(cap$carried.value)
        cost <- sum(cap$investment_h)
        paste0(
            "Ownership: ", round(100 * ownership, 1), "%", "\n",
            "Carried Value: $", round(carried.value, 1), "m \n",
            "Cost: $", cost
        )
    })
    output$text_b <- renderText({
        cap <- cap.table.b()
        print(cap)
        ownership <- cap$ownership[nrow(cap)]
        carried.value <- sum(cap$carried.value)
        cost <- sum(cap$investment_h)
        paste0(
            "Ownership: ", round(100 * ownership, 1), "%", "\n",
            "Carried Value: $", round(carried.value, 1), "m \n",
            "Cost: $", cost
        )
    })

    output$plot_A <- renderPlot({
        cap.a <- cap.table.a()
        cap.b <- cap.table.b()
        cap <- rbind(cap.a, cap.b)        
        plot.cap.table(cap)
    })
    
}




# COPY shiny-server.sh /usr/bin/shiny-server.sh

# RUN mkdir /srv/shiny-server
# RUN wget -P /srv/shiny-server https://raw.githubusercontent.com/arturosaco/carried_value/master/src/server.R
# RUN wget -P /srv/shiny-server https://raw.githubusercontent.com/arturosaco/carried_value/master/src/ui.R

# CMD ["/usr/bin/shiny-server.sh"]



# RUN wget -O /etc/shiny-server/shiny-server.conf https://raw.githubusercontent.com/arturosaco/carried_value/master/src/shiny-server.conf