# Assignment 1
# Christine Kuryla
# p8124 Graphical Methods for Complex Health Data
# Sept 18, 2023


# Problem 5

library(dagitty)

g <- dagitty('dag {
    X [pos="0,1"]
    Y [pos="1,1"]
    Z [pos="2,1"]
    W [pos="1,0"]
    T [pos="2,2"]
    
    X -> Y -> Z -> T
    X -> W -> Y -> T
    W -> Z
}')
plot(g)

dag_q5 <- dagitty('dag {
    D [pos="0,1"]
    E [pos="1,1"]
    A [pos="2,1"]
    B [pos="3,1"]
    F [pos="4,1"]
    C [pos="1,0"]
    G [pos="4,0"]
    H [pos="5,0"]

    D -> E -> A <- B <- G -> H
    E -> F -> H
    E <- C -> H
    C -> B
    C -> F -> G
    E -> F

}')
plot(dag_q5)

# a) List all paths from C to H

paths(dag_q5, from = "C", to = "H")

# b) Determine whether E is d-separated from G given A,B
dseparated(dag_q5, X = "E", Y = "G", Z = c("A", "B"))
#paths(dag_q5, "E", "G", c("A", "B"))

# c) List the conditional independencies relationships implied by the model with and without the option "type = all.pairs"
# What explains the difference between the two lists, why is the first one shorter than the second?

impliedConditionalIndependencies(dag_q5)
impliedConditionalIndependencies(dag_q5, type = "all.pairs")

# d) Simulate the DAG using simulateSEM(), which associate the DAG with a linear structural equation model. 
# Verify that the Markov blanket property holds for vertex B.
# Do this by examining the p-values (or CIs) for all covariates outside the Markov blanket in the regression of B ~ Mb(B,G) + remaining covariates

sim_sem <- simulateSEM(dag_q5,
            b.lower = -0.7,
            b.upper = 0.7,
            N = 500)

markovBlanket(dag_q5, v = "B")

summary(glm(data = sim_sem, formula = B ~ C + G + A + E + D + F + H))
