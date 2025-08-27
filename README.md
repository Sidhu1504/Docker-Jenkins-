# Building a Complete CI/CD Pipeline with Jenkins, Docker, and GitHub 🚀

This project documents the setup of a Continuous Integration/Continuous Deployment (CI/CD) pipeline. This automated process streamlines the software development workflow, ensuring that code changes are built, tested, and deployed to a live environment quickly and reliably.

## The CI/CD Pipeline Workflow

The entire process is automated and triggered by a change in your GitHub repository. Here's a breakdown of the steps:

### Core Tools

The core tools in this pipeline are:

  * [cite\_start]**Git/GitHub**: A version control system where the application's source code is stored[cite: 21].
  * **Jenkins**: An open-source automation server that acts as the orchestrator of the pipeline. [cite\_start]It listens for changes in the code repository and automates the entire process[cite: 22, 23].
  * **Docker**: A containerization platform that packages the application and all its dependencies into a single, consistent unit called a Docker image. [cite\_start]This ensures the application runs the same way, regardless of the environment[cite: 24, 25].
  * [cite\_start]**Docker Hub**: A cloud-based registry service where Docker images are stored and shared[cite: 26].

### How the Pipeline Works

[cite\_start]The entire process, from a simple code change to a live update, is completed automatically without any manual intervention, saving time and reducing the risk of human error[cite: 31, 47].

1.  [cite\_start]**Code Change (Source)**: When a developer makes a change to the application's source code (e.g., in `index.html` or `Dockerfile`) and pushes it to the GitHub repository, this action triggers the Jenkins job[cite: 34].

2.  **Building the Docker Image (CI)**: Jenkins pulls the latest code from GitHub. Using the `Dockerfile`, Jenkins runs a series of commands to create a new Docker image containing the web application and all necessary components. [cite\_start]This is the **Continuous Integration** part of the process—integrating new code changes into a single build[cite: 36, 37, 38].

3.  **Storing the Image (Registry)**: After the image is successfully built, Jenkins authenticates with Docker Hub, tags the new image, and pushes it to the specified Docker Hub repository. [cite\_start]This makes the image a versioned, portable artifact that can be used for deployment anywhere[cite: 40, 41, 42].

4.  **Deploying the Application (CD)**: This is the **Continuous Deployment** part of the pipeline. [cite\_start]Jenkins performs a post-build action to deploy the application[cite: 44]. [cite\_start]It first checks for and stops any older containers running the previous version[cite: 45]. [cite\_start]Then, it pulls the latest image from Docker Hub and starts a new container, making the updated version of your application live and accessible[cite: 46].

\<br\>

-----

## Pipeline Diagram 🎨
<img width="940" height="591" alt="image" src="https://github.com/user-attachments/assets/a483021b-aa86-4826-8f5b-4b474a3370c7" />

-----

\<br\>

## Prerequisites

[cite\_start]Before you begin, you need to set up your Jenkins agent with Docker[cite: 49]. [cite\_start]The following steps should be performed only once[cite: 50]:

  * [cite\_start]Install Docker Engine on the Jenkins node that will run the job[cite: 51].
  * [cite\_start]Add the `jenkins` user to the `docker` group by running `sudo usermod -aG docker jenkins`[cite: 52, 54].
  * [cite\_start]Restart Jenkins with the command `sudo systemctl restart jenkins`[cite: 55, 58].

To verify the setup, run the `docker version` command in a Jenkins shell step. [cite\_start]It should work without needing `sudo`[cite: 62].

## Docker and GitHub Repositories

[cite\_start]You need to create repositories on both Docker Hub and GitHub for this project[cite: 81].

### Docker Hub

[cite\_start]Create a new repository on Docker Hub to store your Docker images[cite: 83]. [cite\_start]The example uses a repository named `docker-jenkins-cicd`[cite: 84].

### GitHub

[cite\_start]Create a new repository on GitHub to store your application's source code, including the `Dockerfile` and `index.html` file[cite: 140].

[cite\_start]**`Dockerfile`**: This file contains instructions for building the Docker image[cite: 148]. [cite\_start]The example uses an official Apache HTTP Server image, copies the website files to the correct directory, and exposes port 80[cite: 149].

```dockerfile
# Use official Apache HTTP Server image
FROM httpd

# Copy your website files to the default Apache html folder
COPY . /usr/local/apache2/htdocs/

# Expose port 80 for HTTP traffic
EXPOSE 80
```

[cite\_start]**`index.html`**: This is the main HTML file for the web application[cite: 156].

[cite\_start]Once the files are created, commit and push them to your GitHub repository[cite: 187].

### Jenkins Credentials

[cite\_start]To allow Jenkins to interact with your repositories, you need to configure credentials[cite: 272].

**Docker Hub Credentials**

1.  [cite\_start]In Jenkins, navigate to `Manage Credentials -> System -> Global credentials (unrestricted) -> Add Credentials`[cite: 275].
2.  [cite\_start]Select `Username with password` for the kind of credentials[cite: 292].
3.  [cite\_start]Enter your Docker Hub username and the access token as the password[cite: 293].
4.  Set the ID to `dockerhub-creds`. [cite\_start]This ID will be used in the Jenkins pipeline script[cite: 294].

## Jenkins Job Configuration

[cite\_start]Create a new Jenkins job to manage the CI/CD pipeline[cite: 310].

  * [cite\_start]**Source Code Management**: In the job configuration, select **Git** and provide the **Repository URL** of your GitHub repository[cite: 320]. [cite\_start]Specify the branch to build, such as `main`[cite: 321].

  * [cite\_start]**Build Steps**: The build step is responsible for building the Docker image and pushing it to Docker Hub[cite: 348].

    1.  [cite\_start]Add a Build Step of type `Execute Shell`[cite: 349].
    2.  [cite\_start]The script will define variables for the image name and tag, then use `docker build` to create the image and `docker login` with the stored credentials to authenticate with Docker Hub[cite: 350].
    3.  [cite\_start]Finally, it will use `docker push` to upload the newly built image to your Docker Hub repository[cite: 351].

  * [cite\_start]**Post-build Actions**: The post-build action handles the deployment of the application by running a new container from the pushed image[cite: 356].

    1.  [cite\_start]Add a Post-build Action of type `Execute Shell`[cite: 357].
    2.  [cite\_start]The script first checks for and removes any existing containers to ensure a clean deployment[cite: 358].
    3.  [cite\_start]Then, it uses `docker run` to start a new container from the image on Docker Hub, mapping a host port (e.g., 8080) to the container's exposed port 80[cite: 359]. [cite\_start]This makes the web application accessible at `http://<your-server-ip>:8080`[cite: 359].

## Verifying the Build

[cite\_start]Once the job is configured, you can make the first build manually by clicking **Build Now**[cite: 365]. [cite\_start]You can verify the console output to confirm the build, push, and deployment were successful[cite: 390]. [cite\_start]You should also see the new image in your Docker Hub repository[cite: 406].

[cite\_start]Finally, verify that the new Docker container with the name `myhttpd` is present on the node, and you can access your application at `http://server-ip:<portno>`[cite: 436].

-----

## Conclusion

[cite\_start]By combining the power of **Jenkins** for automation, **Docker** for consistent environments, and **GitHub** for version control, you can significantly reduce manual effort and accelerate your software delivery[cite: 438]. [cite\_start]This pipeline ensures that every code change is automatically built into a new Docker image, pushed to Docker Hub, and deployed to a new container, enabling continuous and reliable updates[cite: 439]. [cite\_start]The result is a robust, repeatable, and error-resistant process that allows you to focus on writing code and delivering new features faster[cite: 440].
