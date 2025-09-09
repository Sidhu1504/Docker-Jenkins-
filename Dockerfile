# Use official Apache HTTP Server image
FROM docker.io/httpd:latest

# Copy your website files to the default Apache html folder
COPY ./ /usr/local/apache2/htdocs/

# Expose port 80 for HTTP traffic
EXPOSE 80

