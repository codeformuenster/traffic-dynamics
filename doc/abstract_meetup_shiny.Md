# Look, something shiny: How to use R Shiny to make Münster traffic data accessible

## Abstract

About a year ago, we stumbled upon rich datasets on *traffic dynamics* of Münster: 
count data of bikes, cars, and bus passengers of high resolution.
Since that day we have been crunching, modeling, and visualizing it.
To involve local stakeholders and NGOs (e.g., the [IG Fahrradstadt Münster](http://fahrradstadt.ms)), we found the R Shiny framework to be very useful.

Shiny is probably the fastest way to take your R projects online.
According to [RStudio](https://shiny.rstudio.com/), it 
> "is an R package that makes it easy to build interactive web apps straight from R. You can host standalone apps on a webpage or embed them in R Markdown documents or build dashboards. You can also extend your Shiny apps with CSS themes, htmlwidgets, and JavaScript actions."

We would like to introduce Shiny to you using the following topics:

 1. Why we love Shiny, and why you should, too
 2. How Shiny works, from code to browser
 3. How to deploy your R Shiny project with Docker
 4. Our Shiny project [traffic dynamics](https://traffics.codeformuenster.org)
 5. Plotting results of Bayesian and frequentist models within Shiny
 6. Group discussion: what else to present with Shiny?

You will not have to bring much previous knowledge to our talk.
A basic understanding of how R code works will take you far.
The part about statistical modeling will be as intuitive as possible.
Overall, we will try to *keep it simple and shiny*.

All parts of our talk will be connected to traffic data for Münster.
We look forward to your feedback and ideas for more analyses.
You find our *traffic dynamics* projects on Code for Münster's [github page](https://github.com/codeformuenster).


## About the speakers
The speakers Thomas Kluth and Thorben Jensen are members of [Code for Münster](http://codeformuenster.org).
We meet each Tuesday at 18:30 at the Dreiklang bar to make our city a better place by coding. New coders are always welcome!

Thomas Kluth has studied Computer Science in Münster and Bremen.
During his currently ongoing (close-to-be-finished) Linguistics PhD in Bielefeld, he models human cognitive behavior.
Using computational cognitive models, he aims to link spatial language use with perceptual mechanisms such as visual attention.
The statistical analysis of empirical data convinced him to use R and Bayesian modeling to explain almost everything.
He is looking forward to applying his skill set to real-world domains for creating a sustainable future.

Thorben Jensen has studied, designed, and implemented predictive models since more than 10 years.
After studying modeling and computer science in 5 countries, he graduated from the PhD program at Delft University of Technology.
His PhD thesis and other publications propose increased use of optimization methods and automation when building simulations with software agents.
When consulting clients on Data Science, he enjoys making predictions intuitive with R Shiny.
