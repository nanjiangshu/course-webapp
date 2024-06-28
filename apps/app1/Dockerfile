# Use the official R base image
FROM r-base:latest

# Install necessary packages
RUN R -e "install.packages('shiny', repos='https://cran.rstudio.com/')"

# Create and set the working directory
WORKDIR /usr/src/app

# Copy the app to the container
COPY app.R .

# Expose port 3838 to the outside world
EXPOSE 3838

# Run the app
CMD ["R", "-e", "shiny::runApp('./app.R', host = '0.0.0.0', port = 3838)"]

