
theme_ica17 <- function() {
    require(ggplot2)
    theme_gray() +
        theme(text = element_text(family = "Roboto", size = 13, color = "black"),
              axis.text = element_text(color = "black"),
              plot.title = element_text(face = "bold"),
              legend.text = element_text(size = 14),
              plot.background = element_rect(fill = "#ffffff"),
              panel.background = element_rect(fill = "#ffffff"),
              legend.background = element_rect(fill = "#ffffff"),
              legend.key = element_rect(color = "transparent", fill = "transparent"),
              panel.grid.minor = element_line(
                  linetype = "dotted", color = "#666666", size = .10),
              panel.grid.major = element_line(
                  linetype = "dashed", color = "#666666", size = .125))
}
